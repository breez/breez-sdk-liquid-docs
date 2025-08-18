<h1 id="configuration">
    <a class="header" href="#configuration">Custom configuration</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/model/struct.Config.html">API docs</a>
</h1>

The SDK can be configured in several ways to handle custom behaviour. When [Connecting and disconnecting](connecting.md#connecting) to the SDK it can be set to use a default configuration. Some of the configurable options include:

- **[Asset Metadata]** to add custom assets that the SDK can manage
- **[External Parsers]** to parse custom input strings
- **[Magic Routing Hints]** to set how the SDK handles direct Liquid payments

[Asset Metadata]: assets.md#adding-asset-metadata
[External Parsers]: parse.md#supporting-other-input-formats
[Magic Routing Hints]: #magic-routing-hints

## Magic Routing Hints

By default the SDK uses <a target="_blank" href="https://docs.boltz.exchange/v/api/magic-routing-hints">Magic Routing Hints (MRH)</a> in order to bypass using swaps when both sender and receiver use Liquid. A side effect of this is that when sending using the Magic Routing Hint, you don't receive the payment preimage from the receiver when the payment is complete. You can disable this behavour and always use swaps in the config.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/configuration.rs:configure-magic-routing-hints}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Configuration.swift:configure-magic-routing-hints}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Configuration.kt:configure-magic-routing-hints}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/configuration.ts:configure-magic-routing-hints}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/configuration.ts:configure-magic-routing-hints}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/configuration.dart:configure-magic-routing-hints}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/configuration.py:configure-magic-routing-hints}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/configuration.go:configure-magic-routing-hints}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Configuration.cs:configure-magic-routing-hints}}
```
</section>
</custom-tabs>
