# Adding the Notification Plugin

Add the `breez-sdk-liquid` dependency to your application's `build.gradle` file in the `app` directory.

```gradle
android {
    // This might help building if duplicate libraries are found
    packagingOptions {
        pickFirst "lib/armeabi-v7a/libc++_shared.so"
        pickFirst "lib/arm64-v8a/libc++_shared.so"
        pickFirst "lib/x86/libc++_shared.so"
        pickFirst "lib/x86_64/libc++_shared.so"
        exclude "META-INF/*"
    }
}

dependencies {
    // Add the breez-sdk dependency
    implementation "com.github.breez:breez-sdk-liquid"
}
```

## Integrate the Notification Plugin

You're ready to add some Kotlin code to implement the Notification Plugin in your application. In the example below, we are using the `FirebaseMessagingService` to receive the message intents. First, let's implement the Notification Plugin's `MessagingService` class along with `FirebaseMessagingService`. 

```kotlin
package com.example.application

import android.annotation.SuppressLint
import android.content.Intent
import androidx.core.content.ContextCompat
import breez_sdk_liquid_notification.Constants
import breez_sdk_liquid_notification.Message
import breez_sdk_liquid_notification.MessagingService
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

@SuppressLint("MissingFirebaseInstanceTokenRefresh")
class ExampleFcmService : MessagingService, FirebaseMessagingService() {
    companion object {
        private const val TAG = "FcmService"
    }

    // Override the `onMessageReceived` to handle the remote message
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        // Check if the message is high priority and can be handled
        if (remoteMessage.priority == RemoteMessage.PRIORITY_HIGH) {
            remoteMessage.asMessage()?.also { message -> 
                // Call `startServiceIfNeeded` to check if the foreground
                // service is needed depending on the message type and 
                // foreground state of the application
                startServiceIfNeeded(applicationContext, message)
            }
        }
    }

    // A helper function the convert the `RemoteMessage` 
    // to a notification plugin 'Message'
    private fun RemoteMessage.asMessage(): Message? {
        return data[Constants.MESSAGE_DATA_TYPE]?.let {
            Message(
                data[Constants.MESSAGE_DATA_TYPE], data[Constants.MESSAGE_DATA_PAYLOAD]
            )
        }
    }

    // Override the `startForegroundService` function to start the foreground service
    // using the `ExampleForegroundService` handler
    override fun startForegroundService(message: Message) {
        val intent = Intent(applicationContext, ExampleForegroundService::class.java)
        intent.putExtra(Constants.EXTRA_REMOTE_MESSAGE, message)
        ContextCompat.startForegroundService(applicationContext, intent)
    }
}
```

Now lets add the foreground service implementation. This should implement the notification plugin `ForegroundService` class, which handles the incoming notification intent and processes the event. To properly implement this, your class needs to override the `onCreate`, `getConnectRequest` and `getServiceConfig` functions. The `getConnectRequest` function is called by the `ForegroundService` to get a `ConnectRequest` which contains the data necessary to connect to the SDK. This data includes the `Config` with it's `workingDir` and the mnemonic.

<div class="warning">
<h4>Developer note</h4>
In Android reading from secured storage can vary a lot depending if it is a Kotlin, Flutter or React Native based application and the dependencies used to write to the secured storage. Consult the dependency used to write to the secured storage on how to read data back from them.
</div>

```kotlin
package com.example.application

import breez_sdk_liquid.ConnectRequest
import breez_sdk_liquid.defaultConfig
import breez_sdk_liquid.LiquidNetwork
import breez_sdk_liquid_notification.ForegroundService
import breez_sdk_liquid_notification.NotificationHelper.Companion.registerNotificationChannels

class ExampleForegroundService : ForegroundService() {
    companion object {
        private const val TAG = "ForegroundService"
        private const val ACCOUNT_MNEMONIC = "BREEZ_SDK_LIQUID_SEED_MNEMONIC"
    }

    // Override the `onCreate` function
    override fun onCreate() {
        super.onCreate()
        // Register the default notification channels
        registerNotificationChannels(applicationContext)
    }

    // Override the `getConnectRequest` function
    override fun getConnectRequest(): ConnectRequest? {
        val config = defaultConfig(LiquidNetwork.MAINNET)

        // Set the workingDir as the same directory as the main application
        config.workingDir = "${applicationContext.filesDir}/breezSdkLiquid"

        // Get the mnemonic from secured storage using an implementation of
        // `readSecuredValue` depending on how data is written to secured storage.
        // See Developer Note
        return readSecuredValue(applicationContext, ACCOUNT_MNEMONIC)
            ?.let { mnemonic ->
                ConnectRequest(config, mnemonic)
            }
    }
}
```

## Reference implementation
For a complete reference, see how we implemented it in misty-breez wallet: [BreezFcmService.kt](https://github.com/breez/misty-breez/blob/main/android/app/src/main/kotlin/com/breez/liquid/l_breez/BreezFcmService.kt).