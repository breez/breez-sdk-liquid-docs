import BreezLiquidSDK


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
    if let nodeState = try? sdk.getInfo() {
        let balanceSat = nodeState.balanceSat
        let pendingSendSat = nodeState.pendingSendSat
        let pendingReceiveSat = nodeState.pendingReceiveSat

        print(balanceSat)
        print(pendingSendSat)
        print(pendingReceiveSat)
    }
    // ANCHOR_END: fetch-balance
}
