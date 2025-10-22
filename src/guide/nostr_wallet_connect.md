# Nostr Wallet Connect

Nostr Wallet Connect (NWC) is a plugin integrated into the Breez SDK that enables remote wallet control through the Nostr protocol. This allows external applications to interact with your wallet by connecting via Nostr relays, providing a secure way to manage payments and wallet operations from third-party applications.

## Supported Commands

The NWC implementation currently handles three NIP-47 commands:

1. <a href="https://github.com/nostr-protocol/nips/blob/master/47.md#pay_invoice" target="_blank">pay_invoice</a> - Execute Lightning payments
2. <a href="https://github.com/nostr-protocol/nips/blob/master/47.md#list_transactions" target="_blank">list_transactions</a> - Retrieve transaction history
3. <a href="https://github.com/nostr-protocol/nips/blob/master/47.md#get_balance" target="_blank">get_balance</a> - Get wallet balance

## Setup and Configuration

The NWC plugin is configured using `NwcConfig`, which provides several optional parameters for customization:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:nwc-config}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:nwc-config}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:nwc-config}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:nwc-config}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:nwc-config}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:nwc-config}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:nwc-config}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:nwc-config}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:nwc-config}}
```

</section>
</custom-tabs>

### Configuration Options

1. **Relay URLs**

   An optional list of custom Nostr relay URLs to use for communication. By default uses relay: "wss://relay.getalbypro.com/breez". You can specify multiple relays for redundancy.

2. **Secret Key**

   An optional custom Nostr secret key in hex format. If not provided, a new key will be generated and persisted automatically. This is useful when you want to use a specific Nostr identity.

## Managing Connections

The NWC service allows you to create, list, and remove connection strings that external applications can use to connect to your wallet.

### Creating Connections

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:add-connection}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:add-connection}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:add-connection}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:add-connection}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:add-connection}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:add-connection}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:add-connection}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:add-connection}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:add-connection}}
```

</section>
</custom-tabs>

### Listing Connections

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:list-connections}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:list-connections}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:list-connections}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:list-connections}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:list-connections}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:list-connections}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:list-connections}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:list-connections}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:list-connections}}
```

</section>
</custom-tabs>

### Removing Connections

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:remove-connection}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:remove-connection}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:remove-connection}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:remove-connection}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:remove-connection}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:remove-connection}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:remove-connection}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:remove-connection}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:remove-connection}}
```

</section>
</custom-tabs>

## Event Handling

The NWC service provides real-time event notifications through an event listener. You can listen for various events to monitor the service status and handle incoming requests.

### Event Types

The NWC service emits the following event types:

1. **Connected**: NWC service connected to relays
2. **Disconnected**: NWC service disconnected from relays  
3. **PayInvoice**: Payment request handled (success/failure with details) - includes `success` (whether the payment was successful), `preimage` (payment preimage if successful), `fees_sat` (fees paid in satoshis if successful), and `error` (error message if failed)
4. **ListTransactions**: Transaction list requested
5. **GetBalance**: Balance requested

### Event Listener Implementation

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:event-listener}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:event-listener}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:event-listener}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:event-listener}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:event-listener}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:event-listener}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:event-listener}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:event-listener}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:event-listener}}
```

</section>
</custom-tabs>

### Adding and Removing Event Listeners

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:event-management}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:event-management}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:event-management}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:event-management}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:event-management}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:event-management}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:event-management}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:event-management}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:event-management}}
```

</section>
</custom-tabs>

## Error Handling

The NWC plugin may throw errors during operations. Common error types include:

1. **Generic**: General errors (parsing, network, etc.)
2. **Persist**: Data persistence errors

Always handle these errors appropriately in your application:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nostr_wallet_connect.rs:error-handling}}
```

</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NostrWalletConnect.swift:error-handling}}
```

</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/NostrWalletConnect.kt:error-handling}}
```

</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nostr_wallet_connect.ts:error-handling}}
```

</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nostr_wallet_connect.ts:error-handling}}
```

</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nostr_wallet_connect.dart:error-handling}}
```

</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/nostr_wallet_connect.py:error-handling}}
```

</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nostr_wallet_connect.go:error-handling}}
```

</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/NostrWalletConnect.cs:error-handling}}
```

</section>
</custom-tabs>