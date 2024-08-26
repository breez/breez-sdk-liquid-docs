package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ReceivePayment {
    fun receivePayment(sdk: BindingLiquidSdk) {
        // ANCHOR: receive-payment
        try {
            // Fetch the lightning Receive limits
            val currentLightningLimits = sdk.fetchLightningLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentLightningLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentLightningLimits.receive.maxSat}")

            // Set the invoice amount you wish the payer to send, which should be within the above limits
            val prepareLightningReq = PrepareReceiveRequest(5_000.toULong(), PaymentMethod.Lightning)
            val prepareLightningRes = sdk.prepareReceivePayment(prepareLightningReq)

            // Fetch the onchain Receive limits
            val currentOnchainLimits = sdk.fetchOnchainLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentOnchainLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentOnchainLimits.receive.maxSat}")

            // Set the onchain amount you wish the payer to send, which should be within the above limits
            val prepareOnchainReq = PrepareReceiveRequest(5_000.toULong(), PaymentMethod.BitcoinAddress)
            val prepareOnchainRes = sdk.prepareReceivePayment(prepareOnchainReq)

            // Or simply create a Liquid BIP21 URI/address to receive a payment to.
            // There are no limits, but the payer amount should be greater than broadcast fees when specified
            // Note: Setting `Nothing` as the amount will create a plain Liquid address
            val prepareLiquidReq = PrepareReceiveRequest(5_000.toULong(), PaymentMethod.LiquidAddress)
            val prepareLiquidRes = sdk.prepareReceivePayment(prepareLiquidReq)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat =  prepareLiquidRes.feesSat;

            val optionalDescription = "<description>";
            val req = ReceivePaymentRequest(prepareLiquidRes, optionalDescription)
            val res = sdk.receivePayment(req)

            val destination = res.destination;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: receive-payment
    }
}
