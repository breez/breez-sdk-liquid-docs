import BreezSDKLiquid
import Foundation

func parseInput(sdk: BindingLiquidSdk) {
    // ANCHOR: parse-inputs
    let input = "an input to be parsed..."

    do {
        let inputType = try sdk.parse(input: input)
        switch inputType {
        case .bitcoinAddress(let address):
            print("Input is Bitcoin address \(address.address)")
            
        case .bolt11(let invoice):
            let amount = invoice.amountMsat.map { String($0) } ?? "unknown"
            print("Input is BOLT11 invoice for \(amount) msats")
            
        case .lnUrlPay(let data):
            print("Input is LNURL-Pay/Lightning address accepting min/max \(data.minSendable)/\(data.maxSendable) msats")
            
        case .lnUrlWithdraw(let data):
            print("Input is LNURL-Withdraw for min/max \(data.minWithdrawable)/\(data.maxWithdrawable) msats")
        
        default:
            break // Other input types are available
        }
    } catch {
        print("Failed to parse input: \(error)")
    }
    // ANCHOR_END: parse-inputs
}

func configureParsers() throws -> BindingLiquidSdk? {
    // ANCHOR: configure-external-parser
    let mnemonic = "<mnemonic words>"

    // Create the default config, providing your Breez API key
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Configure external parsers
    config.externalInputParsers = [
        ExternalInputParser(
            providerId: "provider_a",
            inputRegex: "^provider_a",
            parserUrl: "https://parser-domain.com/parser?input=<input>"
        ),
        ExternalInputParser(
            providerId: "provider_b", 
            inputRegex: "^provider_b",
            parserUrl: "https://parser-domain.com/parser?input=<input>"
        )
    ]

    let connectRequest = ConnectRequest(config: config, mnemonic: mnemonic)
    let sdk = try? connect(req: connectRequest)
    // ANCHOR_END: configure-external-parser

    return sdk
}
