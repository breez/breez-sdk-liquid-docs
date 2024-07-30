package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ReceivePayment {
    fun receivePayment(sdk: BindingLiquidSdk) {
        // ANCHOR: receive-payment
        try {
            // Fetch the Receive limits
            val currentLimits = sdk.fetchLightningLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}")

            // Set the amount you wish the payer to send, which should be within the above limits
            val prepareReq = PrepareReceivePaymentRequest(5_000.toULong())
            val prepareRes = sdk.prepareReceivePayment(prepareReq)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat = prepareRes.feesSat;

            val optionalDescription = "<description>";
            val req = ReceivePaymentRequest(prepareRes, optionalDescription)
            val res = sdk.receivePayment(req)

            val invoice = res.invoice;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: receive-payment
    }
}