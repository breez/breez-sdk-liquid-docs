# Handling custom notifications

You can customise the Notification Plugin even further by handling your own notification types sent to the application via push notification. Follow the code example below for adding these to iOS and Android.

<custom-tabs category="lang">
<div slot="title">Swift</div>
<section>
First you need to override the <code>getTaskFromNotification</code> function in the implementation of the <code>SDKNotificationService</code> class.

```swift,ignore
class NotificationService: SDKNotificationService {
    // Override the `getTaskFromNotification` function 
    override func getTaskFromNotification() -> TaskProtocol? { 
        if let task = super.getTaskFromNotification() {
            // Return the task if it can already be handled by the notification plugin
            return task
        }

        guard let content = bestAttemptContent else { return nil }
        guard let notificationType = content.userInfo[Constants.MESSAGE_DATA_TYPE] as? String else { return nil }
        guard let payload = content.userInfo[Constants.MESSAGE_DATA_PAYLOAD] as? String else { return nil }
        
        switch(notificationType) {
        case "custom_type":
            return CustomTask(payload: payload, logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        default:
            return nil
        }
    }
}
```

</section>
<div slot="title">Kotlin</div>
<section>
First you need to override the <code>getJobFromIntent</code> function in the implementation of the <code>ForegroundService</code> class.

```kotlin,ignore
package com.example.application

import android.app.NotificationManager
import android.content.Intent
import breez_sdk_notification.ForegroundService
import breez_sdk_notification.job.Job
import breez_sdk_notification.Message
import breez_sdk_notification.NotificationHelper.Companion.createNotificationChannel
import breez_sdk_notification.NotificationHelper.Companion.createNotificationChannelGroup
import breez_sdk_notification.NotificationHelper.Companion.registerNotificationChannels

class ExampleForegroundService : ForegroundService() {
    // Override the `onCreate` function and register custom notification channels if needed
    override fun onCreate() {
        super.onCreate()
        // First register the default notification channels
        registerNotificationChannels(applicationContext, DEFAULT_CLICK_ACTION)
        // Then register any additional notification channels
        createNotificationChannelGroup(
            applicationContext, 
            "custom_job_group", 
            "Custom Job Group", 
            "Required to handle custom job requests when the application is in the background"
        )
        createNotificationChannel(
            applicationContext, 
            "CUSTOM_JOB", 
            "Custom Job", 
            "Notifications for custom job when the application is in the background",
            "custom_job_group",
            NotificationManager.IMPORTANCE_DEFAULT
        )
    }

    // Override the `getJobFromIntent` function 
    override fun getJobFromIntent(intent: Intent?): Job? {
        return super.getJobFromIntent(intent) ?: run {
            // If the job cannot be handled by the notification plugin
            Message.createFromIntent(intent)?.let { message ->
                message.payload?.let { payload ->
                    when (message.type) {
                        "custom_type" -> CustomJob(
                            applicationContext,
                            this,
                            payload,
                            logger
                        )

                        else -> null
                    }
                }
            }
        }
    }
}
```

</section>
</custom-tabs>

Then add a class that encapsulates the handling of the custom push notification type.

<custom-tabs category="lang">
<div slot="title">Swift</div>
<section>

```swift,ignore
import UserNotifications
import Foundation

// Use a codeable struct to decode the notification payload
struct CustomRequest: Codable {
}

class CustomTask : TaskProtocol {
    fileprivate let TAG = "CustomTask"
    
    internal var payload: String
    internal var contentHandler: ((UNNotificationContent) -> Void)?
    internal var bestAttemptContent: UNMutableNotificationContent?
    internal var logger: ServiceLogger
    internal var receivedPayment: Payment? = nil
    
    init(payload: String, logger: ServiceLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.payload = payload
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
    }
        
    // The `start` function is called once the SDK instance is connected
    func start(liquidSDK: BindingLiquidSdk) throws {
        // Decode the `CustomRequest` from the payload
        var customRequest: CustomRequest? = nil
        do {
            customRequest = try JSONDecoder().decode(CustomRequest.self, from: self.payload.data(using: .utf8)!)
        } catch let e {
            self.logger.log(tag: TAG, line: "failed to decode payload: \(e)", level: "ERROR")
            self.onShutdown()
            throw e
        }

        // Do something with the SDK, then once finished call 'displayPushNotification' with a success 
        // or failure message. The 'onShutdown' function can also be called to show the failure message
        do {
            self.displayPushNotification(title: "Success", logger: self.logger)
        } catch let e {
            self.logger.log(tag: TAG, line: "Failed to process notification: \(e)", level: "ERROR")
            self.onShutdown()
        }
    }

    // Use the `onEvent` function to handle events from the Breez SDK 
    // that can be used in your task
    public func onEvent(e: SdkEvent) {}

    // The 'onShutdown' function can be called when the notification service extension is about to be 
    // shutdown by the OS, here you can cleanup and display the failed push notification message
    func onShutdown() {
        self.displayPushNotification(title: "Failed", logger: self.logger)
    }
}
```

</section>
<div slot="title">Kotlin</div>
<section>

```kotlin,ignore
package com.example.application

import android.content.Context
import breez_sdk.BindingLiquidSdk
import breez_sdk.SdkEvent
import breez_sdk_notification.NotificationHelper.Companion.notifyChannel
import breez_sdk_notification.SdkForegroundService
import breez_sdk_notification.ServiceLogger
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

// Use a `Serializable` data class to decode the notification payload
@Serializable
data class CustomRequest(
)

class CustomJob(
    private val context: Context,
    private val fgService: SdkForegroundService,
    private val payload: String,
    private val logger: ServiceLogger,
) : Job {
    companion object {
        private const val TAG = "CustomJob"
    }

    // The `start` function is called once the SDK instance is connected
    override fun start(liquidSDK: BindingLiquidSdk) {
        // Remember if you are using a custom notification channel, you have to register it first
        val notificationChannel = "CUSTOM_JOB"
        try {
            // Decode the `CustomRequest` from the payload
            val request = Json.decodeFromString(CustomRequest.serializer(), payload)
            // Do something with the SDK. Once finished call 'notifyChannel' 
            // with a success or failure message
            notifyChannel(
                context,
                notificationChannel,
                "Success",
            )
        } catch (e: Exception) {
            logger.log(TAG, "Failed to process notification: ${e.message}", "WARN")
            notifyChannel(
                context,
                notificationChannel,
                "Failed",
            )
        }

        // Tell the foreground service the job is finished
        fgService.onFinished(this)
    }

    // Use the `onEvent` function to handle events from the Breez SDK 
    // that can be used in your task
    override fun onEvent(e: SdkEvent) {}

    // The `onShutdown` function is called when the service timeout is reached
    // and the job should cleanup before shutting down
    override fun onShutdown() {}
}
```

</section>
</custom-tabs>

