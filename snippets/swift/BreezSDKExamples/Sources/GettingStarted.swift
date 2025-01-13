import BreezSDKLiquid


func gettingStarted() throws -> BindingLiquidSdk? {
    // ANCHOR: init-sdk
    let mnemonic = "<mnemonic words>"

    // Create the default config, providing your Breez API key
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Customize the config object according to your needs
    config.workingDir = "path to an existing directory"

    let connectRequest = ConnectRequest(config: config, mnemonic: mnemonic)
    let sdk = try? connect(req: connectRequest)
    // ANCHOR_END: init-sdk

    return sdk
}


func gettingStartedNodeInfo(sdk: BindingLiquidSdk) {
    // ANCHOR: fetch-balance
    if let info = try? sdk.getInfo() {
        let balanceSat = info.walletInfo.balanceSat
        let pendingSendSat = info.walletInfo.pendingSendSat
        let pendingReceiveSat = info.walletInfo.pendingReceiveSat

        print(balanceSat)
        print(pendingSendSat)
        print(pendingReceiveSat)
    }
    // ANCHOR_END: fetch-balance
}

// ANCHOR: logging
class SDKLogger: Logger {
    func log(l: LogEntry) {
        print("Received log [", l.level, "]: ", l.line)
    }
}

func logging() throws {
    try? setLogger(logger: SDKLogger())
}
// ANCHOR_END: logging

// ANCHOR: add-event-listener
class SDKEventListener: EventListener {
    func onEvent(e: SdkEvent) {
        print("Received event: ", e)
    }
}

func addEventListener(sdk: BindingLiquidSdk, listener: SDKEventListener) throws -> String? {
    let listenerId = try? sdk.addEventListener(listener: listener)
    return listenerId
}
// ANCHOR_END: add-event-listener

// ANCHOR: remove-event-listener
func removeEventListener(sdk: BindingLiquidSdk, listenerId: String) throws {
    try? sdk.removeEventListener(id: listenerId)
}
// ANCHOR_END: remove-event-listener

// ANCHOR: disconnect
func disconnect(sdk: BindingLiquidSdk) throws {
    try? sdk.disconnect()
}
// ANCHOR_END: disconnect
