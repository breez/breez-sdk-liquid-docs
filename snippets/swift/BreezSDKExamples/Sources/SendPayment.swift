import BreezLiquidSDK

func sendPayment(sdk: BindingLiquidSdk) -> SendPaymentResponse? {
    // ANCHOR: send-payment
    // The `amountMsat` param is optional and should only passed if the bolt11 doesn't specify an amount.
    // The amountMsat is required in case an amount is not specified in the bolt11 invoice'.
    let optionalAmountMsat: UInt64 = 3_000_000
    let optionalLabel = "<label>"
    let req = SendPaymentRequest(bolt11: "...", amountMsat: optionalAmountMsat, label: optionalLabel)
    let response = try? sdk.sendPayment(req: req)
    // ANCHOR_END: send-payment
    return response
}
