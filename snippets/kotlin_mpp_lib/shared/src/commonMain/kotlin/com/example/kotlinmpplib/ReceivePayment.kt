package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ReceivePayment {
    fun prepareReceiveLightning(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-receive-payment-lightning
        try {
            // Fetch the lightning Receive limits
            val currentLimits = sdk.fetchLightningLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}")

            // Set the invoice amount you wish the payer to send, which should be within the above limits
            val prepareRequest = PrepareReceiveRequest(PaymentMethod.LIGHTNING, 5_000.toULong())
            val prepareResponse = sdk.prepareReceivePayment(prepareRequest)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${receiveFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-receive-payment-lightning
    }

    fun prepareReceiveOnchain(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-receive-payment-onchain
        try {
            // Fetch the onchain Receive limits
            val currentLimits = sdk.fetchOnchainLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}")

            // Set the onchain amount you wish the payer to send, which should be within the above limits
            val prepareRequest = PrepareReceiveRequest(PaymentMethod.BITCOIN_ADDRESS, 5_000.toULong())
            val prepareResponse = sdk.prepareReceivePayment(prepareRequest)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${receiveFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-receive-payment-onchain
    }

    fun prepareReceiveLiquid(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-receive-payment-liquid
        try {
            // Create a Liquid BIP21 URI/address to receive a payment to.
            // There are no limits, but the payer amount should be greater than broadcast fees when specified
            // Note: Not setting the amount will generate a plain Liquid address
            val prepareRequest = PrepareReceiveRequest(PaymentMethod.LIQUID_ADDRESS, 5_000.toULong())
            val prepareResponse = sdk.prepareReceivePayment(prepareRequest)

            // If the fees are acceptable, continue to create the Receive Payment
            val receiveFeesSat = prepareResponse.feesSat;
            // Log.v("Breez", "Fees: ${receiveFeesSat} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-receive-payment-liquid
    }

    fun receivePayment(sdk: BindingLiquidSdk, prepareResponse: PrepareReceiveResponse) {
        // ANCHOR: receive-payment
        try {
            val optionalDescription = "<description>";
            val req = ReceivePaymentRequest(prepareResponse, optionalDescription)
            val res = sdk.receivePayment(req)
            val destination = res.destination;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: receive-payment
    }
}
