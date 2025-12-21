package com.example.kotlinmpplib

import breez_sdk_liquid.*

fun createNwcConfig(): NwcConfig {
    return NwcConfig(
        relayUrls = listOf("<your-relay-url-1>"),
        secretKeyHex = null
    )
}

fun createSdkConfig(): Config {
    val config = defaultConfig(LiquidNetwork.TESTNET, null)
    config.workingDir = "path to an existing directory"
    return config
}

fun createConnectRequest(config: Config): ConnectRequest {
    return ConnectRequest(config, "<your-mnemonic-here>")
}

suspend fun connectWithNwcPlugin(): BindingLiquidSdk {
    //ANCHOR: create-plugin-config
    // Create Plugin Config
    val nwcConfig = createNwcConfig()

    // Initialize Plugin
    val nwcService = BindingNwcService(nwcConfig)
    
    // Create SDK Config
    val config = createSdkConfig()
    val plugins = listOf<Plugin>(nwcService)
    
    // Create Connect Request
    val connectRequest = createConnectRequest(config)
    
    // Connect to the SDK with the plugins
    val sdk = connect(connectRequest, plugins)
    //ANCHOR_END: create-plugin-config
    return sdk
}

//ANCHOR: my-custom-plugin
class MyPlugin : Plugin {
    override fun id(): String {
        // Return the unique identifier for your plugin
        return "my-custom-plugin"
    }

    override fun onStart(sdk: BindingLiquidSdk, storage: PluginStorage) {
        // Initialize your plugin here
    }

    override fun onStop() {
        // Cleanup your plugin here
    }
}
//ANCHOR_END: my-custom-plugin