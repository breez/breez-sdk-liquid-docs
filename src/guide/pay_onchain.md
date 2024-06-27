# Sending an on-chain transaction (Swap-Out)

You can send funds from the Breez SDK wallet to an on-chain address as follows.

## Checking the limits
First, fetch the current reverse swap limits:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/pay_onchain.rs:get-current-reverse-swap-limits}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/SendOnchain.swift:get-current-reverse-swap-limits}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/SendOnchain.kt:get-current-reverse-swap-limits}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/pay_onchain.ts:get-current-reverse-swap-limits}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/pay_onchain.dart:get-current-reverse-swap-limits}}
```
</section>
</custom-tabs>

This represents the range of valid amounts that can be sent at this point in time. The range may change depending on the wallet's liquidity, swap service parameters or mempool feerate fluctuations.

<div class="warning">
<h4>Developer note</h4>


It is best to fetch these limits just before your app shows the Pay Onchain (reverse swap) UI. You can then use these limits to validate the user input.

</div>

## Preparing to send, checking fees
The next step is to find out the fees:

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
{{#include ../../snippets/swift/BreezSDKExamples/Sources/SendOnchain.swift:prepare-pay-onchain}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/SendOnchain.kt:prepare-pay-onchain}}
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
</custom-tabs>


## Executing the Swap

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
{{#include ../../snippets/swift/BreezSDKExamples/Sources/SendOnchain.swift:start-reverse-swap}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/SendOnchain.kt:start-reverse-swap}}
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
</custom-tabs>

