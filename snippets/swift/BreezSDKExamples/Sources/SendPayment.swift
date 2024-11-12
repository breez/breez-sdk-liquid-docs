import BreezSDKLiquid

func prepareSendPaymentLightning(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-lightning
    // Set the bolt11 invoice you wish to pay
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<bolt11 invoice>"
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-lightning
    return prepareResponse
}

func prepareSendPaymentLiquid(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-liquid
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optionalAmount = PayAmount.receiver(amountSat: 5_000)

    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "<Liquid BIP21 or address>",
            amount: optionalAmount
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
            amount: optionalAmount
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-liquid-drain
    return prepareResponse
}

func sendPayment(sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) -> SendPaymentResponse? {
    // ANCHOR: send-payment
    let sendResponse = try? sdk.sendPayment(req: SendPaymentRequest (
        prepareResponse: prepareResponse
    ))
    let payment = sendResponse!.payment
    // ANCHOR_END: send-payment
    print(payment)
    return sendResponse
}
