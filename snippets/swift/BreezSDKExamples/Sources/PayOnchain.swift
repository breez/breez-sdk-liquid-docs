import BreezLiquidSDK
import Foundation

func GetCurrentLimits(sdk: BlockingBreezServices) -> OnchainPaymentLimitsResponse?? {
    //  ANCHOR: get-current-pay-onchain-limits
    let currentLimits = try? sdk.onchainPaymentLimits()
    if let limits = currentLimits {
        print("Minimum amount, in sats: \(limits.minSat)")
        print("Maximum amount, in sats: \(limits.maxSat)")
    }
    // ANCHOR_END: get-current-pay-onchain-limits
    return currentLimits
}

func PreparePayOnchain(sdk: BlockingBreezServices, currentLimits: OnchainPaymentLimitsResponse) -> PrepareOnchainPaymentResponse? {
    // ANCHOR: prepare-pay-onchain
    let amountSat = currentLimits.minSat
    let satPerVbyte: UInt32 = 5

    let prepareRequest = PrepareOnchainPaymentRequest(amountSat: amountSat, amountType: .send, claimTxFeerate: satPerVbyte);
    let prepareResponse = try? sdk.prepareOnchainPayment(req: prepareRequest)

    if let response = prepareResponse {
        print("Sender amount, in sats: \(response.senderAmountSat)")
        print("Recipient amount, in sats: \(response.recipientAmountSat)")
        print("Total fees, in sats: \(response.totalFees)")
    }
    // ANCHOR_END: prepare-pay-onchain
    return prepareResponse
}

func StartReverseSwap(sdk: BlockingBreezServices, prepareResponse: PrepareOnchainPaymentResponse) -> PayOnchainResponse? {
    // ANCHOR: start-reverse-swap
    let destinationAddress = "bc1.."

    let response = try? sdk.payOnchain(req: PayOnchainRequest(recipientAddress: destinationAddress, prepareRes: prepareResponse))
    // ANCHOR_END: start-reverse-swap
    return response
}
