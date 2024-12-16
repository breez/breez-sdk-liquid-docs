# Parsing inputs

The SDK provides a versatile and extensible parsing module designed to process a wide range of input strings and return parsed data in various standardized formats. 

Natively supported formats include: BOLT11 invoices, BOLT12 offers, LNURLs of different types, Bitcoin addresses, and others. For the complete list, consult the [API documentation](https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/enum.InputType.html).

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/parsing_inputs.rs:parse-inputs}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ParsingInputs.swift:parse-inputs}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ParsingInputs.kt:parse-inputs}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/parsing_inputs.ts:parse-inputs}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/parsing_inputs.dart:parse-inputs}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/parsing_inputs.py:parse-inputs}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/parsing_inputs.go:parse-inputs}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ParsingInputs.cs:parse-inputs}}
```
</section>
</custom-tabs>

## Supporting other input formats

The parsing module can be extended using external input parsers provided in the SDK configuration. These will be used when the input is not recognized.

You can implement and provide your own parsers, or use existing public ones.

### Configuring external parsers

Configuring external parsers can only be done before [connecting](connecting.md#connecting) and the config cannot be changed through the lifetime of the connection.

Multiple parsers can be configured, and each one is defined by:
* **Provider ID**: an arbitrary id to identify the provider input type
* **Input regex**: a regex expression that should, on a best-effort basis, identify inputs that can be processed by this parser
* **Parser URL**: a URL containing the placeholder <code>&lcub;&lcub;input&rcub;&rcub;</code>

When parsing an input that isn't recognized as one of the native input types, the SDK will check if the input conforms to any of the external parsers regex expressions. If so, it will make an HTTP `GET` request to the provided URL, replacing the placeholder with the input. If the input is recognized, the response should include in its body a string that can be parsed into one of the natively supported types.

### Public external parsers

* [**PicknPay QRs**](https://www.pnp.co.za/)
  * Maintainer: [MoneyBadger](https://www.moneybadger.co.za/)
  * Regex: `(.*)(za.co.electrum.picknpay)(.*)`
  * URL: <code>https://staging.cryptoqr.net/.well-known/lnurlp/&lcub;&lcub;input&rcub;&rcub;</code>