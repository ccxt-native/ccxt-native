import { createWrapperFile } from "./shared";
import { androidBinaries, originalFiles } from "./filepaths";

function androidMethodDeclaration (
    methodName: string,
    params: {[key: string]: [string, string | null]},
    returnType: string
) {
    return `
`;
}

function createAndroidErrors (outputFile: string) {
    return
}

function createAndroidTypes(outputFile: string) {
    return
}

function createAndroidExchangeClasses (outputFile: string) {
    return
}

export default function transpileAndroid () {
    for (const [key, filePath] of Object.entries (androidBinaries)) {
        createAndroidTypes (`${filePath}/CCXTTypes.java`);
        createAndroidExchangeClasses (`${filePath}/CCXTExchanges.java`);
        createAndroidErrors (`${filePath}/CCXTErrors.java`);
        createWrapperFile (
            androidMethodDeclaration,
            originalFiles.androidExchange,
            `${filePath}/CCXTExchange.java`,
            {},
            key === 'pro'
        );
    }
}

transpileAndroid ();
