import * as fs from 'fs';
import ccxt from '../../../js/ccxt.js';
import { capitalize, lowercaseFirstLetter, prefixWith } from './util.js';
import { ccxtPaths, swiftBinaries, originalFiles } from './filepaths.js';
import { createGeneratedFile, createWrapperFile, customTypes, simpleTypes } from './shared.js';
import { appendFileSync, copyFileSync } from 'fs';
import { Property } from './types.js';

function splitAtProblemPhrase(methodName: string): string[] {
    if (methodName === 'signIn') {
        return ['sign', 'in: '];
    }
    const problemSwiftPhrases = [
        'By',
        'For',
        'With'
    ];
    const pattern = new RegExp(`(${problemSwiftPhrases.join('|')})(?=[A-Z])`);
    const match = pattern.exec(methodName);

    if (!match) {
        // No problem phrase found, return original string as single part array
        return [methodName, ''];
    }

    // Index where the matched phrase starts
    const index = match.index;

    // Split string into before and after the match
    return [methodName.slice(0, index), `${lowercaseFirstLetter(methodName.slice(index))}: `];
}

/**
 * Converts a single type name (as a string) to a swift type
 */
/**
 * Converts a single TypeScript type name (as a string) to a Swift type
 * ChatGPT code, can be entirely replaced if the new solution works
 */
function tsTypeToSwift(tsType?: string): string {
    if (!tsType) return "Void";

    /* 1) [A,B][] → [(A, B)] */
    const tupArr = tsType.match(/^\s*\[([^,\]]+),\s*([^,\]]+)]\s*\[\]\s*$/);
    if (tupArr) {
        const a = tsTypeToSwift(tupArr[1].trim());
        const b = tsTypeToSwift(tupArr[2].trim());
        return `[(${a}, ${b})]`;
    }

    /* 2) T[], T[][], T[][][] → [T], [[T]], [[[T]]] */
    const arrayDepthMatch = tsType.match(/^(.+?)(\[\])+$/);
    if (arrayDepthMatch) {
        const baseType = arrayDepthMatch[1];
        const brackets = arrayDepthMatch[2];
        const depth = (brackets.match(/\[\]/g) || []).length;

        let inner = tsTypeToSwift(baseType);
        for (let i = 0; i < depth; i++) {
            inner = `[${inner}]`;
        }
        return inner;
    }

    /* 3) fixed-length tuple [T, U, …] → (T, U, …) */
    const tupleMatch = tsType.match(/^\[\s*(.+)\s*\]$/);
    if (tupleMatch && tupleMatch[1].includes(",")) {
        const inner = tupleMatch[1]
            .split(",")
            .map(p => tsTypeToSwift(p.trim()))
            .join(", ");
        return `(${inner})`;
    }

    /* 4) collapse Partial<X> → X */
    tsType = tsType.replace(/Partial<\s*([^>]+?)\s*>/g, "$1");

    /* 5) handle unions */
    if (tsType.includes("|")) {
        const parts = tsType.split("|").map(p => p.trim());

        const isLit   = (p: string) => /^'[^']*'$/.test(p);
        const isStrKw = (p: string) => p === "string";
        const isUndef = (p: string) => p === "undefined";
        const isNull  = (p: string) => p === "null";
        const isStrAr = (p: string) => p === "string[]";
        const isStrAl = (p: string) => p === "Str";
        const isNumAl = (p: string) => p === "Num";
        const isBoolAl = (p: string) => p === "Bool";

        if (parts.every(p => isLit(p) || isStrKw(p) || isStrAl(p) || isUndef(p) || isNull(p))) {
            return parts.some(isUndef) || parts.some(isNull) ? "String?" : "String";
        }

        if (parts.every(p => isStrAr(p) || isUndef(p) || isNull(p))) {
            return "[String]?";
        }

        if (parts.length === 2 && (parts.some(isUndef) || parts.some(isNull))) {
            const base = parts.find(p => !isUndef(p) && !isNull(p))!;
            const mapped = mapSingle(base);
            return mapped.endsWith("?") ? mapped : `${mapped}?`;
        }

        parts.forEach(p => {
            if (isStrAl(p) || isUndef(p) || isNull(p) || isNumAl(p) || isBoolAl(p)) {
                return "Any?";
            }
        });
        return "Any";
    }

    /* 6) single token mapping */
    return mapSingle(tsType);

    /* helper to map a single (non-union) type dynamically */
    function mapSingle(t: string): string {
        t = t.trim();

        // basic types
        switch (t) {
            case "number": return "Double";
            case "string": return "String";
            case "boolean": return "Bool";
            case "Bool": return "Bool?";
            case "Int": return "Int?";
            case "Num": return "Double?";
            case "Str": return "String?";
            case "int": return "Int";
            case "List": return "[Any]";
            case "Dict": return "[String: Any]";
            case "WsClient": return "Any";
            case "ArrayCache": return "Any";
            case "object": return "[String: Any]";
            case "ArrayCacheByTimestamp": return "Any";
            case "any":
            case "undefined":
            case "null":
                return "Any";
            case "void": return "Void";
        }

        // array T[]
        const arrayMatch = t.match(/^(.+)\[\]$/);
        if (arrayMatch) {
            const inner = tsTypeToSwift(arrayMatch[1]);
            return `[${inner}]`;
        }

        // dictionary Dictionary<T>
        const dictMatch = t.match(/^Dictionary<(.+)>$/);
        if (dictMatch) {
            const inner = tsTypeToSwift(dictMatch[1]);
            return `[String: ${inner}]`;
        }

        // promise Promise<T>
        const promiseMatch = t.match(/^Promise<(.+)>$/);
        if (promiseMatch) {
            const inner = tsTypeToSwift(promiseMatch[1]);
            return `Promise<${inner}>`;
        }

        // fallback: return as-is
        return t;
    }
}

const swiftErrorDeclaration = (className: string, bassClassName: string): string => (
`class ${className}: ${bassClassName} {
    override var name: String { "${className}" }
    override required init(_ message: String) {
        super.init(message)
    }
}`);

function createSwiftErrors (outputFile: string) {
    const swiftErrors: string[] = [];
    const tsErrors = fs.readFileSync(ccxtPaths['errors'], "utf8");
    const lines     = tsErrors.split("\n");
    for (const line of lines) {
        const match = line.trim().match(/^class\s+(\w+)\s+extends\s+(\w+)/);
        if (match) {
            const [_, className, bassClassName] = match;
            if (className !== "BaseError") {
                swiftErrors.push(swiftErrorDeclaration(className, bassClassName));
            }
        }
    }

    createGeneratedFile(outputFile, swiftErrors, originalFiles.swiftErrors);
}

/**
 * converts all types in types.ts to swift types and prints them to CCXTTypes.swift
 */
function createSwiftTypes(outputFile: string) {
    const tsContent = fs.readFileSync(ccxtPaths['types'], "utf8");
    const lines     = tsContent.split("\n");

    const excluded = new Set([
        "Int", "int", "Str", "Bool", "Dictionary", "Dict", "List",
    ]);

    const out: string[] = [];
    const stack: { name: string }[] = [];
    let indent = "";
    let braceDepth = 0;
    let skipDictBody = false;   // inside  extends Dictionary<...> { ... }
    let skipTypeBody = false;   // inside  Partial<X> & { ... }

    // TODO: look at renaming this variable again
    /* helper: rename reserved 'internal' → 'isInternal' */
    const rename = (name: string) => (name === "internal" ? "isInternal" : name);
    // TODO: can't make Encodable because params is type any
    // const makeEncodable = (name: string) => customTypes.includes(name) ? `${name}: Encodable` : name;

    const push = (name: string) => {
        indent = "    ".repeat(stack.length);
        out.push(`${indent}public struct ${name} {`);
        stack.push({ name });
        indent = "    ".repeat(stack.length);
        braceDepth++;
    };
    const pop = () => {
        if (!stack.length) return;
        stack.pop();
        indent = "    ".repeat(stack.length);
        out.push(`${indent}}`);
        braceDepth--;
    };

    for (const raw of lines) {
        let line = raw.trim();
        if (!line) continue;

        /* skip bodies of dictionary-alias or partial-alias */
        if (skipDictBody) {
            if (line.startsWith("}")) skipDictBody = false;
            continue;
        }
        if (skipTypeBody) {
            if (line.startsWith("};") || line === "}") skipTypeBody = false;
            continue;
        }

        /* ── export type (one line) ─────────────────────────── */
        const oneType = line.match(/^export\s+type\s+(\w+)\s*=\s*(.+);$/);
        if (oneType) {
            const name = oneType[1];
            let body   = oneType[2].trim();
            const p = body.match(/^Partial<\s*([^>]+?)\s*>\s*&/);
            if (p) body = p[1].trim();
            body = body.replace(/\s*&\s*\{[\s\S]*$/, "").trim();
            if (!excluded.has(name))
                out.push(`public typealias ${name} = ${tsTypeToSwift(body)}`);
            continue;
        }

        /* ── export type Name = Partial<X> & {  (multi-line) ─── */
        const openPartial = line.match(
            /^export\s+type\s+(\w+)\s*=\s*Partial<\s*([^>]+?)\s*>\s*&\s*\{$/
        );
        if (openPartial) {
            const alias = openPartial[1];
            const base  = openPartial[2].trim();
            if (!excluded.has(alias))
                out.push(`public typealias ${alias} = ${tsTypeToSwift(base)}`);
            skipTypeBody = true;
            continue;
        }

        /* ── interface Name extends Dictionary<T> { … } ─────── */
        const dict = line.match(
            /^export\s+interface\s+(\w+)\s+extends\s+Dictionary\s*<\s*([^>]+?)\s*>\s*(\{)?\s*$/
        );
        if (dict) {
            const alias = dict[1];
            const inner = tsTypeToSwift(dict[2].trim());
            if (!excluded.has(alias))
                out.push(`public typealias ${alias} = [String: ${inner}]`);
            if (dict[3] === "{") skipDictBody = true;
            continue;
        }

        /* ── interface start (export optional) ───────────────── */
        const iface = line.match(/^(?:export\s+)?interface\s+(\w+)/);
        if (iface) {
            const name = iface[1];
            if (!excluded.has(name)) push(name);
            continue;
        }

        /* ── nested object  'foo': {  ───────────────────────── */
        const obj = line.match(/^['"]?(\w+)['"]?\??:\s*\{$/);
        if (obj) {
            const field = rename(obj[1]);
            const structName = field[0].toUpperCase() + field.slice(1);
            if (braceDepth === stack.length)
                out.push(`${indent}public var ${field}: ${structName}`);
            push(structName);
            continue;
        }

        /* ── closing brace ──────────────────────────────────── */
        if (line.startsWith("}")) {
            pop();
            continue;
        }

        /* ── ordinary field ( ; or , ) ─────────────────────── */
        const fld = line.match(/^['"]?(\w+)['"]?\??:\s*([^;,]+)[;,]?$/);
        if (fld && stack.length) {
            const name      = rename(fld[1]);
            const swiftType = tsTypeToSwift(fld[2]);
            const optional  = fld[0].includes("?") || swiftType.endsWith("?");
            out.push(`${indent}public var ${name}: ${swiftType}${optional ? "" : ""}`);
        }
    }

    /* write generated Swift types */
    createGeneratedFile (outputFile, out);
}

const getSwiftReturnType = (methodName: string, tsType: string): string => {
    // TODO: This function shouldn't be needed if we can fix the encodable issue
    if (methodName === "loadMarkets") {
        return "[String: [String: Any]]";
    } else if (methodName === "describe") {
        return "[String: Any]";
    } else if (methodName === "setSandboxMode") {
        return "Void";
    }
    const swiftTypes = {
        "int": "Int",
        "number": "Double",
        "boolean": "Bool",
        "Num": "Double?",
        "Strings": "[String]?",
        "Account[]": "[[String: Any]]",
        "any": "Any",
        "Balances": "[String: Any]",
        "BorrowInterest[]": "[[String: Any]]",
        "Conversion": "[String: Any]",
        "Conversion[]": "[[String: Any]]",
        "CrossBorrowRate": "[String: Any]",
        "CrossBorrowRates": "[String: [String: Any]]",
        "Currencies": "[String: [String: Any]]",
        "DepositAddress": "[String: Any]",
        "DepositAddress[]": "[[String: Any]]",
        "DepositWithdrawFeeNetwork": "[String: Any]",
        "Dictionary<DepositWithdrawFeeNetwork>": "[String: [String: Any]]",
        "Dictionary<Dictionary<OHLCV[]>>": "[String: [String: [[Double]]]]",
        "FundingHistory[]": "[[String: Any]]",
        "FundingRate": "[String: Any]",
        "FundingRateHistory[]": "[[String: Any]]",
        "FundingRates": "[String: [String: Any]]",
        "Greeks": "[String: Any]",
        "Int": "Int?",
        "IsolatedBorrowRate": "[String: Any]",
        "IsolatedBorrowRates": "[String: [String: Any]]",
        "LastPrices": "[String: [String: Any]]",
        "LedgerEntry": "[String: Any]",
        "LedgerEntry[]": "[[String: Any]]",
        "Leverage": "[String: Any]",
        "Leverages": "[String: [String: Any]]",
        "LeverageTier[]": "[[String: Any]]",
        "LeverageTiers": "[String: [[String: Any]]]",
        "Liquidation[]": "[[String: Any]]",
        "LongShortRatio": "[String: Any]",
        "LongShortRatio[]": "[[String: Any]]",
        "MarginMode": "[String: Any]",
        "MarginModes": "[String: [String: Any]]",
        "MarginModification": "[String: Any]",
        "MarginModification[]": "[[String: Any]]",
        "Market[]": "[[String: Any]]",
        "OHLCV[]": "[[Double]]",
        "OpenInterest": "[String: Any]",
        "OpenInterest[]": "[[String: Any]]",
        "OpenInterests": "[String: [String: Any]]",
        "Option": "[String: Any]",
        "OptionChain": "[String: [String: Any]]",
        "Order": "[String: Any]",
        "Order[]": "[[String: Any]]",
        "OrderBook": "[String: Any]",
        "OrderBooks": "[String: [String: Any]]",
        "Position": "[String: Any]",
        "Position[]": "[[String: Any]]",
        "string": "String",
        "Ticker": "[String: Any]",
        "Tickers": "[String: [String: Any]]",
        "Trade[]": "[[String: Any]]",
        "TradingFeeInterface": "[String: Any]",
        "TradingFees": "[String: [String: Any]]",
        "Transaction": "[String: Any]",
        "Transaction[]": "[[String: Any]]",
        "TransferEntry": "[String: Any]",
        "TransferEntry[]": "[[String: Any]]"
    }
    if (swiftTypes[tsType]) {
        return swiftTypes[tsType];
    } else if (tsType.endsWith('[]')) {
        return "Any[]";
    } else {
        return "Any";
    }
}

// TODO: combine this with the method above
const getSwiftPropReturnType = (prop: Property) => {
    if (prop.name === 'timeout') {
        return "Int64";
    }
    return tsTypeToSwift(prop.type)
        .replace("Liquidation", '[String: Any]')
        .replace("OrderBook", '[String: Any]')
        .replace("Ticker", '[String: Any]')
        .replace("FundingRate", '[String: Any]')
        .replace("Ticker", '[String: Any]')
        .replace("Transaction", '[String: Any]')
        .replace("Liquidation", '[String: Any]')
        .replace("Ob", '[String: Any]')
        .replace("Currencies", '[String: Any]')
        .replace("CurrencyInterface", '[String: Any]')
        .replace("Account", '[String: Any]')
        .replace("RequiredCredentials", '[String: Any]')
        .replace("TradingFeeInterface", '[String: Any]')
        .replace("Urls", '[String: Any]')
        .replace("MarketLimits", '[String: Any]?')
        .replace("Precision", '[String: Any]?');
}

const swiftMethodDeclaration = (methodName: string, params: {[key: string]: [string, string | null]}, returnType: string, isAsync: boolean) => {
    // TODO: add return types, right now all the return types need to be Any because the info property prevents them from extended encodeable
    // const swiftReturnType = tsTypeToSwift(returnType);
    // const guardClause = (swiftReturnType === 'Any') ? `` : `as? ${swiftReturnType}`;
    const returnVoid = returnType === 'void';
    const swiftParams = Object.keys(params).map(key => {
        const [tsType, defaultValue] = params[key];
        const paramType = tsTypeToSwift(tsType);
        return defaultValue === null
            ? `${key}: ${paramType}`
            : `${key}: ${paramType} = ${defaultValue
                .replace(/undefined/g, 'nil')
                .replace(/{}/g, '[:]')}`
                .replace(/params\:\s*Any\b/g, 'params: [String: Any]')
                .replace(/'/g, '"');
    }).join(', ')
    const goCallParams: string[] = [];
    const optionalParams: string[] = [];
    const customTypeParams: string[] = [];
    const arrayParams: string[] = [];
    let index = 0;
    const [callMethodName, firstExternalName] = splitAtProblemPhrase(methodName);
    let hasParams = false;
    Object.keys(params).forEach(paramName => {
        const [paramType, defaultValue] = params[paramName];
        const isArray = paramType.includes('[]');
        if (defaultValue === 'undefined') {
            optionalParams.push(paramName);
        } else {
            let newName = paramName;
            if (customTypes.includes(paramType)) {
                customTypeParams.push(paramName);
                newName = `${paramName}_string`;
            } else if (isArray) {
                arrayParams.push(paramName);
                newName = `${paramName}_string`;
            } else if (paramName === 'params') {
                hasParams = true;
                newName = 'paramsData';
            }
            const externalName = (index === 0) ? firstExternalName : `${paramName}: `.replace(/type/g, 'typeVar'); // type is a reserved word in Go, so we need to rename it to typeVar
            goCallParams.push(`${externalName}${newName}`);
            index += 1;
        }
    });
    const sep = "\n\t\t\t\t\t";
    let optionalsCode = '';
    let paramsCopy = false;
    if (optionalParams.length > 0){
        optionalsCode = `${sep}var paramsCopy: [String: Any] = params`;
        paramsCopy = true;
    }
    optionalsCode += prefixWith(optionalParams, sep) + optionalParams.map(paramName => `if (${paramName} != nil) { paramsCopy["${paramName}"] = ${paramName} }`).join(sep);
    const customTypeParamsCode = prefixWith(customTypeParams, sep) + customTypeParams.map(paramName => `let ${paramName}_string = stringify(${paramName})`).join(sep);  // stringify custom types
    const arrayParamsCode = prefixWith(arrayParams, sep) + arrayParams.map(paramName => `let ${paramName}_string = ${paramName}.joined(separator: ",")`).join(sep);  // convert array parameters to comma separated strings
    const swiftReturnType = getSwiftReturnType(methodName, returnType);
    // const guardCode = `
    //         guard let result = cleanAny(jsonObject) ${guardClause} else {
    //             throw NSError(domain: "CCXT", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type for ${methodName}"])
    //         }\n`;
    return`
    public func ${methodName} (${swiftParams})${isAsync ? ' async' : ''} throws -> ${swiftReturnType} {
        ${isAsync ? `try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<${swiftReturnType}, Error>) in
            DispatchQueue.global(qos: .userInitiated).async {
                do {${optionalsCode}${customTypeParamsCode}${arrayParamsCode}` : ''}
                    ${hasParams ? `let paramsData = try? JSONSerialization.data(withJSONObject: ${paramsCopy ? 'paramsCopy' : 'params'})` : ''}
                    ${returnVoid
                    ? `try self.exchange.${callMethodName}(${goCallParams.join(', ')})`
                    : `let data = try self.exchange.${callMethodName}(${goCallParams.join(', ')})
                    do {
                        let jsonObject = try self.decode(data)
                        let cleaned = self.cleanAny(jsonObject)
                        continuation.resume(returning: cleaned as! ${swiftReturnType})
                    } catch {
                        continuation.resume(throwing: error)
                    }`}
                ${isAsync ? `} catch {
                    continuation.resume(throwing: error)
                }
            }
        }` : ''}
    }
`
}

const exchangeDeclaration = (exchangeName: string) => (`
public class ${capitalize(exchangeName)}: Exchange {
    public init?(config: [String: Any]? = nil) {
        super.init(exchangeName: "${exchangeName}", config: config)
    }
}`);

function createSwiftExchangeClasses (outputFile: string) {
    const exchangeDeclarations: string[] = ['import Foundation', 'import CCXT'];
    for (const exchangeName of ccxt.exchanges) {
        exchangeDeclarations.push(exchangeDeclaration(exchangeName));
    }
    createGeneratedFile (outputFile, exchangeDeclarations);
}

const swiftGetter = (prop: Property) => {
    // let propValue = try? self.exchange.get${capitalize(prop.name)}() else {
    //     return ${tsTypeToSwift(prop.type)}
    // }
    return `get {
            let propValue = try? self.exchange.get${capitalize(prop.name)}()
            let jsonObject = try! self.decode(propValue)
            let cleaned = self.cleanAny(jsonObject)! as! ${getSwiftPropReturnType(prop)}
            return cleaned
        }`
};

const swiftSetInner = (prop: Property, indent: number) => {
    const simpleReturnType = prop.type && simpleTypes.has (prop.type);
    const methodName = `set${capitalize(prop.name)}`;
    const tabs = '    '.repeat(indent);
    if (simpleReturnType) {
        return `try? self.exchange.${methodName}(newValue as! ${getSwiftPropReturnType(prop).replace('\?', '')})`
    } else {
        return `let serialized = try? JSONSerialization.data(withJSONObject: newValue)\n${tabs}try? self.exchange.${methodName}(serialized)`;
    }
};

const swiftSetter = (prop: Property) => {
    return `set {
            ${swiftSetInner(prop, 3)}
        }`
};

const swiftSetMethod = (prop: Property) => {
    const methodName = `set${capitalize(prop.name)}`;
    return `
    public func ${methodName}(newValue: ${getSwiftPropReturnType(prop)}) {
        ${swiftSetInner(prop, 2)}
    }`;
};

const swiftProperty = (prop: Property) => (`
    public var ${prop.name}: ${getSwiftPropReturnType(prop)} {
        ${swiftGetter(prop)}
        ${prop.hasSetter ? swiftSetter(prop) : ''}
    }`
);

function swiftPropertyDeclaration (prop: Property) {
    if (prop.hasGetter) {
        return swiftProperty(prop);
    } else {
        return swiftSetMethod(prop);
    }
}

export default async function transpileSwift (binaries: {[key: string]: string}) {

    for (const [key, filePath] of Object.entries (binaries)) {
        const sourcesPath = `${filePath}/Sources/CCXT`;
        createSwiftTypes (`${sourcesPath}/CCXTTypes.swift`);
        createSwiftExchangeClasses (`${sourcesPath}/CCXTExchanges.swift`);
        createSwiftErrors (`${sourcesPath}/CCXTErrors.swift`);
        createWrapperFile (
            swiftMethodDeclaration,
            swiftPropertyDeclaration,
            originalFiles.swiftExchange,
            `${sourcesPath}/CCXTExchange.swift`,
            undefined,
            key === 'pro',
        );
        copyFileSync (originalFiles.swiftExample, `${sourcesPath}/Example.swift`);
        appendFileSync (`${filePath}/Sources/CCXT/CCXTExchange.swift`, `\n}\n`);
    }
}

const args = process.argv.slice(2);
if (args.includes ('--pro')) {
    transpileSwift ({'pro': swiftBinaries.pro});
} else if (args.includes('--rest')) {
    transpileSwift ({'rest': swiftBinaries.rest});
} else {
    transpileSwift (swiftBinaries);
}
