package com.example.kotlinmpplib

import breez_sdk_liquid.*
class NonBitcoinAsset {
    fun prepareReceiveAsset(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-receive-payment-asset
        try {
            // Create a Liquid BIP21 URI/address to receive an asset payment to.
            // Note: Not setting the amount will generate an amountless BIP21 URI.
            val usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
            val optionalAmount = ReceiveAmount.Asset(usdtAssetId, 1.50)
            val prepareRequest = PrepareReceiveRequest(PaymentMethod.LIQUID_ADDRESS, optionalAmount)
            val prepareResponse = sdk.prepareReceivePayment(prepareRequest)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${receiveFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-receive-payment-asset
    }

    fun prepareSendPaymentAsset(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-asset
        // Set the Liquid BIP21 or Liquid address you wish to pay
        val destination = "<Liquid BIP21 or address>"
        try {
            // Create a Liquid BIP21 URI/address to receive an asset payment to.
            // Note: Not setting the amount will generate an amountless BIP21 URI.
            val usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
            val optionalAmount = PayAmount.Asset(usdtAssetId, 1.50, false)
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-asset
    }

    fun prepareSendPaymentAssetFees(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-asset-fees
        val destination = "<Liquid BIP21 or address>"
        try {
            val usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
            // Set the optional estimate asset fees param to true
            val optionalAmount = PayAmount.Asset(usdtAssetId, 1.50, true)
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount))

            // If the asset fees are set, you can use these fees to pay to send the asset
            val sendAssetFees = prepareResponse.assetFees;
            // Log.v("Breez", "Fees: ${sendAssetFees}")
            
            // If the asset fess are not set, you can use the sats fees to pay to send the asset
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-asset-fees
    }

    fun sendPaymentFees(sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) {
        // ANCHOR: send-payment-fees
        try {
            // Set the use asset fees param to true
            val sendResponse = sdk.sendPayment(SendPaymentRequest(prepareResponse, true))
            val payment = sendResponse.payment
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-payment-fees
    }

    fun configureAssetMetadata() {
        // ANCHOR: configure-asset-metadata
        // Create the default config
        val config : Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")

        // Configure asset metadata. Setting the optional fiat ID will enable
        // paying fees using the asset (if available).
        config.assetMetadata = listOf(
            AssetMetadata(
                assetId = "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
                name = "PEGx EUR",
                ticker = "EURx",
                precision = 8.toUByte(),
                fiatID = "EUR"
            )
        )
        // ANCHOR_END: configure-asset-metadata
    }

    fun fetchAssetBalance(sdk: BindingLiquidSdk) {
        // ANCHOR: fetch-asset-balance
        try {
            val info = sdk.getInfo()
            val assetBalances = info?.walletInfo?.assetBalances
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: fetch-asset-balance
    }
}
