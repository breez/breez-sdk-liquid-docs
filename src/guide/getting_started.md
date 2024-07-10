# Getting started

The Breez SDK enables mobile developers to integrate Lightning and bitcoin payments into their apps with a very shallow learning curve. The use cases are endless – from social apps that want to integrate tipping between users to content-creation apps interested in adding bitcoin monetization. Crucially, this SDK is an end-to-end, non-custodial, drop-in solution powered by Liquid, on-chain interoperability, third-party fiat on-ramps, and other services users and operators need.

The Breez SDK provides the following services:

* Sending payments (via various protocols such as: bolt11, keysend, lnurl-pay, lightning address, btc address, etc.)
* Receiving payments (via various protocols such as: bolt11, lnurl-withdraw, btc address, etc.)
  
## Pricing

The Breez SDK is free for developers. 

## Support

Join this [telegram group](https://t.me/breezsdk) or email us at <contact@breez.technology>.

## Installing

Breez Liquid SDK is available in several platforms. Follow the [Installing](guide/install.md) page for instructions on how to install on your platform.

## Connecting

The first step is to construct the SDK configuration. Among others, it sets the network you want to use and the SDK working directory.

The SDK uses the config `working_dir` to store the state of the SDK instance. When handling multiple instances of the SDK, one per node, each needs to have a different working directory defined.

Now you are ready to interact with the SDK.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/getting_started.rs:init-sdk}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/GettingStarted.swift:init-sdk}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/GettingStarted.kt:init-sdk}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/getting_started.ts:init-sdk}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/getting_started.dart:init-sdk}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>

By default, the config working directory is set to `./.data`. Some platforms may require that you use an application specific directory that is writable within the application sandbox. For example applications running on Android or iOS.

</div>


## Getting the Node State

At any point we can fetch our balance:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/getting_started.rs:fetch-balance}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/GettingStarted.swift:fetch-balance}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/GettingStarted.kt:fetch-balance}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/getting_started.ts:fetch-balance}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/getting_started.dart:fetch-balance}}
```
</section>
</custom-tabs>

You are now ready to receive a Lightning [payment](guide/payments.md).
