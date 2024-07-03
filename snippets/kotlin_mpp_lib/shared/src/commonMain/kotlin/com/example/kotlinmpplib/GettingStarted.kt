package com.example.kotlinmpplib

import breez_liquid_sdk.*
class GettingStarted {
    fun start() {
        // ANCHOR: init-sdk
        // SDK events listener
        class SDKListener : EventListener {
            override fun onEvent(e: BreezEvent) {
                // Log.v("SDKListener", "Received event $e")
            }
        }

        // Select your seed, invite code and eviroment
        val seed = mnemonicToSeed("<mnemonic words>")
        val inviteCode = "<invite code>"
        val apiKey = "<api key>"

        // Create the default config
        val greenlightNodeConfig = GreenlightNodeConfig(null, inviteCode)
        val nodeConfig = NodeConfig.Greenlight(greenlightNodeConfig)
        val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConfig)

        // Customize the config object according to your needs
        config.workingDir = "path to an existing directory"

        try {
            // Connect to the Breez SDK make it ready for use
            val connectRequest = ConnectRequest(config, seed)
            val sdk = connect(connectRequest, SDKListener())
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: init-sdk
    }

    fun startRestoreOnly(config: Config, seed: List<UByte>) {
        class SDKListener : EventListener {
            override fun onEvent(e: BreezEvent) {}
        }

        try {
            // ANCHOR: init-sdk-restore-only
            val connectRequest = ConnectRequest(config, seed, true)
            val sdk = connect(connectRequest, SDKListener())
            // ANCHOR_END: init-sdk-restore-only
        } catch (e: Exception) {
            // handle error
        }
    }

    fun fetchBalance(sdk: BindingLiquidSdk) {
        // ANCHOR: fetch-balance
        try {
            val nodeInfo = sdk.nodeInfo()
            val lnBalance = nodeInfo?.channelsBalanceMsat
            val onchainBalance = nodeInfo?.onchainBalanceMsat
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: fetch-balance
    }

    fun logging() {
        // ANCHOR: logging
        class SDKLogStream : LogStream {
            override fun log(l: LogEntry) {
                // Log.v("SDKListener", "Received log [${l.level}]: ${l.line}")
            }
        }

        try {
            setLogStream(SDKLogStream())
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: logging
    }
}