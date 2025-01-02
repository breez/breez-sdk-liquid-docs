# Receiving payments

With the Breez SDK you aren't required to open a channel and set up your inbound liquidity.

Once the SDK is initialized, you can directly begin receiving payments. The receive process takes two steps:
1. [Preparing the Payment](receive_payment.md#preparing-payments)
1. [Receiving the Payment](receive_payment.md#receiving-payments-1)

<div class="warning">
<h4>Developer note</h4>
Consider implementing the <a href="/notifications/getting_started.md">Notification Plugin</a> when using the Breez SDK in a mobile application. By registering a webhook the application can receive notifications to process the payment in the background.
</div>

## Preparing Payments
During the prepare step, the SDK ensures that the inputs are valid with respect to the specified payment method,
and also returns the relative fees related to the payment so they can be confirmed.


The SDK currently supports three methods of receiving: Lightning, Bitcoin and Liquid:

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

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_payment.py:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_payment.go:prepare-receive-payment-lightning}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceivePayment.cs:prepare-receive-payment-lightning}}
```
</section>
</custom-tabs>

### Bitcoin
When receiving via Bitcoin, we generate a Bitcoin BIP21 URI to be paid.

The `amount` field is optional when preparing a Bitcoin payment. However, if no amount is provided, the returned fees will only be an estimation. This is because:

1. The fees have an amount-dependent component that can only be determined once the sender initiates the payment
2. The fees also depend on current onchain fee conditions, which may change between the time of preparation and actual payment

If the onchain fee rate increases between preparation and payment time, the payment will be put on hold until the user explicitly confirms the new fees. To learn more about this, see the [Amountless Bitcoin Payments](#amountless-bitcoin-payments) section below.

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

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_payment.py:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_payment.go:prepare-receive-payment-onchain}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceivePayment.cs:prepare-receive-payment-onchain}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>

The above checks include validating against maximum and minimum limits. **Even when no specific amount is provided**, the amount transferred to the swap address must still fall within these limits. Your application's users must be informed of these limits because if the amount transferred falls outside this valid range, the funds will not be successfully received via the normal swap flow. In such cases, a manual refund will be necessary.
For further instructions on how to execute a manual refund, see the section on [refunding payments](refund_payment.md#bitcoin).

</div>

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

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_payment.py:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_payment.go:prepare-receive-payment-liquid}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceivePayment.cs:prepare-receive-payment-liquid}}
```
</section>
</custom-tabs>

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

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_payment.py:receive-payment}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_payment.go:receive-payment}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceivePayment.cs:receive-payment}}
```
</section>
</custom-tabs>

### Amountless Bitcoin Payments

To receive a Bitcoin payment that does not specify an amount, it may be necessary to explicitly accept the associated fees. This will be the case when the onchain fee rate increases between preparation and payment time.

Alternatively, if the fees are considered too high, the user can either choose to wait for them to come down or outright refund the payment. To learn more about refunds, see the [Refunding payments](./refund_payment.md#refunding-payments) section.

To reduce the likelihood of this extra fee review step being necessary, you can configure a fee rate leeway in the SDK's configuration that will automatically accept slightly higher fees within the specified tolerance.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_onchain.rs:handle-payments-waiting-fee-acceptance}}
```
</section>
</custom-tabs>
