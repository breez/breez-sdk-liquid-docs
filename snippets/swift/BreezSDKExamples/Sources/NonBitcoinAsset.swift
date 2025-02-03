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
    let receiveFeesSat = prepareResponse!.feesSat;
    print("Fees: {} sats", receiveFeesSat);
    // ANCHOR_END: prepare-receive-payment-asset

    return prepareResponse
}

func prepareSendPaymentAsset(sdk: BindingLiquidSdk) -> PrepareSendResponse? {
    // ANCHOR: prepare-send-payment-asset
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let destination = "<Liquid BIP21 or address>"
    // If the destination is an address or an amountless BIP21 URI,
    // you must specifiy an asset amount
    let usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
    let optionalAmount = PayAmount.asset(assetId: usdtAssetId, receiverAmount: 1.50)
    let prepareResponse = try? sdk
        .prepareSendPayment(req: PrepareSendRequest (
            destination: destination,
            amount: optionalAmount
        ))

    // If the fees are acceptable, continue to create the Send Payment
    let sendFeesSat = prepareResponse!.feesSat
    print("Fees: {} sats", sendFeesSat);
    // ANCHOR_END: prepare-send-payment-asset
    return prepareResponse
}

func configureAssetMetadata() throws {
    // ANCHOR: configure-asset-metadata
    // Create the default config
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Configure asset metadata
    config.assetMetadata = [
        AssetMetadata(
            assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            name: "PEGx EUR",
            ticker: "EURx",
            precision: 8
        )
    ]
    // ANCHOR_END: configure-asset-metadata
}

func fetchAssetBalance(sdk: BindingLiquidSdk) {
    // ANCHOR: fetch-asset-balance
    if let info = try? sdk.getInfo() {
        let assetBalances = info.walletInfo.assetBalances
        
        print(assetBalances)
    }
    // ANCHOR_END: fetch-asset-balance
}
