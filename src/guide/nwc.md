# Nostr Wallet Connect

Nostr Wallet Connect allows you to control your Breez SDK instance from any Nostr application which complies with the <a target="_blank" href="https://github.com/nostr-protocol/nips/blob/master/47.md">NIP47 standard</a>.

## Enabling/Disabling

To enable the Nostr Wallet Connect service, you can initialize it as a plugin after connecting to the SDK.

The config takes three optional parameters:
- **Relay URLs**: Custom list of relays for the NWC node to connect to
- **Secret key**: Custom Nostr secret key (hex-encoded) to start the node with 
- **Listen to events**: Whether or not to actively listen and reply to events (defaults to true). Can be set to false when only event broadcasting is required (e.g. zap replies).

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

## Getting service information

You can retrieve information about the NWC service (wallet pubkey, relays, etc.) as follows:

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

## Using event listeners

You can listen to events from the NWC service just like you would with the SDK (see [Listening to events](events.md)).

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

## Listing connection payments

You can list payments for each NWC connection as follows:

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

## NWC Connections

To communicate with the SDK, the _connection string_ must be shared with the NWC application. These special URIs can be generated by calling the service methods described below:

### Adding a connection

When creating a connection, there are various configuration options, specifically:
- **Expiry**: Connections can either live indefinitely, or for a set number of minutes. When a connection expires, you won't be able to use it through its associated NWC apps
- **Budget**: Connections may have a budget, which means they only allow spending within a certain amount before refusing to pay. This budget can be _periodic_, thus making it reset after a set amount of time, or fixed, meaning the connection won't be able to send funds after the budget is reached
- **Receive-only**: Whether or not a connection should only be used for receiving

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

### Editing a connection

Editing a connection is similar to adding, but with two extra fields:
- **Remove expiry**: Removes the expiry when set to true
- **Remove budget**: Removes the periodic budget when set to true

Setting any other field will update the corresponding connection's details if a connection with that name exists.

**Note**: Modifying a connection will reset both its budget and expiry timers

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

### Listing connections

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

### Removing a connection

**Note**: Removing a connection will make it so you won't be able to use it with the apps which were previously associated with it.

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
