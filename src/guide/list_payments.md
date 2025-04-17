<h1 id="listing-payments">
    <a class="header" href="#listing-payments">Listing payments</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.list_payments">API docs</a>
</h1>

To view your payment history you can list all the sent and received payments made.

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/list_payments.rs:list-payments}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ListPayments.swift:list-payments}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ListPayments.kt:list-payments}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/list_payments.ts:list-payments}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/list_payments.ts:list-payments}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/list_payments.dart:list-payments}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/list_payments.py:list-payments}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/list_payments.go:list-payments}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ListPayments.cs:list-payments}}
```
</section>
</custom-tabs>

## Filtering Payments

When listing payment you can also filter and page the list results, by:
### Type and timestamp

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/list_payments.rs:list-payments-filtered}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ListPayments.swift:list-payments-filtered}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ListPayments.kt:list-payments-filtered}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/list_payments.ts:list-payments-filtered}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/list_payments.ts:list-payments-filtered}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/list_payments.dart:list-payments-filtered}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/list_payments.py:list-payments-filtered}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/list_payments.go:list-payments-filtered}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ListPayments.cs:list-payments-filtered}}
```
</section>
</custom-tabs>

### Bitcoin address

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/list_payments.rs:list-payments-details-address}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ListPayments.swift:list-payments-details-address}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ListPayments.kt:list-payments-details-address}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/list_payments.ts:list-payments-details-address}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/list_payments.ts:list-payments-details-address}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/list_payments.dart:list-payments-details-address}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/list_payments.py:list-payments-details-address}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/list_payments.go:list-payments-details-address}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ListPayments.cs:list-payments-details-address}}
```
</section>
</custom-tabs>

### Liquid destination

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/list_payments.rs:list-payments-details-destination}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ListPayments.swift:list-payments-details-destination}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ListPayments.kt:list-payments-details-destination}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/list_payments.ts:list-payments-details-destination}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/list_payments.ts:list-payments-details-destination}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/list_payments.dart:list-payments-details-destination}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/list_payments.py:list-payments-details-destination}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/list_payments.go:list-payments-details-destination}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ListPayments.cs:list-payments-details-destination}}
```
</section>
</custom-tabs>

<h2 id="get-payment">
    <a class="header" href="#get-payment">Get Payment</a>
    <a class="tag" target="_blank" href="https://breez.github.io/breez-sdk-liquid/breez_sdk_liquid/sdk/struct.LiquidSdk.html#method.get_payment">API docs</a>
</h2>

You can also retrieve a single Lightning payment using one of the following identifier kinds:

* Lightning payment hash
* Swap ID or its SHA256 hash

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/list_payments.rs:get-payment}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/ListPayments.swift:get-payment}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/ListPayments.kt:get-payment}}
```
</section>

<div slot="title">Javascript</div>
<section>

```typescript
{{#include ../../snippets/wasm/list_payments.ts:get-payment}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/list_payments.ts:get-payment}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/list_payments.dart:get-payment}}
```
</section>

<div slot="title">Python</div>
<section>

```python,ignore 
{{#include ../../snippets/python/src/list_payments.py:get-payment}}
```
</section>

<div slot="title">Go</div>
<section>

```go,ignore
{{#include ../../snippets/go/list_payments.go:get-payment}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/ListPayments.cs:get-payment}}
```
</section>
</custom-tabs>
