# LNURL-Pay

<h2 id="preparing-lnurl-payments">
    <a class="header" href="#preparing-lnurl-payments">Preparing LNURL Payments</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.prepare_lnurl_pay">API docs</a>
</h2>

During the prepare step, the SDK ensures that the inputs are valid with respect to the LNURL-pay request,
and also returns the relative fees related to the payment so they can be confirmed. If the LNURL-pay invoice
includes a <a target="_blank" href="https://docs.boltz.exchange/v/api/magic-routing-hints">Magic Routing Hint</a> for a direct Liquid payment, the fees will reflect this.

#### Setting the receiver amount
When you want the payment receipient to receive a specific amount.

The SDK will also validate that the amount is within the sendable limits of the LNURL-pay request.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/lnurl_pay.rs:prepare-lnurl-pay}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/LnurlPay.swift:prepare-lnurl-pay}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/LnurlPay.kt:prepare-lnurl-pay}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/lnurl_pay.ts:prepare-lnurl-pay}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/lnurl_pay.ts:prepare-lnurl-pay}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/lnurl_pay.dart:prepare-lnurl-pay}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/lnurl_pay.py:prepare-lnurl-pay}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/lnurl_pay.go:prepare-lnurl-pay}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/LnurlPay.cs:prepare-lnurl-pay}}
```
</section>
</custom-tabs>

#### Draining all funds
When you want to send all funds from your wallet to the payment recipient.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/lnurl_pay.rs:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/LnurlPay.swift:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/LnurlPay.kt:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/lnurl_pay.ts:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/lnurl_pay.ts:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/lnurl_pay.dart:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/lnurl_pay.py:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/lnurl_pay.go:prepare-lnurl-pay-drain}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/LnurlPay.cs:prepare-lnurl-pay-drain}}
```
</section>
</custom-tabs>

<h2 id="lnurl-payments">
    <a class="header" href="#lnurl-payments">LNURL Payments</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.lnurl_pay">API docs</a>
</h2>

Once the payment has been prepared and the fees are accepted, all you have to do is pass the prepare response as an argument to the
LNURL pay method.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/lnurl_pay.rs:lnurl-pay}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/LnurlPay.swift:lnurl-pay}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/LnurlPay.kt:lnurl-pay}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/lnurl_pay.ts:lnurl-pay}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/lnurl_pay.ts:lnurl-pay}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/lnurl_pay.dart:lnurl-pay}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/lnurl_pay.py:lnurl-pay}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/lnurl_pay.go:lnurl-pay}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/LnurlPay.cs:lnurl-pay}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>
By default when the LNURL-pay results in a success action with a URL, the URL is validated to check if there is a mismatch with the LNURL callback domain. You can disable this behaviour by setting the optional validation <code>PrepareLnUrlPayRequest</code> param to false.
</div>

## Supported Specs
- [LUD-01](https://github.com/lnurl/luds/blob/luds/01.md) LNURL bech32 encoding
- [LUD-06](https://github.com/lnurl/luds/blob/luds/06.md) `payRequest` spec
- [LUD-09](https://github.com/lnurl/luds/blob/luds/09.md) `successAction` field for `payRequest`
- [LUD-16](https://github.com/lnurl/luds/blob/luds/16.md) LN Address
- [LUD-17](https://github.com/lnurl/luds/blob/luds/17.md) Support for lnurlp prefix with non-bech32-encoded LNURL URLs
