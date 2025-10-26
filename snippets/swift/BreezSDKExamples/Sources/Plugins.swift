import BreezSDKLiquid

func createNwcConfig() -> NwcConfig {
    return NwcConfig(
        relayUrls: ["<your-relay-url-1>"],
        secretKeyHex: nil
    )
}

func createSdkConfig() throws -> Config {
    var config = try defaultConfig(network: LiquidNetwork.testnet, breezApiKey: nil)
    config.workingDir = "path to an existing directory"
    return config
}

func createConnectRequest(config: Config) -> ConnectRequest {
    return ConnectRequest(
        config: config,
        mnemonic: "<your-mnemonic-here>"
    )
}

func connectWithNwcPlugin() throws -> BindingLiquidSdk {
    //ANCHOR: create-plugin-config
    // Create Plugin Config
    let nwcConfig = createNwcConfig()

    // Initialize Plugin
    let nwcService = BindingNwcService(config: nwcConfig)
    
    // Create SDK Config
    let config = try createSdkConfig()
    let plugins: [Plugin] = [nwcService]
    
    // Create Connect Request
    let connectRequest = createConnectRequest(config: config)
    
    // Connect to the SDK with the plugins
    let sdk = try connect(req: connectRequest, plugins: plugins)
    //ANCHOR_END: create-plugin-config
    return sdk
}

//ANCHOR: my-custom-plugin
class MyPlugin: Plugin {
    func id() -> String {
        // Return the unique identifier for your plugin
        return "my-custom-plugin"
    }

    func onStart(sdk: BindingLiquidSdk, storage: PluginStorage) {
        // Initialize your plugin here
    }

    func onStop() {
        // Cleanup your plugin here
    }
}
//ANCHOR_END: my-custom-plugin