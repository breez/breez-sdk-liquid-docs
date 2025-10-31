import BreezSDKLiquid
import Foundation

// ANCHOR: init-sdk-app-group
import KeychainAccess

fileprivate let SERVICE = "com.example.application"
fileprivate let APP_GROUP = "group.com.example.application"
fileprivate let MNEMONIC_KEY = "BREEZ_SDK_LIQUID_SEED_MNEMONIC"

func initSdk() throws -> BindingLiquidSdk? {
    // Read the mnemonic from secure storage using the app group
    let keychain = Keychain(service: SERVICE, accessGroup: APP_GROUP)
    guard let mnemonic = try? keychain.getString(MNEMONIC_KEY) else {
        return nil
    }

    // Create the default config, providing your Breez API key
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Set the working directory to the app group path
    config.workingDir = FileManager
        .default.containerURL(forSecurityApplicationGroupIdentifier: APP_GROUP)!
        .appendingPathComponent("breezSdkLiquid", isDirectory: true)
        .path

    let connectRequest = ConnectRequest(config: config, mnemonic: mnemonic)
    let sdk = try? connect(req: connectRequest, plugins: nil)

    return sdk
}
// ANCHOR_END: init-sdk-app-group
