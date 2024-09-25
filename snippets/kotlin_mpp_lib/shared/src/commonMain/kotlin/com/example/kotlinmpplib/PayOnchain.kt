package com.example.kotlinmpplib

import breez_sdk_liquid.*
class PayOnchain {
    fun getCurrentRevSwapLimits(sdk: BindingLiquidSdk) {
        // ANCHOR: get-current-pay-onchain-limits
        try {
            val currentLimits = sdk.fetchOnchainLimits()
            // Log.v("Breez", "Minimum amount, in sats: ${currentLimits.send.minSat}")
            // Log.v("Breez", "Maximum amount, in sats: ${currentLimits.send.maxSat}")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: get-current-pay-onchain-limits
    }

    fun preparePayOnchain(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-pay-onchain
        try {
            val amount = PayOnchainAmount.Receiver(5_000.toULong())
            val prepareRequest = PreparePayOnchainRequest(amount)
            val prepareResponse = sdk.preparePayOnchain(prepareRequest)

            // Check if the fees are acceptable before proceeding
            val totalFeesSat = prepareResponse.totalFeesSat;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-pay-onchain
    }

    fun preparePayOnchainDrain(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-pay-onchain-drain
        try {
            val amount = PayOnchainAmount.Drain
            val prepareRequest = PreparePayOnchainRequest(amount)
            val prepareResponse = sdk.preparePayOnchain(prepareRequest)

            // Check if the fees are acceptable before proceeding
            val totalFeesSat = prepareResponse.totalFeesSat;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-pay-onchain-drain
    }

    fun preparePayOnchainFeeRate(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-pay-onchain-fee-rate
        try {
            val amount = PayOnchainAmount.Receiver(5_000.toULong())
            val optionalSatPerVbyte = 21

            val prepareRequest = PreparePayOnchainRequest(amount, optionalSatPerVbyte.toUInt())
            val prepareResponse = sdk.preparePayOnchain(prepareRequest)

            // Check if the fees are acceptable before proceeding
            val claimFeesSat = prepareResponse.claimFeesSat;
            val totalFeesSat = prepareResponse.totalFeesSat;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-pay-onchain-fee-rate
    }

    fun startReverseSwap(sdk: BindingLiquidSdk, prepareResponse: PreparePayOnchainResponse) {
        // ANCHOR: start-reverse-swap
        val address = "bc1.."
        try {
            sdk.payOnchain(PayOnchainRequest(address, prepareResponse))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: start-reverse-swap
    }
}
