import BreezLiquidSDK

func receivePayment(sdk: BindingLiquidSdk) -> ReceivePaymentResponse? {
    // ANCHOR: receive-payment
    // Fetch the Receive limits
    let currentLimits = try? sdk.fetchLightningLimits()
    print("Minimum amount: {} sats", currentLimits.receive.minSat);
    print("Maximum amount: {} sats", currentLimits.receive.maxSat);

    // Set the amount you wish the payer to send, which should be within the above limits
    let prepareReceiveResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000
        ))

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareReceiveResponse!.feesSat;

    let receivePaymentResponse = try? sdk.receivePayment(req: prepareReceiveResponse!)

    let invoice : String = receivePaymentResponse!.invoice;
    // ANCHOR_END: receive-payment
    print(invoice as Any)
    return receivePaymentResponse
}
