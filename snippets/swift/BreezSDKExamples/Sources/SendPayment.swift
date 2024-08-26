import BreezSDKLiquid

func sendPayment(sdk: BindingLiquidSdk) -> SendPaymentResponse? {
    // ANCHOR: send-payment
    // Set the BOLT11 invoice you wish to pay
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: "Invoice, Liquid BIP21 or address",
            amountSat: 5000
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print(sendFeesSat)

    let sendResponse = try? sdk.sendPayment(req: SendPaymentRequest (
        prepareResponse: prepareResponse!
    ))
    let payment = sendResponse!.payment
    print(payment)
    // ANCHOR_END: send-payment
    return sendResponse
}
