package com.example.kotlinmpplib

import breez_liquid_sdk.*
class SendPayment {
    fun sendPayment(sdk: BindingLiquidSdk) {
        // ANCHOR: send-payment
        val bolt11 = "..."
        try {
            val prepareSendResponse = sdk.prepareSendResponse(PrepareSendRequest(bolt11))

            val req = PrepareSendResponse(prepareSendResponse)
            val response = sdk.sendPayment(req)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: send-payment
    }
}