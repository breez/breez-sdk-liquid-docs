import BreezSDKLiquid

func nwcConnect(sdk: BindingLiquidSdk) {
    // ANCHOR: connecting
    let nwcConfig = NwcConfig(
        relayUrls: nil,
        secretKeyHex: nil,
        listenToEvents: nil
    )
    let nwcService = try? sdk.useNwcPlugin(config: nwcConfig)

    // ...

    // Automatically stops the plugin
    try? sdk.disconnect()
    // Alternatively, you can stop the plugin manually, without disconnecting the SDK
    nwcService?.stop()
    // ANCHOR_END: connecting
}

func nwcAddConnection(nwcService: BindingNwcService) {
    // ANCHOR: add-connection
    // This connection will only allow spending at most 10,000 sats/hour
    let periodicBudgetReq = PeriodicBudgetRequest(
        maxBudgetSat: 10000,
        renewalTimeMins: 60  // Renews every hour
    )
    if let addResponse = try? nwcService.addConnection(
        req: AddConnectionRequest(
            name: "my new connection",
            receiveOnly: nil,  // Defaults to false
            expiryTimeMins: 60,  // Expires after one hour
            periodicBudgetReq: periodicBudgetReq
        ))
    {
        print(addResponse.connection.connectionString)
    }
    // ANCHOR_END: add-connection
}

func nwcEditConnection(nwcService: BindingNwcService) {
    // ANCHOR: edit-connection
    let newExpiryTime: UInt32 = 60 * 24
    if let editResponse = try? nwcService.editConnection(
        req: EditConnectionRequest(
            name: "my new connection",
            receiveOnly: nil,
            expiryTimeMins: newExpiryTime,  // The connection will now expire after 1 day
            removeExpiry: nil,
            periodicBudgetReq: nil,
            removePeriodicBudget: true  // The periodic budget has been removed
        ))
    {
        print(editResponse.connection.connectionString)
    }
    // ANCHOR_END: edit-connection
}

func nwcListConnections(nwcService: BindingNwcService) {
    // ANCHOR: list-connections
    if let connections = try? nwcService.listConnections() {
        for (connectionName, connection) in connections {
            print(
                "Connection: \(connectionName) - Expires at: \(String(describing: connection.expiresAt)), Periodic Budget: \(String(describing: connection.periodicBudget))"
            )
            // ...
        }
    }
    // ANCHOR_END: list-connections
}

func nwcRemoveConnection(nwcService: BindingNwcService) {
    // ANCHOR: remove-connection
    try? nwcService.removeConnection(name: "my new connection")
    // ANCHOR_END: remove-connection
}

func nwcGetInfo(nwcService: BindingNwcService) {
    // ANCHOR: get-info
    let info = try? nwcService.getInfo()
    // ANCHOR_END: get-info
}

func nwcEvents(nwcService: BindingNwcService) {
    // ANCHOR: events
    class MyListener: NwcEventListener {
        func onEvent(event: NwcEvent) {
            switch event.details {
            case .connected:
                // ...
                break
            case .disconnected:
                // ...
                break
            case .connectionExpired:
                // ...
                break
            case .connectionRefreshed:
                // ...
                break
            case .payInvoice(let success, let preimage, let feesSat, let error):
                // ...
                break
            case .zapReceived(let invoice):
                // ...
                break
            default:
                break
            }
        }
    }

    let eventListener = MyListener()
    if let myListenerId = try? nwcService.addEventListener(listener: eventListener) {
        // If you wish to remove the event_listener later on, you can call:
        try? nwcService.removeEventListener(listenerId: myListenerId)
        // Otherwise, it will be automatically removed on service stop
    }
    // ANCHOR_END: events
}

func nwcListPayments(nwcService: BindingNwcService) {
    // ANCHOR: payments
    let payments = try? nwcService.listConnectionPayments(name: "my new connection")
    // ANCHOR_END: payments
}
