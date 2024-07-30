import BreezSDKLiquid

func receivePayment(sdk: BindingLiquidSdk) -> ReceivePaymentResponse? {
    // ANCHOR: receive-payment
    // Fetch the Receive limits
    let currentLimits = try? sdk.fetchLightningLimits()
    print("Minimum amount: {} sats", currentLimits?.receive.minSat);
    print("Maximum amount: {} sats", currentLimits?.receive.maxSat);

    // Set the amount you wish the payer to send, which should be within the above limits
    let prepareRes = try? sdk
        .prepareReceivePayment(req: PrepareReceivePaymentRequest(
            payerAmountSat: 5_000
        ))

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareRes!.feesSat;

    let optionalDescription = "<description>"
    let res = try? sdk.receivePayment(req: ReceivePaymentRequest(
            prepareRes: prepareRes!,
            description: optionalDescription
        ))

    let invoice : String = res!.invoice;
    // ANCHOR_END: receive-payment
    print(invoice as Any)
    return res
}
