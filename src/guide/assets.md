# Handling multiple assets

The Liquid sidechain can also be used to send and receive other assets registered on the Liquid Network. Using the SDK you can send and receive these assets by using a Liquid payment with an additional asset ID. By default the SDK includes the metadata for L-BTC and Tether USD. To include addition asset metadata, see [Adding asset metadata](#adding-asset-metadata).

## Adding asset metadata <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/model/struct.Config.html#structfield.asset_metadata">API docs</a>

You can add addition asset metadata to the SDK when you configure it on connect. In the example below we will add the [PEGx EUR](https://assets.blockstream.info/18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec.json) asset. Once the asset metadata is added, it can be used as an asset to send and receive. 
You can find the asset metadata for other assets in the Mainnet [Liquid Asset Registry](https://assets.blockstream.info/) ([Testnet](https://assets-testnet.blockstream.info/)).

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:configure-asset-metadata}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:configure-asset-metadata}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:configure-asset-metadata}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:configure-asset-metadata}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:configure-asset-metadata}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:configure-asset-metadata}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:configure-asset-metadata}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:configure-asset-metadata}}
```
</section>
</custom-tabs>

## Fetching the asset balances <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.get_info">API docs</a>

Once connected, the asset balances can be retreived.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:fetch-asset-balance}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:fetch-asset-balance}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:fetch-asset-balance}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:fetch-asset-balance}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:fetch-asset-balance}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:fetch-asset-balance}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:fetch-asset-balance}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:fetch-asset-balance}}
```
</section>
</custom-tabs>

## Receiving a non-Bitcoin asset <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_receive_payment">API docs</a>

When receiving an asset via Liquid, we can generate a BIP21 URI with information regarding the payment of a specific asset. The amount to receive is optional and omitting it will result in an amountless BIP21 URI. 

In the example below we are using the [Mainnet Tether USD](https://assets.blockstream.info/ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2.json) asset. 

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:prepare-receive-payment-asset}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:prepare-receive-payment-asset}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:prepare-receive-payment-asset}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:prepare-receive-payment-asset}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:prepare-receive-payment-asset}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:prepare-receive-payment-asset}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:prepare-receive-payment-asset}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:prepare-receive-payment-asset}}
```
</section>
</custom-tabs>
<br/>

## Sending a non-Bitcoin asset <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_send_payment">API docs</a>

When sending an asset via Liquid, a BIP21 URI or Liquid address can be used as the destination. If a Liquid address is used, the optional prepare request amount **must** be set. If a BIP21 URI is used, either the BIP21 URI amount or optional prepare request amount **must** be set. When both amounts are set, the SDK will prioritize the **request amount** over the BIP21 amount. 

In the example below we are using the [Mainnet Tether USD](https://assets.blockstream.info/ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2.json) asset. 

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:prepare-send-payment-asset}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:prepare-send-payment-asset}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:prepare-send-payment-asset}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:prepare-send-payment-asset}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:prepare-send-payment-asset}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:prepare-send-payment-asset}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:prepare-send-payment-asset}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:prepare-send-payment-asset}}
```
</section>
</custom-tabs>
