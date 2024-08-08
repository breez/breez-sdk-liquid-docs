# Integrating the plugin

The Notification Plugin is designed to be used when the application isn't running. For this to be achieved reliably and to ensure that the notification is processed, specific implementations are required for both Android and iOS platforms to handle the incoming push notifications.

* For [Android](android_setup.md), the application requires a Foreground Service to handle the notification intent.

* For [iOS](ios_setup.md), the application requires a Notification Service Extension to handle the notification request.
