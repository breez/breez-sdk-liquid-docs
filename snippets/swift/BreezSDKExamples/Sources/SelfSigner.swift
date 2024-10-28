import BreezSDKLiquid

  // ANCHOR: self-signer
func connectWithSelfSigner(signer: Signer) throws -> BindingLiquidSdk? {
  
    let mnemonic = "<mnemonic words>"

    // Create the default config, providing your Breez API key
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Customize the config object according to your needs
    config.workingDir = "path to an existing directory"

    let connectRequest = ConnectWithSignerRequest(config: config)
    let sdk = try? connectWithSigner(req: connectRequest, signer: signer)

    return sdk
}
// ANCHOR: self-signer
