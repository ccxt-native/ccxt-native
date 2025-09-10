import { createWrapperFile } from "./shared";
import { binaries, originalFiles } from "./filepaths";
import { Property } from "./types";

function androidMethodDeclaration (
    methodName: string,
    params: {[key: string]: [string, string | null]},
    returnType: string
) {
    return `
`;
}

function androidPropertyDeclaration (prop: Property) {
    return ``;
}

function createAndroidErrors (outputFile: string) {
    return;
}

function createAndroidTypes(outputFile: string) {
    return;
}

function createAndroidExchangeClasses (outputFile: string) {
    return;
}

export default async function transpileAndroid (binaries: {[key: string]: string}) {
    for (const [key, filePath] of Object.entries (binaries)) {
        createAndroidTypes (`${filePath}/CCXTTypes.java`);
        createAndroidExchangeClasses (`${filePath}/CCXTExchanges.java`);
        createAndroidErrors (`${filePath}/CCXTErrors.java`);
        createWrapperFile (
            androidMethodDeclaration,
            androidPropertyDeclaration,
            originalFiles.androidExchange,
            `${filePath}/CCXTExchange.java`,
            {},
            key === 'pro',
        );
    }
}

const args = process.argv.slice (2);
if (args.includes ('--pro')) {
    transpileAndroid ({'pro': binaries.android.pro});
} else if (args.includes('--rest')) {
    transpileAndroid ({'rest': binaries.android.rest});
} else {
    transpileAndroid (binaries.android);
}
