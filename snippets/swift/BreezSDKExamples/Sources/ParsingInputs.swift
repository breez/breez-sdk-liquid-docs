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

        case .bolt12Offer(let offer, let bip353Address):
            print("Input is BOLT12 offer for min \(offer.minAmount) msats - BIP353 was used: \(bip353Address != nil)")

        case .lnUrlPay(let data, let bip353Address):
            print(
                "Input is LNURL-Pay/Lightning address accepting min/max \(data.minSendable)/\(data.maxSendable) msats - BIP353 was used: \(bip353Address != nil)"
            )
        case .lnUrlWithdraw(let data):
            print(
                "Input is LNURL-Withdraw for min/max \(data.minWithdrawable)/\(data.maxWithdrawable) msats"
            )

        default:
            break  // Other input types are available
        }
    } catch {
        print("Failed to parse input: \(error)")
    }
    // ANCHOR_END: parse-inputs
}

