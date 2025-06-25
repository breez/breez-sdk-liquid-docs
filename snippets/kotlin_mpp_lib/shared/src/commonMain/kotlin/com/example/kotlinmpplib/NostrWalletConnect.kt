package com.example.kotlinmpplib

import breez_sdk_liquid.*
class NWC{
  fun nostrWalletConnect() {
    // ANCHOR: init-nwc
    val config: Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")
    
    config.enableNwc = true

    // Optional: You can specify your own Relay URLs
    config.nwcRelayUrls = listOf("<your-relay-url-1>")
    // ANCHOR_END: init-nwc
    
    // ANCHOR: create-connection-string
    val nwcConnectionUri = sdk.getNwcUri()
    // ANCHOR_END: create-connection-string
  }
}