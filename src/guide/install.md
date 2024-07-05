# Installing

The Breez Liquid SDK is available in the following platforms:

## iOS/Swift

We support integration via the [Swift Package Manager](https://www.swift.org/package-manager/) and via [CocoaPods](https://cocoapods.org/).
See [breez/breez-liquid-sdk-swift](https://github.com/breez/breez-liquid-sdk-swift) for more information.

### Swift Package Manager

#### Installation via Xcode

Via `File > Add Packages...`, add

```
https://github.com/breez/breez-liquid-sdk-swift.git
```

as a package dependency in Xcode.

#### Installation via Swift Package Manifest

Add the following to the dependencies array of your `Package.swift`:

``` swift
.package(url: "https://github.com/breez/breez-liquid-sdk-swift.git", from: "<version>"),
```

### CocoaPods

Add the Breez SDK to your `Podfile` like so:

``` ruby
target '<YourApp' do
  use_frameworks!
  pod 'BreezSDK'
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
  implementation("breez_sdk:bindings-android:<version>")
}
```

See [the example](https://github.com/breez/breez-sdk-examples/tree/main/Android) for more details

## React Native

We recommend using the official npm package:

```console
npm install @breeztech/react-native-breez-sdk
```
or
```console
yarn add @breeztech/react-native-breez-sdk
```

## rust

We recommend to add breez sdk as a git dependency with a specific release tag.
Check https://github.com/breez/breez-sdk/releases for the latest version.

```toml
[dependencies]
breez-liquid-sdk = { git = "https://github.com/breez/breez-liquid-sdk", tag = "0.1.1" }

[patch.crates-io]
secp256k1-zkp = {git = "https://github.com/sanket1729/rust-secp256k1-zkp.git", rev = "60e631c24588a0c9e271badd61959294848c665d"}
```

## Flutter/Dart

We recommend to add our official flutter package as a git dependency. 

```yaml
dependencies:
  breez_liquid:
    git:
      url: https://github.com/breez/breez-liquid-sdk-dart
  flutter_breez_liquid:
    git:
      url: https://github.com/breez/breez-liquid-sdk-flutter
  rxdart: ^0.28.0
```
