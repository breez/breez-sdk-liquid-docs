# Supporting fiat currencies

You can get the full details of supported fiat currencies, such as symbols and localized names:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/fiat_currencies.rs:list-fiat-currencies}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/FiatCurrencies.swift:list-fiat-currencies}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/FiatCurrencies.kt:list-fiat-currencies}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/fiat_currencies.ts:list-fiat-currencies}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/fiat_currencies.dart:list-fiat-currencies}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/FiatCurrencies.cs:list-fiat-currencies}}
```
</section>
</custom-tabs>

To get the current BTC rate in the various supported fiat currencies:

<custom-tabs category="lang">
<div slot="title">Rust</div>
<section>

```rust,ignore
{{#include ../../snippets/rust/src/fiat_currencies.rs:fetch-fiat-rates}}
```
</section>

<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/FiatCurrencies.swift:fetch-fiat-rates}}
```
</section>

<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
{{#include ../../snippets/kotlin_mpp_lib/shared/src/commonMain/kotlin/com/example/kotlinmpplib/FiatCurrencies.kt:fetch-fiat-rates}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/fiat_currencies.ts:fetch-fiat-rates}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/fiat_currencies.dart:fetch-fiat-rates}}
```
</section>

<div slot="title">C#</div>
<section>

```cs,ignore
{{#include ../../snippets/csharp/FiatCurrencies.cs:fetch-fiat-rates}}
```
</section>
</custom-tabs>
