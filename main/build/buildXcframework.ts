import { execSync } from "child_process";
import { existsSync, mkdirSync, readFileSync } from "fs";
import { binaries, ccxtNativeDir, gomobileHeader, originalFiles, originGoDir, swiftTranspiler } from "./filepaths";
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

// Resilient version resolution with retry/backoff and local fallback
async function sleep(ms: number) { return new Promise<void>(r => setTimeout(r, ms)); }

function parseVersion(input: string): { major: number; minor: number; patch: number } | null {
    const m = input.match(/v?(\d+)\.(\d+)\.(\d+)/);
    if (!m) return null;
    return { major: Number(m[1]), minor: Number(m[2]), patch: Number(m[3]) };
}

function bumpPatch(version: string): string {
    const parsed = parseVersion(version) || { major: 0, minor: 0, patch: 0 };
    return `v${parsed.major}.${parsed.minor}.${parsed.patch + 1}`;
}

function readExistingVersion(packagePath: string): string | null {
    try {
        const pkgPath = `${packagePath}/Package.swift`;
        if (!existsSync(pkgPath)) return null;
        const text = readFileSync(pkgPath, "utf8");
        const m = text.match(/v\d+\.\d+\.\d+/);
        return m ? m[0] : null;
    } catch (_) {
        return null;
    }
}

async function resolveVersion(swift: boolean, isPro: boolean, packagePath: string): Promise<string> {
    // 1) Explicit override
    if (process.env.CCXT_VERSION && parseVersion(process.env.CCXT_VERSION)) {
        return process.env.CCXT_VERSION as string;
    }

    // 2) Retry bumpVersion
    const attempts = Number(process.env.GH_FETCH_RETRIES || 4);
    const baseDelay = Number(process.env.GH_FETCH_RETRY_DELAY_MS || 500);
    for (let i = 1; i <= attempts; i++) {
        try {
            return await bumpVersion(swift, isPro);
        } catch (e: any) {
            const message = e?.message || String(e);
            if (i === attempts) {
                console.warn(`bumpVersion failed after ${attempts} attempts: ${message}`);
                break;
            }
            const jitter = Math.floor(Math.random() * 250);
            const delay = baseDelay * Math.pow(2, i - 1) + jitter;
            console.warn(`bumpVersion failed (attempt ${i}/${attempts}): ${message}. Retrying in ${delay}ms...`);
            await sleep(delay);
        }
    }

    // 3) Fallback to existing Package.swift version, bump patch
    const existing = readExistingVersion(packagePath);
    if (existing) {
        return bumpPatch(existing);
    }

    // 4) Last resort default
    return "v0.0.1";
}

export default async function main(binaries: {[key: string]: string}) {

    gomobileInit();

    for (const packageType of Object.keys(binaries)) {
        const packagePath = binaries[packageType];
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
        const version = await resolveVersion(true, (packageType === 'pro'), packagePath);

        createGeneratedFile (
            `${packagePath}/Package.swift`,
            [],
            originalFiles.swiftPackage,
            {
                '\\[packageType\\]': (packageType === 'pro') ? 'ccxt-pro-swift' : 'ccxt-swift',
                '\\[checksum\\]': checksum,
                '\\[version\\]': version,
            },
            true,
        )

        // Check for skipped methods only if the header file exists
        if (existsSync(gomobileHeader)) {
            checkSkippedMethods(gomobileHeader);
        } else {
            console.log(`Warning: Header file not found at ${gomobileHeader}`);
        }
    }

}

const args = process.argv.slice(2);
if (args.includes ('--pro')) {
    main ({'pro': binaries.swift.pro});
} else if (args.includes('--rest')) {
    main ({'rest': binaries.swift.rest});
} else {
    main (binaries.swift);
}
