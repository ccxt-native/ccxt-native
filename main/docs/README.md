# CCXT NATIVE

Swift and Android package for CCXT

This repo contains a **Go → C → Swift wrapper** around the [CCXT Go library](https://github.com/ccxt/ccxt/tree/master/go/v4), 
designed for use in **iOS**, **macOS** and **android**(soon) apps

The wrapper is packaged as a **Swift Package**:

- `CCXTSwiftCore` → XCFramework (CCXT.xcframework) generated from Go via gomobile bind
- `CCXTSwift` → Swift wrapper (CCXTExchange.swift) → depends on `CCXTSwiftCore`
