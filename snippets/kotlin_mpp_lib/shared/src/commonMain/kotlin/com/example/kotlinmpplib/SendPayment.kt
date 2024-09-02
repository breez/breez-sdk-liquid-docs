package com.example.kotlinmpplib

import breez_sdk_liquid.*
class SendPayment {
    fun sendPayment(sdk: BindingLiquidSdk) {
        // ANCHOR: send-payment
        // Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
        val destination = "Invoice, Liquid BIP21 or address"
        try {
            val optionalAmountSat = 5_000.toULong();
            val prepareResponse = sdk.prepareSendPayment(PrepareSendRequest(destination, optionalAmountSat))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareResponse.feesSat;

            val sendResponse = sdk.sendPayment(SendPaymentRequest(prepareResponse))
            val payment = sendResponse.payment
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-payment
    }
}
