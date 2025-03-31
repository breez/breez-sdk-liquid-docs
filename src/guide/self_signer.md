<h2 id="connecting-an-external-signer">
    <a class="header" href="#connecting-an-external-signer">Connecting an External Signer</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.connect_with_signer">API docs</a>
</h2>

By default, the SDK uses mnemonics to generate keys and sign transactions. However, in some cases, developers would prefer not to pass the seed key to the SDK. In these cases, you can provide an external signer that provides more control over key management and signing.

To use an external signer, you'll need to:

1. Implement the `Signer` trait/interface
2. Use `connect_with_signer` instead of `connect` when initializing the SDK

Here's how to implement this:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/self_signer.rs:self-signer}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/SelfSigner.swift:self-signer}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/SelfSigner.kt:self-signer}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript 
{{#include ../../snippets/wasm/self_signer.ts:self-signer}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/self_signer.py:self-signer}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/self_signer.go:self-signer}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
  {{#include ../../snippets/csharp/SelfSigner.cs:self-signer}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>
A reference implementation of such signer is available in the SDK repository. You can use it as-is or customize it to meet your requirements: <a href="https://github.com/breez/breez-sdk-liquid/blob/main/lib/core/src/signer.rs#L198">SdkSigner</a>.<br>
Note that this same implementation is used internally by the SDK when connecting with a mnemonics via the standard `Connect` method.
</div>
