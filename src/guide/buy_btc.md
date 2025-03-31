# Buying Bitcoin

The SDK also provides access to a Fiat on-ramp to purchase Bitcoin using Moonpay as a provider. It will generate a Bitcoin address and prepare a URL using the specified provider. The user then needs to open the URL and proceed with the provider flow to buy Bitcoin. Once the buy is completed, the provider will transfer the purchased amount to the Bitcoin address.

<h2 id="checking-the-limits">
    <a class="header" href="#checking-the-limits">Checking the limits</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.fetch_onchain_limits">API docs</a>
</h2>

Fetch the current onchain limits to check the minimum and maximum allowed to purchase.

<custom-tabs category="lang">

<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/buy_btc.rs:onchain-limits}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/BuyBtc.swift:onchain-limits}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/BuyBtc.kt:onchain-limits}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/buy_btc.ts:onchain-limits}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/buy_btc.ts:onchain-limits}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/buy_btc.dart:onchain-limits}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/buy_btc.py:onchain-limits}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/buy_btc.go:onchain-limits}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/BuyBtc.cs:onchain-limits}}
```
</section>
</custom-tabs>

<h2 id="preparing-to-buy-checking-fees">
    <a class="header" href="#preparing-to-buy-checking-fees">Preparing to buy, checking fees</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_buy_bitcoin">API docs</a>
</h2>

Using the current onchain limits, select a provider and amount to purchase.

<custom-tabs category="lang">

<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/buy_btc.rs:prepare-buy-btc}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/BuyBtc.swift:prepare-buy-btc}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/BuyBtc.kt:prepare-buy-btc}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/buy_btc.ts:prepare-buy-btc}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/buy_btc.ts:prepare-buy-btc}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/buy_btc.dart:prepare-buy-btc}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/buy_btc.py:prepare-buy-btc}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/buy_btc.go:prepare-buy-btc}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/BuyBtc.cs:prepare-buy-btc}}
```
</section>
</custom-tabs>

<h2 id="generate-the-url">
    <a class="header" href="#generate-the-url">Generate the URL</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.buy_bitcoin">API docs</a>
</h2>

Generate a URL to the provider with a Bitcoin address to receive the purchase to. You can also pass in an optional redirect URL here that the provider redirects to after a successful purchase.

<custom-tabs category="lang">

<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/buy_btc.rs:buy-btc}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/BuyBtc.swift:buy-btc}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/BuyBtc.kt:buy-btc}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/buy_btc.ts:buy-btc}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/buy_btc.ts:buy-btc}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/buy_btc.dart:buy-btc}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/buy_btc.py:buy-btc}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/buy_btc.go:buy-btc}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/BuyBtc.cs:buy-btc}}
```
</section>
</custom-tabs>
