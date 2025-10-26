import BreezSDKLiquid

func getCurrentLightningLimits(sdk: BindingLiquidSdk) -> LightningPaymentLimitsResponse?? {
    //  ANCHOR: get-current-pay-lightning-limits
    let currentLimits = try? sdk.fetchLightningLimits()
    if let limits = currentLimits {
        print("Minimum amount, in sats: \(limits.send.minSat)")
        print("Maximum amount, in sats: \(limits.send.maxSat)")
    }
    // ANCHOR_END: get-current-pay-lightning-limits
    return currentLimits
}

func prepareSendPaymentLightningBolt11(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-lightning-bolt11
    // Set the bolt11 invoice you wish to pay
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<bolt11 invoice>",
            amount: nil,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-lightning-bolt11
    return prepareResponse
}

func prepareSendPaymentLightningBolt12(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-lightning-bolt12
    // Set the bolt12 offer you wish to pay
    let optionalAmount = PayAmount.bitcoin(receiverAmountSat: 5_000)
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<bolt12 offer>",
            amount: optionalAmount,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))
    // ANCHOR_END: prepare-send-payment-lightning-bolt12
    return prepareResponse
}

func prepareSendPaymentLiquid(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-liquid
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optionalAmount = PayAmount.bitcoin(receiverAmountSat: 5_000)
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<Liquid BIP21 or address>",
            amount: optionalAmount,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-liquid
    return prepareResponse
}

func prepareSendPaymentLiquidDrain(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-liquid-drain
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optionalAmount = PayAmount.drain
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<Liquid BIP21 or address>",
            amount: optionalAmount,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-liquid-drain
    return prepareResponse
}

func sendPayment(sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) -> SendPaymentResponse? {
    // ANCHOR: send-payment
    let optionalPayerNote = "<payer note>"
    let sendResponse = try? sdk.sendPayment(req: SendPaymentRequest (
        prepareResponse: prepareResponse,
        payerNote: optionalPayerNote
    ))
    let payment = sendResponse!.payment
    // ANCHOR_END: send-payment
    print(payment)
    return sendResponse
}
