import BreezLiquidSDK

func receivePayment(sdk: BlockingBreezServices) -> ReceivePaymentResponse? {
    // ANCHOR: receive-payment
    let receivePaymentResponse = try? sdk.receivePayment(
        req: ReceivePaymentRequest(
            amountMsat: 3_000_000,
            description: "Invoice for 3 000 sats"))

    let invoice = receivePaymentResponse?.lnInvoice;
    // ANCHOR_END: receive-payment
    print(invoice as Any)
    return receivePaymentResponse
}
