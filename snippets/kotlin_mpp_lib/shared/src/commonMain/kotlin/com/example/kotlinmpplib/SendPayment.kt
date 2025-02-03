package com.example.kotlinmpplib

import breez_sdk_liquid.*

class SendPayment {
    fun prepareSendPaymentLightningBolt11(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-lightning-bolt11
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
        // ANCHOR_END: prepare-send-payment-lightning-bolt11
    }

    fun prepareSendPaymentLightningBolt12(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-lightning-bolt12
        // Set the bolt12 offer you wish to pay
        val destination = "<bolt12 offer>"
        try {
            val optionalAmount = PayAmount.Bitcoin(5_000.toULong())
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-lightning-bolt12
    }
    fun prepareSendPaymentLiquid(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-liquid
        // Set the Liquid BIP21 or Liquid address you wish to pay
        val destination = "<Liquid BIP21 or address>"
        try {
            val optionalAmount = PayAmount.Bitcoin(5_000.toULong())
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-liquid
    }

    fun prepareSendPaymentLiquidDrain(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-send-payment-liquid-drain
        // Set the Liquid BIP21 or Liquid address you wish to pay
        val destination = "<Liquid BIP21 or address>"
        try {
            val optionalAmount = PayAmount.Drain
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmount))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${sendFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-send-payment-liquid-drain
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
