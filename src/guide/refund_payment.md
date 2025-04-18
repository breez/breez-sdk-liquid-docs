# Refunding payments

The SDK handles refunding of failed payments automatically except when receiving Bitcoin payments where the refund of a failed swap has to be managed manually.

<h2 id="list-refundables">
    <a class="header" href="#list-refundables">List refundables</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.list_refundables">API docs</a>
</h2>

In order to manually execute a Bitcoin refund, you need to supply an on-chain Bitcoin address to which the refunded amount will be sent. The following code will retrieve the refundable swaps:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_onchain.rs:list-refundables}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceiveOnchain.swift:list-refundables}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceiveOnchain.kt:list-refundables}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/receive_onchain.ts:list-refundables}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_onchain.ts:list-refundables}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_onchain.dart:list-refundables}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_onchain.py:list-refundables}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_onchain.go:list-refundables}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceiveOnchain.cs:list-refundables}}
```
</section>
</custom-tabs>

<h2 id="recommended-fees">
    <a class="header" href="#recommended-fees">Recommended fees</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.recommended_fees">API docs</a>
</h2>

To refund a swap, you need to set a fee rate for the Bitcoin transaction. You can get the Bitcoin mempool fee estimates from the SDK:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_onchain.rs:recommended-fees}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceiveOnchain.swift:recommended-fees}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceiveOnchain.kt:recommended-fees}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/receive_onchain.ts:recommended-fees}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_onchain.ts:recommended-fees}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_onchain.dart:recommended-fees}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_onchain.py:recommended-fees}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_onchain.go:recommended-fees}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceiveOnchain.cs:recommended-fees}}
```
</section>
</custom-tabs>

<h2 id="refund-payment">
    <a class="header" href="#refund-payment">Refund payment</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.refund">API docs</a>
</h2>

Once you have a refundable swap, use the following code to execute a refund:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_onchain.rs:execute-refund}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceiveOnchain.swift:execute-refund}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceiveOnchain.kt:execute-refund}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/receive_onchain.ts:execute-refund}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_onchain.ts:execute-refund}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_onchain.dart:execute-refund}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_onchain.py:execute-refund}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_onchain.go:execute-refund}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceiveOnchain.cs:execute-refund}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>

A refund can be attempted several times. A common scenario where this is useful is if the initial refund transaction takes too long to mine, your application's users can be offered the ability to re-trigger the refund with a higher feerate.

</div>
