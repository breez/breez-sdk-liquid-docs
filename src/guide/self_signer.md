# Using a Self Implemented Signer

By default, the SDK uses mnemonics to generate keys and sign transactions. However, you can also provide your own signer implementation if you want more control over key management and signing.

To use a custom signer, you'll need to:

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

<h4>Developer note</h4>
A reference implementation of a signer is available in the SDK repository that you can use as a starting point for implementing your own signer : <a href="https://github.com/breez/breez-sdk-liquid/blob/main/lib/core/src/signer.rs#L198">SdkSigner</a>.<br>
This same reference implementation is also used internally by the SDK when connecting with a mnemonic via the standard `Connect` method.

