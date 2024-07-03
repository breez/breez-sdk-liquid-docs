import BreezLiquidSDK
import Foundation

func GetCurrentLimits(sdk: BindingLiquidSdk) -> OnchainPaymentLimitsResponse?? {
    //  ANCHOR: get-current-pay-onchain-limits
    let currentLimits = try? sdk.fetchOnchainLimits()
    if let limits = currentLimits {
        print("Minimum amount, in sats: \(limits.send.minSat)")
        print("Maximum amount, in sats: \(limits.send.maxSat)")
    }
    // ANCHOR_END: get-current-pay-onchain-limits
    return currentLimits
}

func PreparePayOnchain(sdk: BindingLiquidSdk, currentLimits: Limits) -> PreparePayOnchainResponse? {
    // ANCHOR: prepare-pay-onchain
    let prepareRequest = PreparePayOnchainRequest(receiverAmountSat: 5_000)
    let prepareResponse = try? sdk.preparePayOnchain(req: prepareRequest)

    if let response = prepareResponse {
        // Check if the fees are acceptable before proceeding
        print("Payer fees, in sats: \(response.feesSat)")
    }
    // ANCHOR_END: prepare-pay-onchain
    return prepareResponse
}

func StartReverseSwap(sdk: BindingLiquidSdk, prepareResponse: PreparePayOnchainResponse) -> SendPaymentResponse? {
    // ANCHOR: start-reverse-swap
    let destinationAddress = "bc1.."

    let response = try? sdk.payOnchain(req: PayOnchainRequest(
        address: destinationAddress,
        prepareRes: prepareResponse))
    // ANCHOR_END: start-reverse-swap
    return response
}
