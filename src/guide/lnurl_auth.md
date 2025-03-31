<h1 id="lnurl-auth">
    <a class="header" href="#lnurl-auth">LNURL-Auth</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.lnurl_auth">API docs</a>
</h1>

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/lnurl_auth.rs:lnurl-auth}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/LnurlAuth.swift:lnurl-withdraw}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/LnurlAuth.kt:lnurl-auth}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/lnurl_auth.ts:lnurl-auth}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/lnurl_auth.ts:lnurl-auth}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/lnurl_auth.dart:lnurl-auth}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/lnurl_auth.py:lnurl-auth}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/lnurl_auth.go:lnurl-auth}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/LnurlAuth.cs:lnurl-auth}}
```
</section>
</custom-tabs>

## Supported Specs

- [LUD-01](https://github.com/lnurl/luds/blob/luds/01.md) LNURL bech32 encoding
- [LUD-04](https://github.com/lnurl/luds/blob/luds/04.md) `auth` base spec
- [LUD-17](https://github.com/lnurl/luds/blob/luds/17.md) Support for keyauth prefix with non-bech32-encoded LNURL URLs
