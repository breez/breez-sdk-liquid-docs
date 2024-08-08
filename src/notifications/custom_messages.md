# Customising push messages

The Notification Plugin by default handles a specific format of push notification message data sent by the NDS:
```json
{
    "notification_type": "swap_updated",
    "notification_payload": "{ \"id\": \"\", \"status\": \"\" }",
    "app_data": ""
}
```

If you want to customise the structure or field names of the push notification message data handled by the Notification Plugin, you can follow the code example below for adding these to iOS and Android. In these examples we replace the `notification_type` and `notification_payload` fields with `custom_type` and `custom_payload`.

<custom-tabs category="lang">
<div slot="title">Swift</div>
<section>
First you need to override the <code>getTaskFromNotification</code> function in the implementation of the <code>SDKNotificationService</code> class. Then from <code>content.userInfo</code> use the custom fields to get the notification type and payload:

```swift,ignore
class NotificationService: SDKNotificationService {
    // Override the `getTaskFromNotification` function 
    override func getTaskFromNotification() -> TaskProtocol? {
        guard let content = bestAttemptContent else { return nil }
        guard let notificationType = content.userInfo["custom_type"] as? String else { return nil }
        self.logger.log(tag: TAG, line: "Notification payload: \(content.userInfo)", level: "INFO")
        self.logger.log(tag: TAG, line: "Notification type: \(notificationType)", level: "INFO")
        
        guard let payload = content.userInfo["custom_payload"] as? String else {
            contentHandler!(content)
            return nil
        }
        
        self.logger.log(tag: TAG, line: "\(notificationType) data string: \(payload)", level: "INFO")
        switch(notificationType) {
        case Constants.MESSAGE_TYPE_SWAP_UPDATED:
            return SwapUpdatedTask(payload: payload, logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        case Constants.MESSAGE_TYPE_LNURL_PAY_INFO:
            return LnurlPayInfoTask(payload: payload, logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        case Constants.MESSAGE_TYPE_LNURL_PAY_INVOICE:
            return LnurlPayInvoiceTask(payload: payload, logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        default:
            return nil
        }
    }
}
```

</section>
<div slot="title">Kotlin</div>
<section>
First you need to change the <code>RemoteMessage.asMessage</code> function in the implementation of the <code>MessagingService</code> class. Then from <code>data</code> use the custom fields to get the notification type and payload:

```kotlin,ignore
class ExampleFcmService : MessagingService, FirebaseMessagingService() {
    // Change the `RemoteMessage.asMessage` function
    private fun RemoteMessage.asMessage(): Message? {
        return data["custom_type"]?.let {
            Message(data["custom_type"], data["custom_payload"])
        }
    }
}
```

</section>
</custom-tabs>
