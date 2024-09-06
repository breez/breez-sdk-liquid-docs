package com.example.kotlinmpplib

import breez_sdk_liquid.*

class SendPayment {
    fun prepareSendPaymentLightning(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-lightning
        // Set the bolt11 you wish to pay
        val destination = "<bolt11 invoice>"
        try {
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-lightning
    }

    fun prepareSendPaymentLiquid(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-liquid
        // Set the Liquid BIP21 or Liquid address you wish to pay
        val destination = "<Liquid BIP21 or address>"
        try {
            val optionalAmountSat = 5_000.toULong();
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmountSat))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-liquid
    }

    fun sendPayment(sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) {
        // ANCHOR: send-payment
        try {
            val sendResponse = sdk.sendPayment(SendPaymentRequest(prepareResponse))
            val payment = sendResponse.payment
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-payment
    }
}
