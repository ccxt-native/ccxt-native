import { swiftBinaries, originalFiles, androidBinaries } from './filepaths';
import { isArray, capitalize, prefixWith } from './util';
import { createGeneratedFile, createWrapperFile, customTypes, allExchanges, wsExchanges } from './shared';

function tsTypeToGo(tsType: string): string {
    if (!tsType) return "void";

    // 1) [A,B][] → []struct{ A, B }
    const tupArr = tsType.match(/^\s*\[([^,\]]+),\s*([^,\]]+)]\s*\[\]\s*$/);
    if (tupArr) {
        const a = tsTypeToGo(tupArr[1].trim());
        const b = tsTypeToGo(tupArr[2].trim());
        return `[]struct{ A ${a}; B ${b} }`;
    }

    // 2) T[], T[][], T[][][] → []T, [][]T, [][][]T
    const arrayDepthMatch = tsType.match(/^(\w+)((\[\])+)\s*$/);
    if (arrayDepthMatch) {
        const baseType = arrayDepthMatch[1];
        const brackets = arrayDepthMatch[2];
        const depth = (brackets.match(/\[\]/g) || []).length;

        let inner = tsTypeToGo(baseType);
        for (let i = 0; i < depth; i++) {
            inner = `[]${inner}`;
        }
        return inner;
    }

    // 3) tuple [T, U, V] → struct { F0 T; F1 U; F2 V }
    const tupleMatch = tsType.match(/^\[\s*([^,\]]+\s*,\s*[^,\]]+.*?)\s*\]$/);
    if (tupleMatch) {
        const inner = tupleMatch[1]
            .split(",")
            .map((p, i) => `F${i} ${tsTypeToGo(p.trim())}`)
            .join("; ");
        return `struct { ${inner} }`;
    }

    // 4) collapse Partial<X> → X
    tsType = tsType.replace(/Partial<\s*([^>]+?)\s*>/g, "$1");

    const mapSingle = (t: string): string =>
        t
            .replace(/\bobject\b/g, "[]byte")
            .replace(/\bnumber\b/g, "float64")
            .replace(/\bstring\b/g, "string")
            .replace(/\bboolean\b/g, "bool")
            .replace(/\bany\b/g, "[]byte")
            .replace(/\bundefined\b/g, "[]byte")
            .replace(/\bnull\b/g, "[]byte")
            .replace(/\bvoid\b/g, "void")
            .replace(/\bDict\b/g, "map[string][]byte")
            .replace(/\bNullableDict\b/g, "map[string][]byte")
            .replace(/\bList\b/g, "[]byte")
            .replace(/\bNullableList\b/g, "[]byte")
            .replace(/\bNum\b/g, "float64")
            .replace(/\bInt\b/g, "int")
            .replace(/\bint\b/g, "int")
            .replace(/\bStr\b/g, "string")
            .replace(/\bStrings\b/g, "[]string")
            .replace(/\bBool\b/g, "bool")
            .replace(/\bIndexType\b/g, "[]byte")
            .replace(/\bOrderSide\b/g, "string")
            .replace(/\bOrderType\b/g, "string")
            .replace(/\bMarketType\b/g, "string")
            .replace(/\bSubType\b/g, "*string")
            .trim();

    // 5) union handling
    if (tsType.includes("|")) {
        const parts = tsType.split("|").map(p => p.trim());

        const isLit   = (p: string) => /^'[^']*'$/.test(p);
        const isStrKw = (p: string) => p === "string";
        const isStrAl = (p: string) => p === "Str";
        const isUndef = (p: string) => p === "undefined";
        const isNull  = (p: string) => p === "null";
        const isStrAr = (p: string) => p === "string[]";

        if (parts.every(p => isLit(p) || isStrKw(p) || isStrAl(p) || isUndef(p) || isNull(p))) {
            return parts.some(isUndef) || parts.some(isNull) ? "*string" : "string";
        }

        if (parts.every(p => isStrAr(p) || isUndef(p) || isNull(p))) {
            return "*[]string";
        }

        if (parts.length === 2 && (parts.some(isUndef) || parts.some(isNull))) {
            const base = parts.find(p => !isUndef(p) && !isNull(p))!;
            const mapped = mapSingle(base);
            return mapped.startsWith("*") ? mapped : `*${mapped}`;
        }

        return "[]byte";
    }

    // 6) single token
    return mapSingle(tsType);
}

const goMethodDeclaration = (methodName: string, params: {[key: string]: [string, string | null]}) => {
    const arrayParams: string[] = [];
    const customTypeParams: string[] = [];
    const callParams: string[] = [];
    const headerParams: string[] = [];
    const optionalParams: [string, string][] = [];
    Object.keys(params).forEach((paramName: string) => {
        const [paramType, defaultValue] = params[paramName];
        if (paramName === 'type') {
            paramName = 'typeVar';
        }
        if (defaultValue !== 'undefined') {
            let newName = paramName;
            let goType = tsTypeToGo(paramType)
            if (customTypes.includes(paramType)) {
                customTypeParams.push(paramName);
                newName = `${paramName}_object`;
                goType = 'string';
            } else if (isArray(paramType)) {
                arrayParams.push(paramName);
                newName = `${paramName}_arr`;
                goType = 'string';
            } else if (paramName === 'params') {
                newName = 'decoded';
            }
            headerParams.push(`${paramName} ${goType}`);
            callParams.push(newName);
        } else {
            optionalParams.push([paramName, paramType]);
            callParams.push(paramName);
        }
    });
    const capsMethodName = capitalize(methodName);
    const sep = "\n\t\t";
    const customTypeParamsCode = prefixWith(customTypeParams, sep) + customTypeParams.map(paramName => `${paramName}_object := ParseJSON(${paramName})`).join(sep);  // stringify custom types
    // const arrayParamsCode = prefixWith(arrayParams, sep) + arrayParams.map(paramName => `${paramName}_arr := strings.Split(${paramName}, ",")`).join(sep);  // stringify custom types  // probably unnecessary, as the array parameters are already strings
    return `
    func (e *CCXTGoExchange) ${capsMethodName}(${headerParams.join(", ")}) ([]byte, error) {${customTypeParamsCode}
        var decoded map[string]interface{}
        if err := json.Unmarshal(params, &decoded); err != nil {
            return nil, err
        }
        ${optionalParams.map(([paramName, paramType]) => {
        
            return `
        var ${paramName} interface{} = nil
        if v, ok := decoded["${paramName}"]; ok && v != nil {
            if f, ok := v.([]interface{}); ok {
                ${paramName} = f
            } else {
                ${paramName} = v
            }
            delete(decoded, "${paramName}")
        }`
        }).join("\n")
        }
        ${arrayParams.map (paramName => `${paramName}_arr := strings.Split(${paramName}, ",")`).join("\n")}
        res := <-e.exchange.${capsMethodName}(${callParams.join(', ')})
        if err, ok := res.(error); ok {
            return nil, err
        }
        sanitised := sanitise(res)
        return json.Marshal(sanitised)
    }`
}



const goWsMap = () => {
    return `
    wsMap := map[string]bool{
        ${allExchanges.map (exchange => `"${exchange}": ${wsExchanges.includes (exchange).toString ()}`).join(",\n        ")},
    }
`
}

const inserts = (swift: boolean) => ({
    rest: {
        goModStart: `module github.com/ccxt-native/swift
go 1.24.4

require github.com/ccxt/ccxt/go/v4 v4.4.89

replace github.com/ccxt/ccxt/go/v4 => ../../go/v4
`,
        imports: '   ccxt "github.com/ccxt/ccxt/go/v4"',
        library: 'ccxt',
        binaryPath: swift ? swiftBinaries.rest : androidBinaries.rest,
        wsMap: '',
        instantiation: `
    var inst, ok = ccxt.DynamicallyCreateInstance(exchangeName, config)
`,
    },
    pro: {
        goModStart: `module github.com/ccxt-native/swift-pro
go 1.24.4

require github.com/ccxt/ccxt/go/v4 v4.4.89
require github.com/ccxt/ccxt/go/v4/pro v0.0.0-20250806100000-000000000000

replace github.com/ccxt/ccxt/go/v4 => ../../go/v4
replace github.com/ccxt/ccxt/go/v4/pro => ../../go/v4/pro
`,
        imports: `   ccxt "github.com/ccxt/ccxt/go/v4"
    ccxtPro "github.com/ccxt/ccxt/go/v4/pro"`,
        library: 'ccxtPro',
        binaryPath: swift ? swiftBinaries.pro : androidBinaries.pro,
        wsMap: goWsMap (),
        instantiation: `
    var inst ccxt.ICoreExchange
	var ok bool
	if wsMap[exchangeName] {
		inst, ok = ccxtPro.DynamicallyCreateInstance(exchangeName, config)
	} else {
		inst, ok = ccxt.DynamicallyCreateInstance(exchangeName, config)
	}
`
    },
});

export default function transpileGoWrapper () {
    for (const os of ['swift', 'android']) {
        for (const [key, insert] of Object.entries(inserts(os === 'swift'))) {
            const filePath = insert.binaryPath;
            createWrapperFile(
                goMethodDeclaration, 
                originalFiles.gowrapper,
                `${filePath}/ccxtwrapper.go`,
                {
                    '\\[imports\\]': insert.imports,
                    '\\[library\\]': insert.library,
                    '\\[instantiation\\]': insert.instantiation,
                    '\\[wsMap\\]': insert.wsMap,
                },
                key === 'pro'
            );
            createGeneratedFile(
                `${filePath}/go.mod`,
                [],
                originalFiles.gomod,
                {
                    '^': insert.goModStart,
                }
            );
            createGeneratedFile(`${filePath}/go.sum`, [], originalFiles.gosum, {}, true);
        }
    }
}

transpileGoWrapper ();
