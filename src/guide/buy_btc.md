# Buying Bitcoin

The SDK also provides access to a Fiat on-ramp to purchase Bitcoin using Moonpay as a provider. It will generate a Bitcoin address and prepare a URL using the specified provider. The user then needs to open the URL and proceed with the provider flow to buy Bitcoin. Once the buy is completed, the provider will transfer the purchased amount to the Bitcoin address.

## Checking the limits

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

## Preparing to buy, checking fees

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

## Generate the URL

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
