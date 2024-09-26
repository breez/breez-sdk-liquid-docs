package com.example.kotlinmpplib

import breez_sdk_liquid.*
class GettingStarted {
    fun start() {
        // ANCHOR: init-sdk
        val mnemonic = "<mnemonic words>"

        // Create the default config
        val config : Config = defaultConfig(LiquidNetwork.MAINNET)

        // Customize the config object according to your needs
        config.workingDir = "path to an existing directory"

	    // Add your Breez API key
	    config.breezApiKey = "<your Breez API key>"

        try {
            val connectRequest = ConnectRequest(config, mnemonic)
            val sdk = connect(connectRequest)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: init-sdk
    }

    fun fetchBalance(sdk: BindingLiquidSdk) {
        // ANCHOR: fetch-balance
        try {
            val walletInfo = sdk.getInfo()
            val balanceSat = walletInfo?.balanceSat
            val pendingSendSat = walletInfo?.pendingSendSat
            val pendingReceiveSat = walletInfo?.pendingReceiveSat
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: fetch-balance
    }

    // ANCHOR: logging
    class SDKLogger : Logger {
        override fun log(l: LogEntry) {
            // Log.v("SDKListener", "Received log [${l.level}]: ${l.line}")
        }
    }

    fun setLogger(logger: SDKLogger) {
        try {
            setLogger(logger)
        } catch (e: Exception) {
            // handle error
        }
    }
    // ANCHOR_END: logging

    // ANCHOR: add-event-listener
    class SDKListener : EventListener {
        override fun onEvent(e: SdkEvent) {
            // Log.v("SDKListener", "Received event $e")
        }
    }

    fun addEventListener(sdk: BindingLiquidSdk, listener: SDKListener): String? {
        try {
            val listenerId = sdk.addEventListener(listener)
            return listenerId
        } catch (e: Exception) {
            // handle error
            return null
        }
    }
    // ANCHOR_END: add-event-listener

    // ANCHOR: remove-event-listener
    fun removeEventListener(sdk: BindingLiquidSdk, listenerId: String)  {
        try {
            sdk.removeEventListener(listenerId)
        } catch (e: Exception) {
            // handle error
        }
    }
    // ANCHOR_END: remove-event-listener
}
