# Required installs

The built binaries are > 100mb, so git large file system must be used

```sh
apt-get install git-lfs
```

```sh
brew install git-lfs
```

# SETUP

Clone ccxt-native's ccxt and ccxt-native repository

```sh
git clone https://github.com/ccxt-native/ccxt
cd ccxt
npm run build; npm run transpileGO; npm run buildGO
git clone https://github.com/ccxt-native/ccxt-native
cd ccxt-native
git clone https://github.com/ccxt-native/ccxt-swift
git clone https://github.com/ccxt-native/ccxt-pro-swift
git clone https://github.com/ccxt-native/ccxt-android
git clone https://github.com/ccxt-native/ccxt-pro-android
```

## Do not clone from https://github.com/ccxt/ccxt

CCXT Native's version of the CCXT repo has some necessary updates that have not yet been merged into the main CCXT repo

# PATCHING GO

If building with an arm mac, GO must be patched

```sh
npm run patchGO  # requires sudo permission
```

# Make all changes inside `ccxt-native/main`

The other directories (ccxt-swift, ccxt-pro-swift, ccxt-android, and ccxt-pro-android) are transiled/built code, any changes written inside will be overwritten (excluding the `.gitignore`)

Changes may also be made to

- package.json
- .gitignore
- docs
- .github

and will not be overwritten

# BUILDING SWIFT AND ANDROID

To transpile and build code after making changes, run

```sh
npm run build
```

This builds the Swift packages and copies all the files from `main/swift` and `main/go`, adds transpiled code, and builds the XCFrameworks for iOS and mac development into

- `ccxt-native/ccxt-swift`
- `ccxt-native/ccxt-pro-swift`
- `ccxt-native/ccxt-android`
- `ccxt-native/ccxt-pro-android`

## Swift

After building swift, to test locally, uncomment this line from within `Package.swift`

```swift
path: "Sources/CCXTCore/CCXTCore.xcframework"
```

and comment out the two lines below it, that should look something like 

```swift
//            url: "https://github.com/ccxt-native/swift-pro/releases/download/v0.0.7/CCXTCore.xcframework.zip",
//            checksum: "4dbaa1ab815ca93b1e10e581a5b456d952b1e76e39478c79d0360ef587acd77d"
```

# Steps for pushing a new release

```sh
cd ../ccxt
git pull origin master
git switch main
git merge master
```

- accept all deletions from master
- resolve typescript conflicts

```sh
npm run force-transpile
npm run build
npm run transpileGO
npm run transpileCS
```

- resolve all remaining conflicts
- add all conflict files to staged changes

```sh
git commit
git push ccxt-native main
```

```sh
cd ccxt-native
npm run build
git add -A
git commit -m "..."
git push origin master
```

```sh
cd ccxt-swift
git add -A 
git commit -m "v*"  # look in the Package.swift
git push origin master
```

```sh
cd ../ccxt-pro-swift
git add -A
git commit -m "v*"  # look in the Package.swift
git push origin master
```

- upload `ccxt-native/ccxt-swift/Sources/CCXTCore/CCXTCore.xcframework.zip` and `ccxt-native/ccxt-pro-swift/Sources/CCXTCore/CCXTCore.xcframework.zip` to github large file storage
    - from the home page of the ccxt swift and ccxt pro swift repo, under Releases on the right hand side, click `+ * releases`
    ![](./docs/imgs/github-large-file-storage/click-releases.png)
    - click Draft a new release
    ![](./docs/imgs/github-large-file-storage/draft-new-release.png)
    - create a new tag whose name matches the version number
    ![](./docs/imgs/github-large-file-storage/create-new-tag.png)
    - upload the CCXTCore.xcframework.zip file and publish the release
    ![](./docs/imgs/github-large-file-storage/publish-release.png)