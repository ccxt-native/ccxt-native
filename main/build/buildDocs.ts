import { copyFileSync, readFileSync, writeFileSync } from "fs";
import { binaries, ccxtNativeDir, licenseFile, readmeFiles, repoUrls } from "./filepaths";

export function combineMarkdownFiles(
    outputFile: string,
    files: string[],
    replacements: Record<string, string> = {}
): void {
    const contents = files.map(file => readFileSync(file, "utf-8").trim());
    let combined = contents.join("\n\n---\n\n") + "\n";

    // Apply replacements
    for (const [search, replace] of Object.entries(replacements)) {
        const regex = new RegExp(search, "g");
        combined = combined.replace(regex, replace);
    }

    writeFileSync(outputFile, combined, "utf-8");
}

export default function main () {
    for (const os of [ 'android', 'swift' ]) {
        for (const packageType of Object.keys(binaries[os])) {
            
            const packagePath = binaries[os][packageType];
            copyFileSync(licenseFile, `${packagePath}/LICENSE.txt`);
            combineMarkdownFiles(
                `${packagePath}/README.md`,
                [
                    readmeFiles.ccxtNative,
                    readmeFiles[os],
                    readmeFiles.ccxt,
                ],
                {
                    '\\[swiftRepoUrl\\]': repoUrls.swift[packageType],
                    '\\[androidRepoUrl\\]': repoUrls.android[packageType],
                },
            );
        }
    }

    // Create main README.md
    combineMarkdownFiles(
        `${ccxtNativeDir}/README.md`,
        [
            readmeFiles.ccxtNative,
            readmeFiles.swift,
            readmeFiles.android,
            readmeFiles.ccxt,
        ],
        {
            '\\[swiftRepoUrl\\]': repoUrls.swift.pro,
            '\\[androidRepoUrl\\]': repoUrls.android.pro,
        },
    );
};

main();