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
git clone https://github.com/ccxt-native/ccxt-native
```

# PATCHING GO

GO must be patched

- the following script works on mac

```sh
npm run patchGO
```

Any changes must be made inside `ccxt-native/main` the other directories are transiled/built code

DO NOT make changes inside

- `ccxt-native/swift`
- `ccxt-native/swift-pro`

# BUILDING SWIFT

To transpile and build code after making changes, run 

```sh
npm run build
```

This builds the Swift packages and copies all the files from `main/swift` and `main/go`, adds transpiled code, and builds the XCFrameworks for iOS and mac development into

- `ccxt-native/swift`
- `ccxt-native/swift-pro`
