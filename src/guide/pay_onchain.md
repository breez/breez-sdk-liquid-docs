# Sending an on-chain transaction

You can send funds from the Breez SDK wallet to an on-chain address as follows.

<div class="warning">
<h4>Developer note</h4>
Consider implementing the <a href="/notifications/getting_started.md">Notification Plugin</a> when using the Breez SDK in a mobile application. By registering a webhook the application can receive notifications to process the payment in the background.
</div>

<h2 id="preparing-payments">
    <a class="header" href="#preparing-payments">Preparing Payments</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_pay_onchain">API docs</a>
</h2>

When sending an onchain payment, the swap limits for sending onchain need to be first checked.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/PayOnchain.swift:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/PayOnchain.kt:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/pay_onchain.ts:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/pay_onchain.py:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/pay_onchain.go:get-current-pay-onchain-limits}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/PayOnchain.cs:get-current-pay-onchain-limits}}
```
</section>
</custom-tabs>

This represents the range of valid amounts that can be sent at this point in time. The range may change depending on the swap service parameters or mempool feerate fluctuations.

<div class="warning">
<h4>Developer note</h4>


It is best to fetch these limits just before your app shows the Pay Onchain (reverse swap) UI. You can then use these limits to validate the user input.

</div>

### Setting the receiver amount
When you want the payment receipient to receive a specific amount.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:prepare-pay-onchain}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/PayOnchain.swift:prepare-pay-onchain}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/PayOnchain.kt:prepare-pay-onchain}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/pay_onchain.ts:prepare-pay-onchain}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:prepare-pay-onchain}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:prepare-pay-onchain}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/pay_onchain.py:prepare-pay-onchain}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/pay_onchain.go:prepare-pay-onchain}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/PayOnchain.cs:prepare-pay-onchain}}
```
</section>
</custom-tabs>

If you want to set a custom fee rate when the Bitcoin transaction is claimed:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/PayOnchain.swift:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/PayOnchain.kt:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/pay_onchain.ts:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/pay_onchain.py:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/pay_onchain.go:prepare-pay-onchain-fee-rate}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/PayOnchain.cs:prepare-pay-onchain-fee-rate}}
```
</section>
</custom-tabs>

### Draining all funds
When you want send all funds from your wallet to another address.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/PayOnchain.swift:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/PayOnchain.kt:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/pay_onchain.ts:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/pay_onchain.py:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/pay_onchain.go:prepare-pay-onchain-drain}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/PayOnchain.cs:prepare-pay-onchain-drain}}
```
</section>
</custom-tabs>

<h2 id="sending-payments">
    <a class="header" href="#sending-payments">Sending Payments</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.pay_onchain">API docs</a>
</h2>

Once you checked the amounts and the fees are acceptable, you can continue with sending the payment.

Note that one of the arguments will be the result from the `prepare` call above.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:start-reverse-swap}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/PayOnchain.swift:start-reverse-swap}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/PayOnchain.kt:start-reverse-swap}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/pay_onchain.ts:start-reverse-swap}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:start-reverse-swap}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:start-reverse-swap}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/pay_onchain.py:start-reverse-swap}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/pay_onchain.go:start-reverse-swap}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/PayOnchain.cs:start-reverse-swap}}
```
</section>
</custom-tabs>
