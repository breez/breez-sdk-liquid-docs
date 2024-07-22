import BreezSDKLiquid


func gettingStarted() throws -> BindingLiquidSdk? {
    // ANCHOR: init-sdk
    let mnemonic = "<mnemonic words>"

    // Create the default config
    var config = defaultConfig(network: LiquidNetwork.mainnet)

    // Customize the config object according to your needs
    config.workingDir = "path to an existing directory"

    let connectRequest = ConnectRequest(config: config, mnemonic: mnemonic)
    let sdk = try? connect(req: connectRequest)
    // ANCHOR_END: init-sdk

    return sdk
}


func gettingStartedNodeInfo(sdk: BindingLiquidSdk) {
    // ANCHOR: fetch-balance
    if let walletInfo = try? sdk.getInfo() {
        let balanceSat = walletInfo.balanceSat
        let pendingSendSat = walletInfo.pendingSendSat
        let pendingReceiveSat = walletInfo.pendingReceiveSat

        print(balanceSat)
        print(pendingSendSat)
        print(pendingReceiveSat)
    }
    // ANCHOR_END: fetch-balance
}

// ANCHOR: logging
class SDKLogStream: LogStream {
    func log(l: LogEntry) {
        print("Received log [", l.level, "]: ", l.line)
    }
}

func logging() throws {
    try? setLogStream(logStream: SDKLogStream())
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
    try? sdk.removeEventListener(listenerId: listenerId)
}
// ANCHOR_END: remove-event-listener
