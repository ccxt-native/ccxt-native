import { dirname, resolve } from "path";

const scriptDir = dirname(__filename);
export const ccxtDir: string = resolve(scriptDir, '../../../');
export const ccxtNativeDir: string = resolve(scriptDir, '../../');
export const swiftTranspiler: string = `${ccxtNativeDir}/main/build/transpileSwift.ts`;
export const ccxtTsDir: string = `${ccxtDir}/ts/src/base`;
export const ccxtGoDir: string = `${ccxtDir}/go/v4`;
export const originSwiftDir: string = `${ccxtNativeDir}/main/swift`;
export const originAndroidDir: string = `${ccxtNativeDir}/main/android`;
export const originGoDir: string = `${ccxtNativeDir}/main/go`;
export const licenseFile: string = `${ccxtDir}/LICENSE.txt`;


export const tsPaths = {
    exchange: `${ccxtTsDir}/Exchange.ts`,
    types: `${ccxtTsDir}/types.ts`,
    errors: `${ccxtTsDir}/errors.ts`,
};

export const originalFiles = {
    swiftExchange: `${originSwiftDir}/CCXTExchange.swift`,
    swiftErrors: `${originSwiftDir}/CCXTErrors.swift`,
    swiftPackage: `${originSwiftDir}/Package.swift`,
    androidExchange: `${originAndroidDir}/CCXTExchange.java`,
    androidErrors: `${originSwiftDir}/CCXTErrors.swift`,
    gowrapper: `${originGoDir}/ccxtwrapper.go`,
    gomod: `${originGoDir}/go.mod`,
    gosum: `${originGoDir}/go.sum`,
};

export const swiftBinaries = {
    rest: `${ccxtNativeDir}/ccxt-swift`,
    pro: `${ccxtNativeDir}/ccxt-swift-pro`,
    // intel: `${ccxtNativeDir}/swift-intel-simulator`,
    // arm: `${ccxtNativeDir}/swift-arm-simulator`,
    // intelPro: `${ccxtNativeDir}/pro/swift-intel-simulator`,
    // armPro: `${ccxtNativeDir}/pro/swift-arm-simulator`,
};

export const androidBinaries = {
    rest: `${ccxtNativeDir}/ccxt-android`,
    pro: `${ccxtNativeDir}/ccxt-android-pro`,
}

export const gomobileHeader = `${swiftBinaries.rest}/Sources/CCXTCore/CCXTCore.xcframework/ios-arm64/CCXTCore.framework/Headers/Ccxt.objc.h`;

export const readmeFiles = {
    ccxt: `${ccxtDir}/README.md`,
    ccxtNative: `${ccxtNativeDir}/README.md`,
};



