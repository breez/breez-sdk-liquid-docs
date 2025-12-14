// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let isLocalDev = ProcessInfo.processInfo.environment["LOCAL_DEV"] == "1"
let breezSdkLiquid: Package.Dependency
if isLocalDev {
    breezSdkLiquid = .package(path: "../../../../breez-sdk-liquid/lib/bindings/langs/swift/")
} else {
    breezSdkLiquid = .package(
        url: "https://github.com/breez/breez-sdk-liquid-swift", exact: "0.11.2")
}

let package = Package(
    name: "BreezSDKDocs",
    platforms: [.macOS("15.0")],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        breezSdkLiquid,
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BreezSDKDocs",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(
                    name: "BreezSDKLiquid",
                    package: isLocalDev ? "swift" : "breez-sdk-liquid-swift"),
            ],
            path: "Sources",
            linkerSettings: [
                .linkedFramework("SystemConfiguration")
            ])
    ]
)
