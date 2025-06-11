# Configuring the main application

Once you've integrated the Notification Plugin into your NotificationService target, you need to update the main application to use the same configuration as the Notification Plugin. As the application is now using a shared application group identifier for both the main and NotificationService targets, we need to use the app group when accessing the keychain and to configure a shared working directory for the SDK.

**Note:** The mnemonic should also be stored to the same app group.

<custom-tabs category="lang">
<div slot="title">Swift</div>
<section>

```swift,ignore
{{#include ../../snippets/swift/BreezSDKExamples/Sources/NotificationPlugin.swift:init-sdk-app-group}}
```
</section>

<div slot="title">React Native</div>
<section>

```typescript
{{#include ../../snippets/react-native/notification_plugin.ts:init-sdk-app-group}}
```
</section>

<div slot="title">Dart</div>
<section>

```dart,ignore
{{#include ../../snippets/dart_snippets/lib/notification_plugin.dart:init-sdk-app-group}}
```
</section>
</custom-tabs>

## Reference implementation
For a complete reference, see how we implemented it in Misty Breez: [Config.dart](https://github.com/breez/misty-breez/blob/main/packages/breez_sdk_liquid/lib/src/model/config.dart).