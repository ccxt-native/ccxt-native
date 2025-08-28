import combineReadmeFiles from './combineReadme';
import transpileAndroid from './transpileAndroid';
import transpileGoWrapper from './transpileGoWrapper';
import transpileSwift from './transpileSwift';

function main() {
    transpileGoWrapper ();
    transpileSwift ();
    transpileAndroid ();
    combineReadmeFiles ();
}

main()
