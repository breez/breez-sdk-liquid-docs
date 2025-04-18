<h1 id="rescanning-swaps">
    <a class="header" href="#rescanning-swaps">Rescanning swaps</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.rescan_onchain_swaps">API docs</a>
</h1>

The SDK continuously monitors any ongoing swap transactions until they are either completed or refunded. Once one of these outcomes occurs, the SDK ceases its monitoring activities, and users are advised against sending additional funds to the swap address. 

However, if users inadvertently send additional funds to a swap address that was already used, the SDK won't automatically recognize it. In such cases, the SDK provides an option to manually scan the used swap addressed to identify additional transactions. This action allows the address to be included in the list eligible for refunds, enabling the initiation of a refund process. For the purpose of rescanning all historical swap addresses and updating their on-chain status, the following code can be used:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/receive_onchain.rs:rescan-swaps}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ReceiveOnchain.swift:rescan-swaps}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ReceiveOnchain.kt:rescan-swaps}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/receive_onchain.ts:rescan-swaps}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/receive_onchain.ts:rescan-swaps}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/receive_onchain.dart:rescan-swaps}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/receive_onchain.py:rescan-swaps}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/receive_onchain.go:rescan-swaps}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ReceiveOnchain.cs:rescan-swaps}}
```
</section>
</custom-tabs>

