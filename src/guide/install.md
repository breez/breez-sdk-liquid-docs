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


## React Native

We recommend using the official npm package:

```console
npm install @breeztech/react-native-breez-sdk-liquid
```
or
```console
yarn add @breeztech/react-native-breez-sdk-liquid
```

## rust

We recommend to add breez sdk as a git dependency with a specific release tag.
Check https://github.com/breez/breez-sdk-liquid/releases for the latest version.

```toml
[dependencies]
breez-sdk-liquid = { git = "https://github.com/breez/breez-sdk-liquid", tag = "0.1.1" }

[patch.crates-io]
secp256k1-zkp = {git = "https://github.com/sanket1729/rust-secp256k1-zkp.git", rev = "60e631c24588a0c9e271badd61959294848c665d"}
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
