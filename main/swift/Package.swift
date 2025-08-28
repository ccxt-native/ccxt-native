// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CCXT",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "CCXT",
            type: .static,
            targets: ["CCXT"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "CCXTCore",
            // path: "Sources/CCXTCore/CCXTCore.xcframework",  // for local development
            url: "https://github.com/ccxt-native/[packageType]/releases/download/[version]/CCXTCore.xcframework.zip",
            checksum: "[checksum]"
        ),
        .target(
            name: "CCXT",
            dependencies: ["CCXTCore"],
            path: "Sources/CCXT"
        )
    ]
)
