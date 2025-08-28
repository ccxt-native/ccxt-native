import { execSync } from "child_process";
import { existsSync, mkdirSync, readFileSync, copyFileSync, writeFileSync } from "fs";
import { swiftBinaries, ccxtNativeDir, gomobileHeader, licenseFile, originalFiles, originGoDir, readmeFiles, swiftTranspiler } from "./filepaths";
import stripComments from "./stripComments";
import { bumpVersion, createGeneratedFile } from "./shared";

function runCommand(command: string, env?: NodeJS.ProcessEnv): string {
    console.log(`> ${command}`);
    return execSync(command, { stdio: ["ignore", "pipe", "inherit"], env: { ...process.env, ...env } }).toString().trim();
}

/**
 * Checks if a any of the methods in the go wrapper have invalid param types and were skipped
 * @param headerFile The CGO file that contains the method headers
 */
function checkSkippedMethods(headerFile: string) {
    const headerContent = readFileSync(headerFile, "utf8");   
    const skippedMethods = [...headerContent.matchAll(/skipped method [^.]*\.([A-Za-z0-9_]+)/g)].map(m => m[1]);
    if (skippedMethods.length > 0) {
        const methodList = skippedMethods.join(", ");
        console.error(`ERROR: ${methodList} contain invalid param types in ${originalFiles.gowrapper}, param types can only include int, float64, string, bool and []byte. If it is a custom type, it must be added to the customTypes array in ${swiftTranspiler}`);
        process.exit(1);
    }
}

function gomobileInit() {
    process.chdir(`${ccxtNativeDir}/main/build`);
    runCommand("go get golang.org/x/mobile/cmd/gomobile@latest");
    runCommand("go get golang.org/x/mobile/bind@latest");
    runCommand("gomobile init");
}

function combineMarkdownFiles(file1: string, file2: string, outputFile: string): void {
    const content1 = readFileSync(file1, "utf-8");
    const content2 = readFileSync(file2, "utf-8");
  
    const combined = `${content1.trim()}\n\n${content2.trim()}\n`;
  
    writeFileSync(outputFile, combined, "utf-8");
}

function stripAllBinaries(xcframeworkPath: string, frameworkName: string) {
    const shouldStrip = process.env.STRIP_MACHO === "1";
    if (shouldStrip) {
        // find all contained .framework dirs and strip their Mach-O binaries
        const findFrameworksCmd = `find "${xcframeworkPath}" -type d -name "*.framework" -maxdepth 4`;
        const output = execSync(findFrameworksCmd, { stdio: ["ignore", "pipe", "inherit"] }).toString().trim();
        if (output) {
            const frameworkDirs = output.split("\n").filter(Boolean);
            for (const dir of frameworkDirs) {
                // binary is <dir>/<FrameworkName>
                const binPath = `${dir}/${frameworkName.replace(/\.xcframework$/, "")}`;
                try {
                    // run strip quietly; failures are common for Go objects, ignore them
                    execSync(`xcrun strip -S -x "${binPath}"`, { stdio: ["ignore", "ignore", "ignore"] });
                } catch (_) {
                    // ignore if strip fails for any slice
                }
            }
        }
    }
    // remove any dSYM bundles that may exist
    try {
        runCommand(`find "${xcframeworkPath}" -name "*.dSYM" -exec rm -rf {} +`);
    } catch (_) {
        // ignore
    }
}

async function main() {

    gomobileInit();

    for (const packageType of Object.keys(swiftBinaries)) {
        const packagePath = swiftBinaries[packageType];
        const outputDir = `${packagePath}/Sources/CCXTCore`;
        const framework = `CCXTCore.xcframework`;

        if (!existsSync(outputDir)) {
            mkdirSync(outputDir, { recursive: true });
        }
        process.env.GOMOBILE_WORK = `${originGoDir}/.cache/gomobile`;

        // Change to the directory that contains the transpiled Go source files
        process.chdir(packagePath);
        stripComments();

        // Build with size-reduction flags, preserving all targets
        const ldflags = "-s -w -buildid="; // strip symbol/debug tables and omit build id
        const gcflags = "all=-trimpath";   // remove absolute paths from DWARF
        const goenv: NodeJS.ProcessEnv = { GOFLAGS: "-trimpath -buildvcs=false" };
        runCommand(`gomobile bind -ldflags=\"${ldflags}\" -gcflags=${gcflags} -target=ios,iossimulator,macos -o "${outputDir}/${framework}" .`, goenv);

        // Strip all slice binaries inside the xcframework (best-effort)
        stripAllBinaries(`${outputDir}/${framework}`, framework);

        // Zip with deterministic options using ditto (preserves symlinks, avoids bloat)
        runCommand(`ditto -c -k --sequesterRsrc --keepParent "${outputDir}/${framework}" "${outputDir}/${framework}.zip"`);
        const checksum = runCommand(`swift package compute-checksum ${outputDir}/${framework}.zip`);
        const version = await bumpVersion(true, (packageType === 'pro'));

        createGeneratedFile (
            `${packagePath}/Package.swift`,
            [],
            originalFiles.swiftPackage,
            {
                '\\[packageType\\]': (packageType === 'pro') ? 'swift-pro' : 'swift',
                '\\[checksum\\]': checksum,
                '\\[version\\]': version,
            },
            true,
        )
        copyFileSync(licenseFile, `${packagePath}/LICENSE.txt`);
        combineMarkdownFiles(readmeFiles.ccxtNative, readmeFiles.ccxt, `${packagePath}/README.md`);

        // Check for skipped methods only if the header file exists
        if (existsSync(gomobileHeader)) {
            checkSkippedMethods(gomobileHeader);
        } else {
            console.log(`Warning: Header file not found at ${gomobileHeader}`);
        }
    }
}

main();
