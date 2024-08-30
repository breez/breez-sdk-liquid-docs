# Sending Lightning/Liquid Payments

Once the SDK is set up, you can start sending payments too.


The `destination` field of the payment request now supports Liquid BIP21, Liquid addresses and Lightning invoices. For onchain (Bitcoin) payments, see [Sending an on-chain transaction](pay_onchain.md).

## Amount validation

There are cases in which both the destination and the user provide an amount to be paid. Here are the possible scenarios and their outcomes:
- **Liquid BIP21 URI amount and request amount field are set** - the SDK will make sure the two values match, else an error will be thrown.
- **Invoice amount and request amount field are set** - the SDK will make sure the two values match, else an error will be thrown.
- **Liquid address is used** - the SDK will make sure the request amount is set. Else, the "Amount Missing" error will be thrown.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/send_payment.rs:send-payment}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/SendPayment.swift:send-payment}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/SendPayment.kt:send-payment}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/send_payment.ts:send-payment}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/send_payment.dart:send-payment}}
```
</section>
</custom-tabs>
<div class="warning">
<h4>Developer note</h4>
Consider implementing the <a href="/notifications/getting_started.md">Notification Plugin</a> when using the Breez SDK in a mobile application. By registering a webhook the application can receive notifications to process the payment in the background.
</div>
