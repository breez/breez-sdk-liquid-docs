# Installing the SDK

The Breez SDK is available in the following platforms:

## iOS/Swift

We support integration via the [Swift Package Manager](https://www.swift.org/package-manager/) and via [CocoaPods](https://cocoapods.org/).
See [breez/breez-sdk-liquid-swift](https://github.com/breez/breez-sdk-liquid-swift) for more information.

### Swift Package Manager

#### Installation via Xcode

Via `File > Add Packages...`, add

```
https://github.com/breez/breez-sdk-liquid-swift.git
```

as a package dependency in Xcode.

#### Installation via Swift Package Manifest

Add the following to the dependencies array of your `Package.swift`:

``` swift
.package(url: "https://github.com/breez/breez-sdk-liquid-swift.git", from: "<version>"),
```

### CocoaPods

Add the Breez SDK to your `Podfile` like so:

``` ruby
target '<YourApp' do
  use_frameworks!
  pod 'BreezSDKLiquid'
end
```

## Android/Kotlin

We recommend integrating the Breez SDK as Gradle dependency from [our Maven repository](https://mvn.breez.technology/#/releases).

To do so, add the following to your Gradle dependencies:

```gradle
repositories {
  maven {
      url("https://mvn.breez.technology/releases")
  }
}

dependencies {
  implementation("breez_sdk_liquid:bindings-android:<version>")
}
```

## Javascript/Typescript (Wasm)

We recommend using the official npm package: [@breeztech/breez-sdk-liquid](https://www.npmjs.com/package/@breeztech/breez-sdk-liquid).

```console
npm install @breeztech/breez-sdk-liquid
```
or
```console
yarn add @breeztech/breez-sdk-liquid
```

## React Native

We recommend using the official npm package: [@breeztech/react-native-breez-sdk-liquid](https://www.npmjs.com/package/@breeztech/react-native-breez-sdk-liquid).

```console
npm install @breeztech/react-native-breez-sdk-liquid
```
or
```console
yarn add @breeztech/react-native-breez-sdk-liquid
```

## Go

We recommend using our official Go package: [breez/breez-sdk-liquid-go](https://github.com/breez/breez-sdk-liquid-go).

```console
go get github.com/breez/breez-sdk-liquid-go
```

## C#

We recommend using our official C# package: [Breez.Sdk.Liquid](https://www.nuget.org/packages/Breez.Sdk.Liquid).

```console
dotnet add package Breez.Sdk.Liquid
```

## Rust

We recommend to add breez sdk as a git dependency with a specific release tag.
Check https://github.com/breez/breez-sdk-liquid/releases for the latest version.

```toml
[dependencies]
breez-sdk-liquid = { git = "https://github.com/breez/breez-sdk-liquid", tag = "0.7.2" }

[patch.crates-io]
secp256k1-zkp = { git = "https://github.com/breez/rust-secp256k1-zkp.git", rev = "eac2e479255a6e32b5588bc25ee53c642fdd8395" }
```

## Flutter/Dart

We recommend to add our official flutter package as a git dependency. 

```yaml
dependencies:
  breez_liquid:
    git:
      url: https://github.com/breez/breez-sdk-liquid-dart
  flutter_breez_liquid:
    git:
      url: https://github.com/breez/breez-sdk-liquid-flutter
  rxdart: ^0.28.0
```

## Python

We recommend using our official Python package: [breez_sdk_liquid](https://pypi.org/project/breez-sdk-liquid).

```console
pip install breez_sdk_liquid
```

You can also check out some [examples](https://github.com/breez/breez-sdk-liquid-docs/tree/main/examples/python) using the Python Breez SDK package.
