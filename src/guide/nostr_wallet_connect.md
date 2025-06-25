# Nostr Wallet Connect

This is integrated to Breez SDK as an optional boolean flag inside `Config` Struct. This feature can only be enabled at the time of SDK Initialization. By default it is set to `false`.
### To Enable it -

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:init-nwc}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:init-nwc}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:init-nwc}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:init-nwc}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:init-nwc}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:init-nwc}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:init-nwc}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:init-nwc}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:init-nwc}}
```
</section>
</custom-tabs>

Enabling this while configuring SDK starts NWC Services when SDK is started.
### To get NWC Connection URI -

You just need to call `get_nwc_uri()` from `Liquid SDK` instance which will return your String.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:create-connection-string}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:create-connection-string}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:create-connection-string}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:create-connection-string}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:create-connection-string}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:create-connection-string}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:create-connection-string}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:create-connection-string}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:create-connection-string}}
```
</section>
</custom-tabs>

Current NWC Implementation handles three commands -
1. <a target="_blank" href="https://github.com/nostr-protocol/nips/blob/master/47.md#pay_invoice">pay_invoice</a>
2. <a target="_blank" href="https://github.com/nostr-protocol/nips/blob/master/47.md#list_transactions">list_transactions</a>
3. <a target="_blank" href="https://github.com/nostr-protocol/nips/blob/master/47.md#get_balance">get_balance</a>