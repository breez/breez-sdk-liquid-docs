package com.example.kotlinmpplib

import breez_liquid_sdk.*
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
            val prepareRequest = PreparePayOnchainRequest(5_000.toULong())
            val prepareRes = sdk.preparePayOnchain(prepareRequest)

            // Check if the fees are acceptable before proceeding
            val feesSat = prepareRes.feesSat;
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-pay-onchain
    }

    fun startReverseSwap(sdk: BindingLiquidSdk, prepareRes: PreparePayOnchainResponse) {
        // ANCHOR: start-reverse-swap
        val address = "bc1.."
        try {
            sdk.payOnchain(PayOnchainRequest(address, prepareRes))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: start-reverse-swap
    }
}