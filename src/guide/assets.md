# Handling multiple assets

The Liquid sidechain can also be used to send and receive other assets registered on the Liquid Network. Using the SDK you can send and receive these assets by using a Liquid payment with an additional asset ID. By default the SDK includes the metadata for [L-BTC and Tether USD](#default-asset-metadata). To include addition asset metadata, see [Adding asset metadata](#adding-asset-metadata).

<h2 id="adding-asset-metadata">
    <a class="header" href="#adding-asset-metadata">Adding asset metadata</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/model/struct.Config.html#structfield.asset_metadata">API docs</a>
</h2>

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

### Default asset metadata
#### Mainnet
| Name | Ticker | Asset ID | Precision | 
| --- | --- | --- | --- |
| Bitcoin | BTC | 6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d | 8 |
| Tether USD | USDt | ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2 | 8 |

#### Testnet
| Name | Ticker | Asset ID | Precision | 
| --- | --- | --- | --- |
| Testnet Bitcoin | BTC | 144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49 | 8 |
| Testnet Tether USD | USDt | b612eb46313a2cd6ebabd8b7a8eed5696e29898b87a43bff41c94f51acef9d73 | 8 |

<h2 id="fetching-the-asset-balances">
    <a class="header" href="#fetching-the-asset-balances">Fetching the asset balances</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.get_info">API docs</a>
</h2>

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

<h2 id="receiving-a-non-bitcoin-asset">
    <a class="header" href="#receiving-a-non-bitcoin-asset">Receiving a non-Bitcoin asset</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_receive_payment">API docs</a>
</h2>

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

<h2 id="sending-a-non-bitcoin-asset">
    <a class="header" href="#sending-a-non-bitcoin-asset">Sending a non-Bitcoin asset</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_send_payment">API docs</a>
</h2>

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

<h2 id="paying-fees-with-a-non-bitcoin-asset">
    <a class="header" href="#sending-a-non-bitcoin-asset">Paying fees with a non-Bitcoin asset</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_send_payment">API docs</a>
</h2>

For some assets, like [Tether USD](https://assets.blockstream.info/ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2.json), you can pay the sending transaction fees with the asset. 

<div class="warning">
<h4>Developer note</h4>

When adding additional [asset metadata](#adding-asset-metadata), the optional **fiat ID** has to be set and the Payjoin provider has to support paying fees for this asset. When the asset is not supported, the **asset fees** in the prepare send payment response will be not set.

</div>

In the prepare send payment step, set the **estimate asset fees** param to `true` to validate and calculate the **asset fees**.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:prepare-send-payment-asset-fees}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:prepare-send-payment-asset-fees}}
```
</section>
</custom-tabs>

If the **asset fees** are set in the response, then set the **use asset fees** to `true` to pay fees with the asset. You can still pay fees in satoshi if you set the **use asset fees** to `false` (default).

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/non_bitcoin_asset.rs:send-payment-fees}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NonBitcoinAsset.swift:send-payment-fees}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NonBitcoinAsset.kt:send-payment-fees}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/non_bitcoin_asset.ts:send-payment-fees}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/non_bitcoin_asset.dart:send-payment-fees}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/non_bitcoin_asset.py:send-payment-fees}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/non_bitcoin_asset.go:send-payment-fees}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NonBitcoinAsset.cs:send-payment-fees}}
```
</section>
</custom-tabs>
