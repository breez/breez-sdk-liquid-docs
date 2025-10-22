package com.example.kotlinmpplib

import breez_sdk_liquid.*
class NostrWalletConnect {
    suspend fun nostrWalletConnect() {
        // ANCHOR: nwc-config
        val nwcConfig = NwcConfig(
            relayUrls = listOf("<your-relay-url-1>"),         // Optional: Custom relay URLs (uses default if null)
            secretKeyHex = "your-nostr-secret-key-hex"        // Optional: Custom Nostr secret key
        )
        
        val nwcService = SdkNwcService(nwcConfig)
        
        // Add the plugin to your SDK
        val plugins: List<Plugin> = listOf(nwcService)
        // ANCHOR_END: nwc-config

        // ANCHOR: add-connection
        val connectionName = "my-app-connection"
        val connectionString = nwcService.addConnectionString(connectionName)
        // ANCHOR_END: add-connection

        // ANCHOR: list-connections
        val connections = nwcService.listConnectionStrings()
        // ANCHOR_END: list-connections

        // ANCHOR: remove-connection
        nwcService.removeConnectionString(connectionName)
        // ANCHOR_END: remove-connection

        // ANCHOR: event-listener
        class MyNwcEventListener : NwcEventListener {
            override suspend fun onEvent(event: NwcEvent) {
                when (event.details) {
                    is NwcEventDetails.Connected -> println("NWC connected")
                    is NwcEventDetails.Disconnected -> println("NWC disconnected")
                    is NwcEventDetails.PayInvoice -> {
                        val success = event.details.success
                        println("Payment ${if (success) "successful" else "failed"}")
                    }
                    is NwcEventDetails.ListTransactions -> println("Transactions requested")
                    is NwcEventDetails.GetBalance -> println("Balance requested")
                }
            }
        }
        // ANCHOR_END: event-listener

        // ANCHOR: event-management
        // Add event listener
        val listener = MyNwcEventListener()
        val listenerId = nwcService.addEventListener(listener)

        // Remove event listener when no longer needed
        nwcService.removeEventListener(listenerId)
        // ANCHOR_END: event-management

        // ANCHOR: error-handling
        try {
            val connectionString = nwcService.addConnectionString("test")
            println("Connection created: $connectionString")
        } catch (e: NwcError.Generic) {
            println("Generic error: ${e.message}")
        } catch (e: NwcError.Persist) {
            println("Persistence error: ${e.message}")
        }
        // ANCHOR_END: error-handling
    }
}