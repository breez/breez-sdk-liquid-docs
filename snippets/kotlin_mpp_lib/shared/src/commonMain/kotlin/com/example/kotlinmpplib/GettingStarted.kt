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
            val nodeState = sdk.getInfo()
            val balanceSat = nodeState?.balanceSat
            val pendingSendSat = nodeState?.pendingSendSat
            val pendingReceiveSat = nodeState?.pendingReceiveSat
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: fetch-balance
    }
}