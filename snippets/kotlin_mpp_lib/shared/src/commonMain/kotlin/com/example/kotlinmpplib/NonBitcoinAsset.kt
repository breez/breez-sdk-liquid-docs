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
            val optionalAmount = PayAmount.Asset(usdtAssetId, 1.50, false, null)
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount, null, null))

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
            val optionalAmount = PayAmount.Asset(usdtAssetId, 1.50, true, null)
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount, null, null))

            // If the asset fees are set, you can use these fees to pay to send the asset
            val sendAssetFees = prepareResponse.estimatedAssetFees;
            // Log.v("Breez", "Estimated Fees: ~${sendAssetFees}")
            
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

    fun sendSelfPaymentAsset(sdk: BindingLiquidSdk) {
        // ANCHOR: send-self-payment-asset
        try {
            // Create a Liquid address to receive to
            val prepareReceiveRes = sdk.prepareReceivePayment(PrepareReceiveRequest(PaymentMethod.LIQUID_ADDRESS, null))
            val receiveRes = sdk.receivePayment(ReceivePaymentRequest(prepareReceiveRes, null, null, null))

            // Swap your funds to the address we've created
            val usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
            val btcAssetId = "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d"
            val prepareSendRes = sdk.prepareSendPayment(
                PrepareSendRequest(
                    receiveRes.destination,
                    PayAmount.Asset(
                        usdtAssetId,
                        // We want to receive 1.5 USDt
                        1.5,
                        null,
                        btcAssetId
                    ),
                    null,
                    null
                )
            )
            val sendRes = sdk.sendPayment(SendPaymentRequest(prepareSendRes, null))
            val payment = sendRes.payment
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-self-payment-asset
    }
}
