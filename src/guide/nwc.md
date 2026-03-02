# Nostr Wallet Connect

Nostr Wallet Connect allows you to control your Breez SDK instance from any Nostr application which complies with the NIP47 standard (for more information, see
<a target="_blank" href="https://github.com/nostr-protocol/nips/blob/master/47.md">here</a>).

## Enabling/Disabling

To enable the Nostr Wallet Connect service, you can call the `useNwcPlugin` method after connecting to the SDK.

The config takes three optional parameters:
- `relayUrls`: Custom list of relays for the NWC node to connect to
- `secretKeyHex`: Custom Nostr secret key to start the node with (hex-encoded)
- `listenToEvents`: Whether or not to actively listen and reply to events (defaults to true)

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:connecting}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:connecting}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:connecting}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:connecting}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:connecting}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:connecting}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:connecting}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:connecting}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:connecting}}
```
</section>
</custom-tabs>

## NWC Connections

In order to control the wallet, NWC applications require a _connection string_. These special URIs can be generated via the NWC service methods `addConnection`/`editConnection`/`removeConnection`, and listed with `listConnections`:

### Adding

When creating a connection, there are various configuration options, specifically:
- Expiry: Connections can either live indefinitely, or for a set number of minutes. When a connection expires it is lost **forever** (unrecoverable)
- Budget: Connections may have a budget, which means they only allow spending up to a certain amount before refusing to pay. This budget can be _periodic_, resetting after a set amount of time, or fixed, meaning the connection won't be able to send funds once the budget is reached
- Receive-only: Whether or not a connection should only be used for receiving

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:add-connection}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:add-connection}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:add-connection}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:add-connection}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:add-connection}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:add-connection}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:add-connection}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:add-connection}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:add-connection}}
```
</section>
</custom-tabs>

### Editing

Editing a connection is similar to adding, but with two extra fields:
- `removeExpiry`: Removes the expiry when set to true
- `removePeriodicBudget`: Removes the periodic budget when set to true

Setting any other field will update the corresponding connection's details if a connection with that name exists.

**Note**: Modifying a connection will reset both its budget and expiry timers!

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:edit-connection}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:edit-connection}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:edit-connection}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:edit-connection}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:edit-connection}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:edit-connection}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:edit-connection}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:edit-connection}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:edit-connection}}
```
</section>
</custom-tabs>

### Listing
Active connections can be listed using the `listConnections` method:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:list-connections}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:list-connections}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:list-connections}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:list-connections}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:list-connections}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:list-connections}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:list-connections}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:list-connections}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:list-connections}}
```
</section>
</custom-tabs>

### Removing

You can remove an active connection by using the `removeConnection` method:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:remove-connection}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:remove-connection}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:remove-connection}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:remove-connection}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:remove-connection}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:remove-connection}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:remove-connection}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:remove-connection}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:remove-connection}}
```
</section>
</custom-tabs>

## Service Information

Information about the NWC service (wallet Nostr pubkey, relays, etc.) can be retrieved via the `getInfo` method. If the service is not active, it will return null.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:get-info}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:get-info}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:get-info}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:get-info}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:get-info}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:get-info}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:get-info}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:get-info}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:get-info}}
```
</section>
</custom-tabs>

## Event Listeners

You can listen to events from the NWC service just like you would with the SDK (see [Listening to events](events.md)).
The service supports the `add/removeEventListener` methods:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:events}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:events}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:events}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:events}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:events}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:events}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:events}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:events}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:events}}
```
</section>
</custom-tabs>

## Payments

You can retrieve SDK payments associated with a specific NWC connection by using the `listConnectionPayments` method:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/nwc.rs:payments}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/Nwc.swift:payments}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/Nwc.kt:payments}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/nwc.ts:payments}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/nwc.ts:payments}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/nwc.dart:payments}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore
{{#include ../../snippets/python/src/nwc.py:payments}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/nwc.go:payments}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/Nwc.cs:payments}}
```
</section>
</custom-tabs>
