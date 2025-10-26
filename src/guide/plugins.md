# Plugins

The Breez SDK - Nodeless *(Liquid Implementation)* supports a plugin architecture that allows extending functionality through modular components.

## Connecting with Plugins

To use plugins with the Breez SDK, you need to initialize and pass them to the `connect` function.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/plugins.rs:create-plugin-config}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Plugins.swift:create-plugin-config}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Plugins.kt:create-plugin-config}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript,ignore
{{#include ../../snippets/wasm/plugins.ts:create-plugin-config}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript,ignore
{{#include ../../snippets/react-native/plugins.ts:create-plugin-config}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/plugins.dart:create-plugin-config}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/plugins.py:create-plugin-config}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/plugins.go:create-plugin-config}}
```

</section>

<div slot="title">C#</div>
<section>

```csharp,ignore
{{#include ../../snippets/csharp/Plugins.cs:create-plugin-config}}
```

</section>
</custom-tabs>

## Supported Plugins
To setup and configure the plugins refer to their specific pages mentioned below.

- [**Nostr Wallet Connect**](nostr_wallet_connect.md)

    Remote wallet control through the Nostr protocol.

## Create Your Own Plugin

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/plugins.rs:my-custom-plugin}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Plugins.swift:my-custom-plugin}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Plugins.kt:my-custom-plugin}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript,ignore
{{#include ../../snippets/wasm/plugins.ts:my-custom-plugin}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript,ignore
{{#include ../../snippets/react-native/plugins.ts:my-custom-plugin}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/plugins.dart:my-custom-plugin}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/plugins.py:my-custom-plugin}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/plugins.go:my-custom-plugin}}
```

</section>

<div slot="title">C#</div>
<section>

```csharp,ignore
{{#include ../../snippets/csharp/Plugins.cs:my-custom-plugin}}
```

</section>
</custom-tabs>