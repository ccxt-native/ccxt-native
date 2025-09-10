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
