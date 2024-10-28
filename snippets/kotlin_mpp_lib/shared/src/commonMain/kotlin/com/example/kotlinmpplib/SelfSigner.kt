package com.example.kotlinmpplib

import breez_sdk_liquid.*
class SelfSigner {
   // ANCHOR: self-signer
    fun connectWithSelfSigner(signer: Signer) {               

        // Create the default config, providing your Breez API key
        val config : Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")

        // Customize the config object according to your needs
        config.workingDir = "path to an existing directory"

        try {
            val connectRequest = ConnectWithSignerRequest(config)
            val sdk = connectWithSigner(connectRequest, signer)
        } catch (e: Exception) {
            // handle error
        }
    }
     // ANCHOR_END: self-signer
  }