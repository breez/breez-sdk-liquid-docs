package com.example.kotlinmpplib

import breez_sdk_liquid.*
class SendPayment {
    fun sendPayment(sdk: BindingLiquidSdk) {
        // ANCHOR: send-payment
        // Set the BOLT11 invoice you wish to pay
        val bolt11 = "..."
        try {
            val prepareSendResponse = sdk.prepareSendPayment(PrepareSendRequest(bolt11))

            // If the fees are acceptable, continue to create the Send Payment
            val sendFeesSat = prepareSendResponse.feesSat;

            val sendResponse = sdk.sendPayment(prepareSendResponse)
            val payment = sendResponse.payment
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-payment
    }
}