package com.example.kotlinmpplib

import breez_liquid_sdk.*
class ReceivePayment {
    fun receivePayment(sdk: BindingLiquidSdk) {
        // ANCHOR: receive-payment
        try {
            val receivePaymentResponse = sdk.receivePayment(ReceivePaymentRequest(
                3_000_000.toULong(),
                "Invoice for 3000 sats",
            ))

            val invoice = receivePaymentResponse.lnInvoice;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: receive-payment
    }
}