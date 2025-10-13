# SWIFT

This repo contains a **Go → C → Swift wrapper** around the [CCXT Go library](https://github.com/ccxt/ccxt/tree/master/go/v4), 
designed for use in **iOS**, and **macOS**

The wrapper is packaged as a **Swift Package**:

- `CCXTSwiftCore` → XCFramework (CCXT.xcframework) generated from Go via gomobile bind
- `CCXTSwift` → Swift wrapper (CCXTExchange.swift) → depends on `CCXTSwiftCore`

## Installation

From the Xcode menu, select

    File > Add Package Dependencies

![img showing File > Add Package Dependencies](./docs/imgs/file-add-package-dependencies.png)

And in the search bar in the top right, enter [swiftRepoUrl]

![img showing File > Add Package Dependencies](./docs/imgs/add-ccxt-swift.png)

And click "Add Package" in the bottom right

Then select "Add To Target" and select your project

![img showing Add To Target](./docs/imgs/add-to-target.png)

### Signing and Capabilities

You will need to select the box under

    Signing and Capabilities > App Sandbox > Outgoing Connections (Client)

or else you will receive an error that starts with

```
Network error: Get \"https://api.binance.com/api/v2/spot/public/symbols\": dial tcp: lookup api.binance.com: no such host]\nStack:\n\nStack trace:\ngoroutine 44 [running]:\nruntime/debug.Stack()\n\t/opt/homebrew/Cellar/go/1.24.5/libexec/src/runtime/debug/stack.go:26 +0x64\ngithub.com/ccxt/ccxt/go/v4.PanicOnError({0x109a6d220, 0x140004361f0})\n\t
```

![img showing Outgoing Connections Client](./docs/imgs/outgoing-connections-client.png)

## Using CCXT

Inside `Source/CCXT/Example.swift` there are examples of how to instantiate an exchange, use it's methods and access it's properties using Swift

For further explanation on CCXT you can refer to the [CCXT docs](https://docs.ccxt.com/#/)