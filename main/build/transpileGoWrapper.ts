import * as fs from 'fs';
import { swiftBinaries, originalFiles, androidBinaries, ccxtPaths, ccxtDir } from './filepaths';
import { isArray, capitalize, prefixWith } from './util';
import { createGeneratedFile, createWrapperFile, customTypes, allExchanges, wsExchanges, simpleTypes, getExchangeProperties, skippedProperties } from './shared';
import { Property } from './types';
import ccxt from '../../../js/ccxt.js';

const specificTypeMapping = {
    // TODO: remove this, it's error prone
    // shouldn't be needed if everything was typed properly
    // ! items will need to be removed as types become more correct, if the getters/setters fail check here
    'accountsById': 'interface{}',
    'bidsasks': '*sync.Map',
    'commonCurrencies': 'map[string]interface{}',
    'exceptions': 'map[string]interface{}',
    'fees': 'map[string]interface{}',
    'fundingRates': 'interface{}',
    'headers': 'interface{}',
    'limits': 'map[string]interface{}',
    'liquidations': '*sync.Map',
    'markets_by_id': '*sync.Map',
    'myLiquidations': '*sync.Map',
    'myTrades': 'interface{}',
    'ohlcvs': 'interface{}',
    'orderbooks': '*sync.Map',
    'orders': 'interface{}',
    'precision': 'map[string]interface{}',
    'tickers': '*sync.Map',
    'timeout': 'int64',
    'tokenBucket': 'map[string]interface{}',
    'trades': 'interface{}',
    'transactions': '*sync.Map',
    'triggerOrders': 'interface{}',
    'userAgents': 'map[string]interface{}',
    'throttler': '*Throttler',
    'baseCurrencies': '*sync.Map',
    'quoteCurrencies': '*sync.Map',
    'currencies_by_id': '*sync.Map',
    'clients': 'map[string]interface{}',
}

// /**
//  * Extracts type names and global function names from all files in a directory
//  * @param dirPath - The path to the directory to extract type and function names from.
//  * @returns A set of type and function names with braces.
//  * @regards copied from ccxt/build/goTranspiler.ts
//  * TODO: just import the function from ccxt/build/goTranspiler.ts
//  */
// function extractTypeAndFuncNames(dirPath: string): Set<string> {
//     const results = new Set<string>([
//         'Precise',
//         'DECIMAL_PLACES',
//         'SIGNIFICANT_DIGITS',
//         'TICK_SIZE',
//         'NO_PADDING',
//         'PAD_WITH_ZERO',
//         'TRUNCATE',
//         'ROUND',
//         'toFixed',
//         'throwDynamicException'
//     ]);
    
//     const files = fs.readdirSync(dirPath);
//     for (const file of files) {
//         if (file.startsWith('exchange')) {
//             const fullPath = path.join(dirPath, file);
        
//             // Skip directories or non-files
//             const stat = fs.statSync(fullPath);
//             if (!stat.isFile()) continue;
        
//             const content = fs.readFileSync(fullPath, "utf-8");
//             const lines = content.split("\n");
        
//             for (const line of lines) {
//                 // Only match lines that start with type or func
//                 if (!(
//                     /^\s*func\s+/.test(line) ||
//                     /^\s*type\s+\w+\s+(?:struct\s*\{|interface\s*\{|func\s*\()/.test(line)
//                 )) continue;
        
//                 const trimmed = line.trim();
        
//                 // Exclude lines that are just "type" or "func"
//                 if (/^(type|func)$/.test(trimmed)) continue;
        
//                 const parts = trimmed.split(/\s+/);
//                 if (parts.length < 2) continue;
        
//                 let name = parts[1].split("(")[0]; // keep only before `(`
//                 if (name.trim() !== "") results.add(name);
//             }
//         }
//     }
//     results.delete("Exception");
//     return results;
// }

// const ccxtMethodsAndTypes = extractTypeAndFuncNames(`${ccxtDir}/go/v4`);

// /**
//  * Adds the package to prefix all methods and types, e.g. MarketInterface -> ccxt.MarketInterface
//  * @param content The exchange file as a string
//  * @param packageName The package name to add.
//  * @returns The content with the package prefix added.
//  * @regards copied from ccxt/build/goTranspiler.ts
//  * TODO: just import the function from ccxt/build/goTranspiler.ts
//  */
// function addPackagePrefix(content: string, methodsAndTypes: Set<string>, packageName: string = 'ccxt') {
//     const pattern = Array.from(methodsAndTypes).join("|");
//     // any of the method or type names that are not preceded by a `.`, but `...` is allowed e.g. MarketInterface, or ...MarketInterface but not .MarketInterface
//     const regex = new RegExp(`(?<![A-Za-z0-9_\\)\\}]\\.)\\b(${pattern})\\b`, "g");
//     const variadicRegex = new RegExp(`(?<=\\.\\.\\.)(${pattern})\\b`, "g");
//     return content
//         .split("\n")
//         .map(line => {
//             if (/^\s*(func|type)\b/.test(line)) {
//                 // For func/type lines, only process the part after the declaration
//                 const declarationMatch = line.match(/^(func(?: \(\w+ \*?\w+\))? \w+)\s*(\(.*)/);
//                 if (declarationMatch) {
//                     const declaration = declarationMatch[1];
//                     return declaration + declarationMatch[2].replace(regex, (match) => `${packageName}.${capitalize(match)}`).replace(variadicRegex, (match) => `${packageName}.${capitalize(match)}`);
//                 }
//                 return line;
//             }
//             return line.replace(regex, (match) => `${packageName}.${capitalize(match)}`);
//         })
//         .join("\n");
// }

function tsTypeToGo(tsType: string | undefined): string {
    if (!tsType) return "void";
    tsType = tsType.trim();

    const escapeRegex = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

    // extract inner of a generic like Name<...> but only if the full type is exactly that generic (allowing trailing whitespace or array suffixes like [][][])
    const extractGenericInner = (typeStr: string, name: string): string | null => {
        const nameRegex = new RegExp("^\\s*" + escapeRegex(name) + "\\s*<");
        const m = typeStr.match(nameRegex);
        if (!m) return null;
        const ltIdx = m[0].length - 1; // index of the first '<'
        let depth = 0;
        for (let i = ltIdx; i < typeStr.length; i++) {
            const ch = typeStr[i];
            if (ch === "<") depth++;
            else if (ch === ">") {
                depth--;
                if (depth === 0) {
                    const inner = typeStr.substring(ltIdx + 1, i).trim();
                    const rest = typeStr.substring(i + 1).trim();
                    // allow nothing or only array suffixes after the closing >
                    if (rest === "") return inner;
                    if (/^(\[\])+$/ .test(rest)) return inner + rest;
                    return null;
                }
            }
        }
        return null;
    };

    // 1) handle tuple + array suffixes by stripping trailing [] first (so [A,B][] -> treat as tuple then wrap)
    let arrayDepth = 0;
    while (tsType.endsWith("[]")) {
        tsType = tsType.slice(0, -2).trim();
        arrayDepth++;
    }

    // 2) quickly unwrap Partial<...> and Promise<...> (handle nested)
    let innerGeneric: string | null = null;
    while ((innerGeneric = extractGenericInner(tsType, "Partial")) !== null) {
        tsType = innerGeneric;
    }
    while ((innerGeneric = extractGenericInner(tsType, "Promise")) !== null) {
        tsType = innerGeneric;
    }

    // 3) Array<T> style generic to []T (handle nested Array<Array<...>> too)
    while ((innerGeneric = extractGenericInner(tsType, "Array")) !== null) {
        tsType = innerGeneric;
        arrayDepth++;
    }

    // 4) Dictionary<T> -> map[string]T (recursive). Also support NullableDict<T> -> map[string]*T
    const dictInner = extractGenericInner(tsType, "Dictionary");
    if (dictInner !== null) {
        const valueType = tsTypeToGo(dictInner.trim());
        let mapped = `map[string]${valueType}`;
        for (let i = 0; i < arrayDepth; i++) mapped = `[]${mapped}`;
        return mapped;
    }
    const nullableDictInner = extractGenericInner(tsType, "NullableDict");
    if (nullableDictInner !== null) {
        const v = tsTypeToGo(nullableDictInner.trim());
        const ptr = v.startsWith("*") ? v : `*${v}`;
        let mapped = `map[string]${ptr}`;
        for (let i = 0; i < arrayDepth; i++) mapped = `[]${mapped}`;
        return mapped;
    }

    // 5) tuple [T, U, V] (arrayDepth already stripped so '[A,B][]' becomes '[A,B]' here)
    const tupleMatch = tsType.match(/^\[\s*([^,\]]+\s*,\s*[^,\]]+.*?)\s*\]$/);
    if (tupleMatch) {
        const inner = tupleMatch[1]
            .split(",")
            .map((p, i) => `F${i} ${tsTypeToGo(p.trim())}`)
            .join("; ");
        let ret = `struct { ${inner} }`;
        for (let i = 0; i < arrayDepth; i++) ret = `[]${ret}`;
        return ret;
    }

    // 6) remove optional markers from object fields (applies if the type is an object literal)
    if (/^\s*\{[\s\S]*\}\s*$/.test(tsType)) {
        tsType = tsType.replace(/\?\s*:/g, ":").trim();
    }

    const mapSingle = (t: string): string =>
        t
            .replace(/\bobject\b/g, "interface{}")
            .replace(/\bnumber\b/g, "float64")
            .replace(/\bstring\b/g, "string")
            .replace(/\bboolean\b/g, "bool")
            .replace(/\bany\b/g, "interface{}")
            .replace(/\bundefined\b/g, "interface{}")
            .replace(/\bnull\b/g, "interface{}")
            .replace(/\bvoid\b/g, "void")
            .replace(/\bDict\b/g, "map[string]interface{}")
            .replace(/\bNullableDict\b/g, "map[string]interface{}")
            .replace(/\bList\b/g, "interface{}")
            .replace(/\bNullableList\b/g, "interface{}")
            .replace(/\bNum\b/g, "float64")
            .replace(/\bInt\b/g, "int")
            .replace(/\bint\b/g, "int")
            .replace(/\bStr\b/g, "string")
            .replace(/\bStrings\b/g, "[]string")
            .replace(/\bBool\b/g, "bool")
            .replace(/\bIndexType\b/g, "interface{}")
            .replace(/\bOrderSide\b/g, "string")
            .replace(/\bOrderType\b/g, "string")
            .replace(/\bMarketType\b/g, "string")
            .replace(/\bSubType\b/g, "*string")
            .trim();

    // 7) union handling
    if (tsType.includes("|")) {
        const parts = tsType.split("|").map(p => p.trim());

        const isLit   = (p: string) => /^'[^']*'$/.test(p);
        const isStrKw = (p: string) => p === "string";
        const isStrAl = (p: string) => p === "Str";
        const isUndef = (p: string) => p === "undefined";
        const isNull  = (p: string) => p === "null";
        const isStrAr = (p: string) => p === "string[]";

        if (parts.every(p => isLit(p) || isStrKw(p) || isStrAl(p) || isUndef(p) || isNull(p))) {
            let out = parts.some(isUndef) || parts.some(isNull) ? "*string" : "string";
            for (let i = 0; i < arrayDepth; i++) out = `[]${out}`;
            return out;
        }

        if (parts.every(p => isStrAr(p) || isUndef(p) || isNull(p))) {
            let out = "*[]string";
            for (let i = 0; i < arrayDepth; i++) out = `[]${out}`;
            return out;
        }

        if (parts.length === 2 && (parts.some(isUndef) || parts.some(isNull))) {
            const base = parts.find(p => !isUndef(p) && !isNull(p))!;
            const mapped = mapSingle(base);
            let out = mapped.startsWith("*") ? mapped : `*${mapped}`;
            for (let i = 0; i < arrayDepth; i++) out = `[]${out}`;
            return out;
        }

        let out = "[]byte";
        for (let i = 0; i < arrayDepth; i++) out = `[]${out}`;
        return out;
    }

    // 8) single token mapping (apply arrayDepth)
    let mapped = mapSingle(tsType);
    for (let i = 0; i < arrayDepth; i++) mapped = `[]${mapped}`;
    return mapped;
}

const goWrapperMethodDeclaration = (methodName: string, params: {[key: string]: [string, string | null]}, returnType: string, isAsync: boolean) => {
    const arrayParams: string[] = [];
    const customTypeParams: string[] = [];
    const callParams: string[] = [];
    const headerParams: string[] = [];
    const optionalParams: [string, string][] = [];
    let hasParams = false;
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
                hasParams = true;
                goType = '[]byte';
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
    const returnVoid = returnType === 'void';
    // const arrayParamsCode = prefixWith(arrayParams, sep) + arrayParams.map(paramName => `${paramName}_arr := strings.Split(${paramName}, ",")`).join(sep);  // stringify custom types  // probably unnecessary, as the array parameters are already strings
    return `
    func (e *CCXTGoExchange) ${capsMethodName}(${headerParams.join(", ")}) ${(returnVoid ? 'error' : '([]byte, error)')} {${customTypeParamsCode}
        ${hasParams ? `    
        var decoded map[string]interface{}
        if err := json.Unmarshal(params, &decoded); err != nil {
            return nil, err
        }` : ''}
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
        ${returnVoid ? `e.exchange.${capsMethodName}(${callParams.join(', ')})\n\t\treturn nil` : `
        res := <-e.exchange.${capsMethodName}(${callParams.join(', ')})
        switch v := res.(type) {
        case string:
            if strings.HasPrefix(v, "panic:") {
                return nil, fmt.Errorf("%s", v)
            }
        case error:
            return nil, v
        }
        sanitised := sanitise(res) // deep copy; no in-place mutation
        b, err := json.Marshal(sanitised)
        if err != nil {
            return nil, err
        }
        return b, nil
        `}
    }`;
}

function goWrapperGetterDeclaration (prop: Property) {
    return `func (e *CCXTGoExchange) Get${capitalize(prop.name)}() ([]byte, error) {
        propValue := e.exchange.Get${capitalize(prop.name)}()
        sanitised := sanitise(propValue)
        return json.Marshal(sanitised)
    }`;
}

function goWrapperSetterDeclaration (prop: Property) {
    if (specificTypeMapping[prop.name]) {
        prop.type = specificTypeMapping[prop.name];
    }
    let paramType = '[]byte';
    const hasSimpleType = prop.type && simpleTypes.has(prop.type);
    let decodedType = 'interface{}';
    if (hasSimpleType) {
        paramType = tsTypeToGo(prop.type);
    } else if (prop.type) {
        decodedType = specificTypeMapping[prop.type] || tsTypeToGo(prop.type);
        if (
            decodedType !== 'interface{}' && 
            decodedType !== 'map[string]interface{}' &&
            decodedType !== 'map[string]*interface{}' &&
            decodedType !== 'map[string]string' &&
            decodedType !== 'map[string]*string' &&
            decodedType !== 'map[string]map[string]interface{}' &&
            decodedType !== '[]string' &&
            decodedType !== 'map[string][]byte' &&
            decodedType !== 'chan struct{}' &&
            decodedType !== '*sync.Map'
        ) {
            if (decodedType.startsWith('*')) {
                decodedType = `*ccxt.${decodedType.slice(1)}`;
            } else if (decodedType.startsWith('[]')) {
                decodedType = `[]ccxt.${decodedType.slice(2)}`;
            } else {
                decodedType = `ccxt.${decodedType}`;
            }
        }
    }
    return `func (e *CCXTGoExchange) Set${capitalize(prop.name)}(newValue ${paramType}) error {
        ${hasSimpleType ? '' : `
        var decoded ${decodedType}
	    if err := json.Unmarshal(newValue, &decoded); err != nil {
		    return err
	    }`}
        e.exchange.Set${capitalize(prop.name)}(${hasSimpleType ? 'newValue' : `decoded`})
        return nil
    }`;
}

function goWrapperPropertyDeclaration (prop: Property) {
    return `
${prop.hasGetter ? goWrapperGetterDeclaration(prop) : ''}

${prop.hasSetter ? goWrapperSetterDeclaration(prop) : ''}
`;
}

/**
 * @param {Propery} prop
 * @returns a stringified getter and setter for the property
 * @remarks // ! if build fails, check specificTypeMapping object 
 */
function goExchangeGetterSetterDeclaration (prop: Property) {
    const propName = capitalize(prop.name);
    const type = specificTypeMapping[prop.name] || tsTypeToGo(prop.type);
    return `func (this *Exchange) Get${propName}() ${type} {
    return this.${propName}
}

func (this *Exchange) Set${propName}(newValue ${type}) {
    this.${propName} = newValue
}`;
}

const interfaceGetterSetterDeclaration = (prop: Property) => {
    const type = specificTypeMapping[prop.name] || tsTypeToGo(prop.type);
    return `Get${capitalize(prop.name)}() ${type}
    Set${capitalize(prop.name)}(newValue ${type})`;
}

const goWsMap = () => {
    return `
    wsMap := map[string]bool{
        ${allExchanges.map (exchange => `"${exchange}": ${wsExchanges.includes (exchange).toString ()}`).join(",\n        ")},
    }
`;
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

function getMethodsFromInterface (): Set<string> {
    let content = fs.readFileSync(ccxtPaths['goInterface'], "utf-8");
    const startMarker = '// BEGIN: INJECT GETTERS AND SETTERS HERE //';
    const endMarker = '// END: INJECT GETTERS AND SETTERS HERE //';
    const escapeForRegex = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const startEsc = escapeForRegex(startMarker);
    const endEsc = escapeForRegex(endMarker);
    content = content.replace(new RegExp(`${startEsc}[\\s\\S]*?${endEsc}`, 'm'), `${startMarker}\n${endMarker}`);
    const interfaceRegex = /type\s+ICoreExchange\s*interface\s*{([\s\S]*?)^}/m;
    const interfaceMatch = content.match (interfaceRegex);
    const interfaceBody = interfaceMatch![1];
    const methodRegex = /^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*\)/gm;
    const methodNames: string[] = [];
    let match;
    while ((match = methodRegex.exec(interfaceBody)) !== null) {
        methodNames.push (match[1]);
    }
    return new Set (methodNames);
}

const generatedExchange = (methodDeclarations: string[]) => (
`package ccxt

import "sync"

${methodDeclarations.join ('\n\n')}
`);

function injectContentBetweenMarkers(
    filePath: string,
    startMarker: string,
    endMarker: string,
    contentBlocks: string[],
) {
    const original = fs.readFileSync(filePath, 'utf8');
    const lines = original.split('\n');

    const startIndex = lines.findIndex((line) => line.includes(startMarker));
    const endIndex = lines.findIndex((line, idx) => idx > startIndex && line.includes(endMarker));

    if (startIndex === -1 || endIndex === -1 || endIndex <= startIndex) {
        throw new Error(`Injection markers not found or misordered in ${filePath}`);
    }

    const indentMatch = lines[startIndex].match(/^(\s*)/);
    const indentation = indentMatch ? indentMatch[1] : '';

    const normalizedLines = contentBlocks
        .flatMap((block) => block.split('\n'))
        .map((l) => l.trim())
        .filter((l) => l.length > 0)
        .map((l) => `${indentation}${l}`);

    // Keep start marker, inject content, keep end marker
    const updated = [
        ...lines.slice(0, startIndex + 1),  // Keep everything up to and including start marker
        ...normalizedLines,                 // Inject new content
        ...lines.slice(endIndex),           // Keep everything from end marker onwards (including end marker)
    ].join('\n');

    fs.writeFileSync(filePath, updated, 'utf8');
}

function createGettersSetters () {
    const methodDeclarations: string[] = [];
    const interfaceDeclarations: string[] = [];
    const methodsAlreadyInInterface = getMethodsFromInterface ();
    const exchangeProperties = getExchangeProperties (
        new ccxt.Exchange (),
        ccxtPaths['exchange'],
        'Exchange',
    ).filter (prop => (
        !methodsAlreadyInInterface.has (`Get${capitalize(prop.name)}`) &&
        !methodsAlreadyInInterface.has (`Set${capitalize(prop.name)}`)
    ));
    for (const prop of Object.values (exchangeProperties)) {
        if (!skippedProperties.has (prop.name)) {
            methodDeclarations.push (goExchangeGetterSetterDeclaration (prop));
            interfaceDeclarations.push (interfaceGetterSetterDeclaration (prop));
        }
    }
    fs.writeFileSync (
        ccxtPaths['generatedExchange'],
        generatedExchange (methodDeclarations),
    );
    const START_MARKER = '// BEGIN: INJECT GETTERS AND SETTERS HERE //';
    const END_MARKER = '// END: INJECT GETTERS AND SETTERS HERE //';
    injectContentBetweenMarkers(
        ccxtPaths['goInterface'],
        START_MARKER,
        END_MARKER,
        interfaceDeclarations,
    );
}

export default function transpileGoWrapper () {
    createGettersSetters ();
    for (const os of [ 'swift', 'android' ]) {
        for (const [key, insert] of Object.entries(inserts(os === 'swift'))) {
            const filePath = insert.binaryPath;
            createWrapperFile (
                goWrapperMethodDeclaration,
                goWrapperPropertyDeclaration,
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
// console.log (getMethodsFromInterface ());