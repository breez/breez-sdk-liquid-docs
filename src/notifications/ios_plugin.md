# Adding the Notification Plugin

Add the `BreezSDKLiquid` cocoapod to your iOS Podfile, with the target `NotificationService`. You can add any other dependencies your require here also, for example `KeychainAccess` to read the saved mnemonic from the keychain.

```podfile
target 'NotificationService' do
  pod 'BreezSDKLiquid'
  pod 'KeychainAccess'
end
```

Once added to the Podfile, run `pod install` to install the dependencies.

More installation methods, including with the Swift Package Manager, can be found in the [breez-sdk-liquid-swift](https://github.com/breez/breez-sdk-liquid-swift/blob/main/README.md) repository.

## Integrate the Notification Plugin

You're ready to add some Swift code to implement the Notification Plugin in your NotificationService target. In Xcode, in the `NotificationService` folder, open the Swift file named `NotificationService.swift`.

This Swift file should implement the Notification Plugin's `SDKNotificationService` class. The `SDKNotificationService` class handles the incoming notification content and processes the event. To properly implement this class the NotificationService needs to override at least the `getConnectRequest` function. The `getConnectRequest` function is called by the `SDKNotificationService` to get a `ConnectRequest` which contains the data necessary to connect to the SDK. This data includes the `Config` with it's `workingDir` and the mnemonic.

<div class="warning">
<h4>Developer note</h4>
When using the Notification Plugin in iOS, it is important to note that the <code>Config</code> <code>workingDir</code> needs to be set to the app group's shared directory in both the <code>NotificationService</code> target and in the main application target, whether that is a Swift, Flutter or React Native based application.
</div>
<div class="warning">
<h4>Developer note</h4>
When accessing the Keychain using the Keychain Group, the <code>AppIdentifierPrefix</code> needs to be prepended to the configured identifier, like <code>&lt;TEAM_ID&gt;.com.example.SharedKeychain</code>. This Keychain Group needs to be used in the main application target as the accessGroup when you want to store anything on the keychain that later needs to be accessed by the notification service.
</div>

```swift
import UserNotifications
import KeychainAccess
import BreezSDKLiquid

fileprivate let logger = OSLog(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "NotificationService"
)

fileprivate let appGroup = "group.com.example.application"
fileprivate let keychainGroup = "A352BFE4OR.com.example.SharedKeychain"
fileprivate let accountMnemonic: String = "BREEZ_SDK_LIQUID_SEED_MNEMONIC"

class NotificationService: SDKNotificationService {
    // Override the `getConnectRequest` function
    override func getConnectRequest() -> ConnectRequest? {
        var config = defaultConfig(network: LiquidNetwork.mainnet)
        // Set the workingDir as the app group's shared directory,
        // this should be the same directory as the main application uses
        config.workingDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
            .appendingPathComponent("breezSdkLiquid", isDirectory: true)
            .path

        // Get the mnemonic from the shared keychain using the same 
        // service name as the main application
        let service = Bundle.main.bundleIdentifier!.replacingOccurrences(of: ".NotificationService", with: "")
        let keychain = Keychain(service: service, accessGroup: keychainGroup)
        guard let mnemonic = try? keychain.getString(accountMnemonic) else {
            os_log(.error, "Mnemonic not found")
            return nil
        }
        return ConnectRequest(config: config, mnemonic: mnemonic)
    }
}
```

## Reference implementation
For a complete reference, see how we implemented it in misty-breez wallet: [NotificationService.swift](https://github.com/breez/misty-breez/blob/main/ios/Breez%20Notification%20Service%20Extension/NotificationService.swift).