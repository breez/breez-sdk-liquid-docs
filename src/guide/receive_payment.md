# Receiving Payments

With the Breez Liquid SDK you aren't required to open a channel and set up your inbound liquidity.

Once the SDK is initialized, you can directly begin receiving payments. The receive process takes two steps:
1. [Preparing the Payment](receive_payment.md#preparing-payments)
1. [Receiving the Payment](receive_payment.md#receiving-payments-1)

## Preparing Payments
During the prepare step, the SDK ensures that the inputs are valid with respect to the specified payment method,
and also returns the relative fees related to the payment so they can be confirmed.


The SDK currently supports three methods of receiving: Lightning, Liquid and Cross-chain (Bitcoin):

### Lightning
When receiving via Lightning, we generate an invoice to be paid.  Note that the payment may fallback to a direct Liquid payment (if the payer's client supports this).


**Note:** The amount field is currently mandatory when paying via Lightning.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_payment.rs:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceivePayment.swift:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceivePayment.kt:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_payment.ts:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_payment.dart:prepare-receive-payment-lightning}}
```
</section>
</custom-tabs>

### Liquid
When receiving via Liquid, we can either generate an address to receive to, or a BIP21 URI with information regarding the payment (currently only the amount and message).


To generate a BIP21 address, all you have to do is specify a payer amount.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_payment.rs:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceivePayment.swift:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceivePayment.kt:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_payment.ts:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_payment.dart:prepare-receive-payment-liquid}}
```
</section>
</custom-tabs>

### Cross-chain (Bitcoin)
When receiving via Bitcoin, we generate a Bitcoin BIP21 URI to be paid.


**Note:** The amount field is currently mandatory when paying via Bitcoin.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_payment.rs:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceivePayment.swift:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceivePayment.kt:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_payment.ts:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_payment.dart:prepare-receive-payment-onchain}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>

The above checks include validating against maximum and minimum limits. Your application's users must be informed of these limits because if the amount transferred to the swap address falls outside this valid range, the funds will not be successfully received via the normal swap flow. In such cases, a manual refund will be necessary.

</div>

## Receiving Payments
Once the payment has been prepared, all you have to do is pass the prepare response as an argument to the
receive method, optionally specifying a description.

**Note:** The description field will be used differently, depending on the payment method:
- For Lightning payments, it will be encoded in the invoice
- For Bitcoin/Liquid BIP21 payments, it will be encoded in the URI as the `message` field.
- For plain Liquid payments, the description has no effect.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_payment.rs:receive-payment}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceivePayment.swift:receive-payment}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceivePayment.kt:receive-payment}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_payment.ts:receive-payment}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_payment.dart:receive-payment}}
```
</section>
</custom-tabs>
