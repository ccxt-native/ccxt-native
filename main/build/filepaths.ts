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


export const ccxtPaths = {
    exchange: `${ccxtTsDir}/Exchange.ts`,
    types: `${ccxtTsDir}/types.ts`,
    errors: `${ccxtTsDir}/errors.ts`,
    goInterface: `${ccxtDir}/go/v4/exchange_interface.go`,
    goExtendedInterface: `${ccxtDir}/go/v4/exchange_interface_extended.go`,
    generatedExchange: `${ccxtDir}/go/v4/exchange_generated_getters_setters.go`,
};

export const originalFiles = {
    swiftExchange: `${originSwiftDir}/CCXTExchange.swift`,
    swiftErrors: `${originSwiftDir}/CCXTErrors.swift`,
    swiftPackage: `${originSwiftDir}/Package.swift`,
    swiftExample: `${originSwiftDir}/Example.swift`,
    androidExchange: `${originAndroidDir}/CCXTExchange.java`,
    androidErrors: `${originSwiftDir}/CCXTErrors.swift`,
    gowrapper: `${originGoDir}/ccxtwrapper.go`,
    gomod: `${originGoDir}/go.mod`,
    gosum: `${originGoDir}/go.sum`,
};

export const binaries = {
    swift: {
        rest: `${ccxtNativeDir}/ccxt-swift`,
        pro: `${ccxtNativeDir}/ccxt-pro-swift`,
        // intel: `${ccxtNativeDir}/swift-intel-simulator`,
        // arm: `${ccxtNativeDir}/swift-arm-simulator`,
        // intelPro: `${ccxtNativeDir}/pro/swift-intel-simulator`,
        // armPro: `${ccxtNativeDir}/pro/swift-arm-simulator`,
    },
    android: {
        rest: `${ccxtNativeDir}/ccxt-android`,
        pro: `${ccxtNativeDir}/ccxt-pro-android`,
    },
}

export const gomobileHeader = `${binaries.swift.rest}/Sources/CCXTCore/CCXTCore.xcframework/ios-arm64/CCXTCore.framework/Headers/Ccxt.objc.h`;

export const readmeFiles = {
    ccxt: `${ccxtDir}/README.md`,
    ccxtNative: `${ccxtNativeDir}/main/docs/README.md`,
    swift: `${ccxtNativeDir}/main/docs/swift.md`,
    android: `${ccxtNativeDir}/main/docs/android.md`,
};

export const repoUrls = {
    swift: {
        rest: 'https://github.com/ccxt-native/ccxt-swift.git',
        pro: 'https://github.com/ccxt-native/ccxt-pro-swift.git',
    },
    android: {
        rest: 'https://github.com/ccxt-native/ccxt-android.git',
        pro: 'https://github.com/ccxt-native/ccxt-pro-android.git',
    }
};