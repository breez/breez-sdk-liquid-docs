import BreezSDKLiquid

func prepareReceiveAsset(sdk: BindingLiquidSdk) -> PrepareReceiveResponse? {
    // ANCHOR: prepare-receive-payment-asset
    // Create a Liquid BIP21 URI/address to receive an asset payment to.
    // Note: Not setting the amount will generate an amountless BIP21 URI.
    let usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
    let optionalAmount = ReceiveAmount.asset(assetId: usdtAssetId, payerAmount: 1.50)
    let prepareResponse = try? sdk
        .prepareReceivePayment(req: PrepareReceiveRequest(
            paymentMethod: PaymentMethod.liquidAddress,
            amount: optionalAmount
        ))

    // If the fees are acceptable, continue to create the Receive Payment
    let receiveFeesSat = prepareResponse!.feesSat
    print("Fees: \(receiveFeesSat) sats")
    // ANCHOR_END: prepare-receive-payment-asset

    return prepareResponse
}

func prepareSendPaymentAsset(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-asset
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let destination = "<Liquid BIP21 or address>"
    // If the destination is an address or an amountless BIP21 URI,
    // you must specify an asset amount
    let usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
    let optionalAmount = PayAmount.asset(
        toAsset: usdtAssetId,
        receiverAmount: 1.50,
        estimateAssetFees: false,
        fromAsset: Optional.none
    )
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: destination,
            amount: optionalAmount,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: \(sendFeesSat) sats")
    // ANCHOR_END: prepare-send-payment-asset
    return prepareResponse
}

func prepareSendPaymentAssetFees(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-asset-fees
    let destination = "<Liquid BIP21 or address>"
    let usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
    // Set the optional estimate asset fees param to true
    let optionalAmount = PayAmount.asset(
        toAsset: usdtAssetId,
        receiverAmount: 1.50,
        estimateAssetFees: true,
        fromAsset: Optional.none
    )
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: destination,
            amount: optionalAmount,
            disableMrh: nil,
            paymentTimeoutSec: nil
        ))

    // If the asset fees are set, you can use these fees to pay to send the asset
    let sendAssetFees = prepareResponse!.estimatedAssetFees
    print("Estimated Fees: ~\(String(describing: sendAssetFees))")

    // If the asset fess are not set, you can use the sats fees to pay to send the asset
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: \(sendFeesSat) sats")
    // ANCHOR_END: prepare-send-payment-asset-fees
    return prepareResponse
}

func sendSelfPaymentAsset(sdk: BindingLiquidSdk) -> SendPaymentResponse? {
    // ANCHOR: send-self-payment-asset
    // Create a Liquid address to receive to
    let prepareReceiveRes = try? sdk.prepareReceivePayment(req: PrepareReceiveRequest (
        paymentMethod: PaymentMethod.liquidAddress,
        amount: Optional.none
    ))
    let receiveRes = try? sdk.receivePayment(req: ReceivePaymentRequest(
        prepareResponse: prepareReceiveRes!,
        description: Optional.none,
        useDescriptionHash: Optional.none,
        payerNote: Optional.none
    ))

    // Swap your funds to the address we've created
    let usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
    let btcAssetId = "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d";

    let prepareSendRes = try? sdk.prepareSendPayment(req: PrepareSendRequest (
        destination: receiveRes!.destination,
        amount: PayAmount.asset (
            toAsset: usdtAssetId,
            // We want to receive 1.5 USDt
            receiverAmount: 1.50,
            estimateAssetFees: Optional.none,
            fromAsset: btcAssetId
        ),
        disableMrh: nil,
        paymentTimeoutSec: nil
    ))
    let sendRes = try? sdk.sendPayment(req: SendPaymentRequest(
        prepareResponse: prepareSendRes!,
        useAssetFees: Optional.none
    ))
    // ANCHOR_END: send-self-payment-asset
    return sendRes
}


func sendPaymentFees(sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) -> SendPaymentResponse? {
    // ANCHOR: send-payment-fees
    // Set the use asset fees param to true
    let sendResponse = try? sdk.sendPayment(req: SendPaymentRequest (
        prepareResponse: prepareResponse,
        useAssetFees: true
    ))
    let payment = sendResponse!.payment
    // ANCHOR_END: send-payment-fees
    print(payment)
    return sendResponse
}

func fetchAssetBalance(sdk: BindingLiquidSdk) {
    // ANCHOR: fetch-asset-balance
    if let info = try? sdk.getInfo() {
        let assetBalances = info.walletInfo.assetBalances
        
        print(assetBalances)
    }
    // ANCHOR_END: fetch-asset-balance
}
