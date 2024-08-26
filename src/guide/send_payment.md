# Sending Lightning/Liquid Payments

Once the SDK is set up, you can start sending payments too.


The `destination` field of the payment request now supports Liquid BIP21/plain addresses and invoices. For onchain (Bitcoin) payments, see [here](pay_onchain.md).

**Note:** There are cases in which both the destination and the user provide an amount to be paid. Here are the possible scenarios and their outcomes:
- In case both the Liquid BIP21 URI and the request amount field are set, the SDK will make sure the two values match, else an error will be thrown.
- In case both the invoice amount and the request amount field are set, the SDK will make sure the two values match, else an error will be thrown.
- In case the user attempts to pay a plain Liquid address, the request amount field **must** be present. Else, the "Amount Missing" error will be thrown.

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
