package com.example.kotlinmpplib

import breez_sdk_liquid.*
import breez_sdk_liquid_nwc.*

class Nwc {
    fun nwcConnect(sdk: BindingLiquidSdk) {
        // ANCHOR: connecting
        val nwcConfig = NwcConfig(
            relayUrls = null,
            secretKeyHex = null,
            listenToEvents = null
        )
        val nwcService = try {
            sdk.useNwcPlugin(config = nwcConfig)
        } catch (e: Exception) {
            // handle error
            return
        }

        // ...

        // Automatically stops the plugin
        try { sdk.disconnect() } catch (e: Exception) { }
        // Alternatively, you can stop the plugin manually, without disconnecting the SDK
        nwcService.stop()
        // ANCHOR_END: connecting
    }

    fun nwcAddConnection(nwcService: SdkNwcService) {
        // ANCHOR: add-connection
        // This connection will only allow spending at most 10,000 sats/hour
        val periodicBudgetReq = PeriodicBudgetRequest(
            maxBudgetSat = 10000UL,
            renewalTimeMins = 60U  // Renews every hour
        )
        try {
            val addResponse = nwcService.addConnection(AddConnectionRequest(
                name = "my new connection",
                expiryTimeMins = 60U,  // Expires after one hour
                periodicBudgetReq = periodicBudgetReq,
                receiveOnly = null  // Defaults to false
            ))
            println(addResponse.connection.connectionString)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: add-connection
    }

    fun nwcEditConnection(nwcService: SdkNwcService) {
        // ANCHOR: edit-connection
        val newExpiryTime = 60u * 24u
        try {
            val editResponse = nwcService.editConnection(EditConnectionRequest(
                name = "my new connection",
                expiryTimeMins = newExpiryTime,  // The connection will now expire after 1 day
                periodicBudgetReq = null,
                receiveOnly = null,
                removeExpiry = null,
                removePeriodicBudget = true  // The periodic budget has been removed
            ))
            println(editResponse.connection.connectionString)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: edit-connection
    }

    fun nwcListConnections(nwcService: SdkNwcService) {
        // ANCHOR: list-connections
        try {
            val connections = nwcService.listConnections()
            for ((connectionName, connection) in connections) {
                println("Connection: $connectionName - Expires at: ${connection.expiresAt}, Periodic Budget: ${connection.periodicBudget}")
                // ...
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-connections
    }

    fun nwcRemoveConnection(nwcService: SdkNwcService) {
        // ANCHOR: remove-connection
        try {
            nwcService.removeConnection(name = "my new connection")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: remove-connection
    }

    fun nwcGetInfo(nwcService: SdkNwcService) {
        // ANCHOR: get-info
        val info = nwcService.getInfo()
        // ANCHOR_END: get-info
    }

    fun nwcEvents(nwcService: SdkNwcService) {
        // ANCHOR: events
        class MyListener : NwcEventListener {
            override fun onEvent(event: NwcEvent) {
                when (val details = event.details) {
                    is NwcEventDetails.Connected -> {
                        // ...
                    }
                    is NwcEventDetails.Disconnected -> {
                        // ...
                    }
                    is NwcEventDetails.ConnectionExpired -> {
                        // ...
                    }
                    is NwcEventDetails.ConnectionRefreshed -> {
                        // ...
                    }
                    is NwcEventDetails.PayInvoice -> {
                        // details.success, details.preimage, details.feesSat, details.error
                        // ...
                    }
                    is NwcEventDetails.ZapReceived -> {
                        // details.invoice
                        // ...
                    }
                    else -> {}
                }
            }
        }

        val eventListener = MyListener()
        try {
            val myListenerId = nwcService.addEventListener(listener = eventListener)
            // If you wish to remove the event_listener later on, you can call:
            nwcService.removeEventListener(id = myListenerId)
            // Otherwise, it will be automatically removed on service stop
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: events
    }

    fun nwcListPayments(nwcService: SdkNwcService) {
        // ANCHOR: payments
        try {
            nwcService.listConnectionPayments(connectionName = "my new connection")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: payments
    }
}
