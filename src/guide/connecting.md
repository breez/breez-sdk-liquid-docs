<h1 id="connecting">
    <a class="header" href="#connecting">Connecting</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.connect">API docs</a>
</h1>

The first step is to construct the SDK configuration. Among others, it sets the network you want to use, the SDK working directory and the Breez API key.

The SDK uses the config `working_dir` to store the state of the SDK instance. When handling multiple instances of the SDK, each instance needs to have a different working directory defined.

<div class="warning">
<h4>Developer note</h4>

This does not apply to Javascript (Wasm) as the SDK state is stored in memory.

</div>

Now you are ready to interact with the SDK.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/getting_started.rs:init-sdk}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/GettingStarted.swift:init-sdk}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/GettingStarted.kt:init-sdk}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/getting_started.ts:init-sdk}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/getting_started.ts:init-sdk}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/getting_started.dart:init-sdk}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/getting_started.py:init-sdk}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/getting_started.go:init-sdk}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/GettingStarted.cs:init-sdk}}
```
</section>
</custom-tabs>

<div class="warning">
<h4>Developer note</h4>

By default, the config working directory is set to the directory where the SDK is running. Some platforms may require that you use an application specific directory that is writable within the application sandbox. For example applications running on Android or iOS.

</div>

<h2 id="disconnecting">
    <a class="header" href="#disconnecting">Disonnecting</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.disconnect">API docs</a>
</h2>

Once you are done using the SDK, you can call the `disconnect` method to free up the resources which are currently in use.

This is especially useful in cases where the SDK has to be re-instantiated, for example when you need to change the mnemonic and/or configuration.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/getting_started.rs:disconnect}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/GettingStarted.swift:disconnect}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/GettingStarted.kt:disconnect}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/getting_started.ts:disconnect}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/getting_started.ts:disconnect}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/getting_started.dart:disconnect}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/getting_started.py:disconnect}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/getting_started.go:disconnect}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/GettingStarted.cs:disconnect}}
```
</section>
</custom-tabs>
