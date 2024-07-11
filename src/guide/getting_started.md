# Getting Started

## What is the Breez SDK?

The Breez SDK provides developers with a end-to-end solution for integrating self-custodial Lightning payments into their apps and services. It eliminates the need for third-parties, simplifies the complexities of Bitcoin and Lightning, and enables seamless onboarding for billions of users to the future of peer-to-peer payments.

To provide the best experience for their end-users, developers can choose between the following implementations:

* [Greenlight](https://sdk-doc.breez.technology/#getting-started) 
* [Liquid](https://sdk-doc-liquid.breez.technology/#what-is-the-liquid-implementation)

## What is the Liquid implementation?

The Liquid implementation is a nodeless Lightning integration. It offers a self-custodial, end-to-end solution for developers, utilizing the Liquid Network with on-chain interoperability and third-party fiat on-ramps.

The Liquid implementation provides the following services:

* Sending payments
  * Via various protocols such as: bolt11, lnurl-pay, lightning address, btc address, etc.

* Receiving payments
  * Via various protocols such as: bolt11, lnurl-withdraw, btc address, etc.

### Features of the Liquid implementation

- No channel management or LSP required
- No setup fees for end-users 
- Trust profile is with the Liquid side-chain
- Minimum payment size of 1,000 sats
- Low, static Liquid on-chain fees
  
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

