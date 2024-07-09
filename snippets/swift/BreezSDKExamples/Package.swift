// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreezSDKDocs",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/breez/breez-liquid-sdk-swift", from:"0.1.2-dev5")
        // To use a local version of breez-liquid-sdk, comment-out the above and un-comment:
        // .package(name: "bindings-swift", path: "/local-path/breez-sdk-liquid/lib/bindings/langs/swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BreezSDKDocs",
            dependencies: [
                .product(name: "BreezLiquidSDK", package: "breez-liquid-sdk-swift"),
                // To use a local version of breez-liquid-sdk, comment-out the above and un-comment:
                // .product(name: "BreezLiquidSDK", package: "bindings-swift"),
            ],
            path: "Sources",
            linkerSettings: [
                .linkedFramework("SystemConfiguration")
            ]),
    ]
)
