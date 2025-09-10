import { binaries } from './filepaths';
import transpileAndroid from './transpileAndroid';
import transpileGoWrapper from './transpileGoWrapper';
import transpileSwift from './transpileSwift';
import buildXcframework from './buildXcframework';

function main() {
    transpileGoWrapper ();
    transpileSwift (binaries.swift);
    transpileAndroid (binaries.android);
    buildXcframework (binaries.swift);
}

main();
