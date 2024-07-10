import BreezSDKLiquid

func sendPayment(sdk: BindingLiquidSdk) -> SendPaymentResponse? {
    // ANCHOR: send-payment
    // Set the BOLT11 invoice you wish to pay
    let prepareSendResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            invoice: "..."
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareSendResponse!.feesSat
    print(sendFeesSat)

    let sendResponse = try? sdk.sendPayment(req: prepareSendResponse!)
    let payment = sendResponse!.payment
    print(payment)
    // ANCHOR_END: send-payment
    return sendResponse
}
