import BreezSDKLiquid

func receivePayment(sdk: BindingLiquidSdk) -> ReceivePaymentResponse? {
    // ANCHOR: receive-payment
    // Fetch the Receive lightning limits
    let currentLightningLimits = try? sdk.fetchLightningLimits()
    print("Minimum amount: {} sats", currentLightningLimits?.receive.minSat);
    print("Maximum amount: {} sats", currentLightningLimits?.receive.maxSat);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    let prepareLightningResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000,
            paymentMethod: PaymentMethod.lightning
        ))

    // Fetch the Receive onchain limits
    let currentOnchainLimits = try? sdk.fetchLightningLimits()
    print("Minimum amount: {} sats", currentOnchainLimits?.receive.minSat);
    print("Maximum amount: {} sats", currentOnchainLimits?.receive.maxSat);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    let prepareOnchainResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000,
            paymentMethod: PaymentMethod.bitcoinAddress
        ))

    // Or simply create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    let prepareLiquidResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000, // Not specifying the amount will create a plain Liquid address instead
            paymentMethod: PaymentMethod.liquidAddress
        ))

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareLiquidResponse!.feesSat;

    let optionalDescription = "<description>"
    let res = try? sdk.receivePayment(req: ReceivePaymentRequest(
            prepareResponse: prepareLiquidResponse!,
            description: optionalDescription
        ))

    let destination: String = res!.destination;
    // ANCHOR_END: receive-payment
    return res
}
