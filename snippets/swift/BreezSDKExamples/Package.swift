// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreezSDKDocs",
    platforms: [.macOS("15.0")],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/breez/breez-sdk-liquid-swift", exact: "0.11.2")
        // To use a local version of breez-sdk-liquid, comment-out the above and un-comment:
        // .package(name: "bindings-swift", path: "/local-path/breez-sdk-liquid/lib/bindings/langs/swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BreezSDKDocs",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "BreezSDKLiquid", package: "breez-sdk-liquid-swift"),
                // To use a local version of breez-sdk-liquid, comment-out the above and un-comment:
                // .product(name: "BreezSDKLiquid", package: "bindings-swift"),
            ],
            path: "Sources",
            linkerSettings: [
                .linkedFramework("SystemConfiguration")
            ]),
    ]
)
