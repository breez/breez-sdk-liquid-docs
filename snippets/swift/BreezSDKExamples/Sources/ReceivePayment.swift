import BreezSDKLiquid

func prepareReceiveLightning(sdk: BindingLiquidSdk) -> PrepareReceiveResponse? {
    // ANCHOR: prepare-receive-payment-lightning
    // Fetch the Receive lightning limits
    let currentLimits = try? sdk.fetchLightningLimits()
    print("Minimum amount: {} sats", currentLimits?.receive.minSat);
    print("Maximum amount: {} sats", currentLimits?.receive.maxSat);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    let prepareResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000,
            paymentMethod: PaymentMethod.lightning
        ));

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareResponse!.feesSat;
    // ANCHOR_END: prepare-receive-payment-lightning

    return prepareResponse
}

func prepareReceiveOnchain(sdk: BindingLiquidSdk) -> PrepareReceiveResponse? {
    // ANCHOR: prepare-receive-payment-onchain
    // Fetch the Receive onchain limits
    let currentLimits = try? sdk.fetchOnchainLimits()
    print("Minimum amount: {} sats", currentLimits?.receive.minSat);
    print("Maximum amount: {} sats", currentLimits?.receive.maxSat);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    let prepareResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000,
            paymentMethod: PaymentMethod.bitcoinAddress
        ));

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareResponse!.feesSat;
    // ANCHOR_END: prepare-receive-payment-onchain

    return prepareResponse
}

func prepareReceiveLiquid(sdk: BindingLiquidSdk) -> PrepareReceiveResponse? {
    // ANCHOR: prepare-receive-payment-liquid
    // Create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    let prepareResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            payerAmountSat: 5_000, // Not specifying the amount will create a plain Liquid address instead
            paymentMethod: PaymentMethod.liquidAddress
        ))

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareResponse!.feesSat;
    // ANCHOR_END: prepare-receive-payment-liquid

    return prepareResponse
}

func receivePayment(sdk: BindingLiquidSdk, prepareResponse: PrepareReceiveResponse) -> ReceivePaymentResponse? {
    let optionalDescription = "<description>"
    let res = try? sdk.receivePayment(req: ReceivePaymentRequest(
            prepareResponse: prepareResponse,
            description: optionalDescription
        ))

    let destination: String = res!.destination;
    // ANCHOR_END: receive-payment
    return res
}
