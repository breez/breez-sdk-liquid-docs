import BreezLiquidSDK

// ANCHOR: init-sdk
// SDK events listener
class SDKListener: EventListener {
    func onEvent(e: BreezEvent) {
        print("received event ", e)
    }
}

func gettingStarted() throws -> BlockingBreezServices? {
    // Create the default config
    let seed = try? mnemonicToSeed(phrase: "<mnemonic words>")

    let inviteCode = "<invite code>"
    let apiKey = "<api key>"
    var config = defaultConfig(envType: EnvironmentType.production, apiKey: apiKey,
                               nodeConfig: NodeConfig.greenlight(
                                   config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: inviteCode)))

    // Customize the config object according to your needs
    config.workingDir = "path to an existing directory"

    // Connect to the Breez SDK make it ready for use
    guard seed != nil else {
        return nil
    }
    let connectRequest = ConnectRequest(config: config, seed: seed!)
    let sdk = try? connect(req: connectRequest, listener: SDKListener())

    return sdk
}
// ANCHOR_END: init-sdk

func gettingStartedNodeInfo(sdk: BlockingBreezServices) {
    // ANCHOR: fetch-balance
    if let nodeInfo = try? sdk.nodeInfo() {
        let lnBalance = nodeInfo.channelsBalanceMsat
        let onchainBalance = nodeInfo.onchainBalanceMsat
        print(lnBalance);
        print(onchainBalance);
    }
    // ANCHOR_END: fetch-balance
}
