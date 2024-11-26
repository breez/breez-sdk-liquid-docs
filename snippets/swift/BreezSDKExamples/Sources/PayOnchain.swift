import BreezSDKLiquid
import Foundation

func getCurrentLimits(sdk: BindingLiquidSdk) -> OnchainPaymentLimitsResponse?? {
    //  ANCHOR: get-current-pay-onchain-limits
    let currentLimits = try? sdk.fetchOnchainLimits()
    if let limits = currentLimits {
        print("Minimum amount, in sats: \(limits.send.minSat)")
        print("Maximum amount, in sats: \(limits.send.maxSat)")
    }
    // ANCHOR_END: get-current-pay-onchain-limits
    return currentLimits
}

func preparePayOnchain(sdk: BindingLiquidSdk, currentLimits: Limits) -> PreparePayOnchainResponse? {
    // ANCHOR: prepare-pay-onchain
    let amount = PayAmount.receiver(amountSat: 5_000)
    let prepareRequest = PreparePayOnchainRequest(amount: amount)
    let prepareResponse = try? sdk.preparePayOnchain(req: prepareRequest)

    if let response = prepareResponse {
        // Check if the fees are acceptable before proceeding
        print("Payer fees, in sats: \(response.totalFeesSat)")
    }
    // ANCHOR_END: prepare-pay-onchain
    return prepareResponse
}

func preparePayOnchainDrain(sdk: BindingLiquidSdk, currentLimits: Limits) -> PreparePayOnchainResponse? {
    // ANCHOR: prepare-pay-onchain-drain
    let amount = PayAmount.drain
    let prepareRequest = PreparePayOnchainRequest(amount: amount)
    let prepareResponse = try? sdk.preparePayOnchain(req: prepareRequest)

    if let response = prepareResponse {
        // Check if the fees are acceptable before proceeding
        print("Payer fees, in sats: \(response.totalFeesSat)")
    }
    // ANCHOR_END: prepare-pay-onchain-drain
    return prepareResponse
}

func preparePayOnchainFeeRate(sdk: BindingLiquidSdk, currentLimits: Limits) -> PreparePayOnchainResponse? {
    // ANCHOR: prepare-pay-onchain-fee-rate
    let amount = PayAmount.receiver(amountSat: 5_000)
    let optionalSatPerVbyte = UInt32(21)

    let prepareRequest = PreparePayOnchainRequest(amount: amount, feeRateSatPerVbyte: optionalSatPerVbyte)
    let prepareResponse = try? sdk.preparePayOnchain(req: prepareRequest)

    if let response = prepareResponse {
        // Check if the fees are acceptable before proceeding
        print("Payer claim fees, in sats: \(response.claimFeesSat)")
        print("Payer total fees, in sats: \(response.totalFeesSat)")
    }
    // ANCHOR_END: prepare-pay-onchain-fee-rate
    return prepareResponse
}

func startReverseSwap(sdk: BindingLiquidSdk, prepareResponse: PreparePayOnchainResponse) -> SendPaymentResponse? {
    // ANCHOR: start-reverse-swap
    let destinationAddress = "bc1.."

    let response = try? sdk.payOnchain(req: PayOnchainRequest(
        address: destinationAddress,
        prepareResponse: prepareResponse))
    // ANCHOR_END: start-reverse-swap
    return response
}
