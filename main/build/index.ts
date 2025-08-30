import { androidBinaries, swiftBinaries } from './filepaths';
import transpileAndroid from './transpileAndroid';
import transpileGoWrapper from './transpileGoWrapper';
import transpileSwift from './transpileSwift';

function main() {
    transpileGoWrapper ();
    transpileSwift (swiftBinaries);
    transpileAndroid (androidBinaries);
}

main();
