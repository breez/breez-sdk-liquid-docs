package com.example.kotlinmpplib

import breez_liquid_sdk.*
class SendOnchain {
    fun getCurrentRevSwapLimits(sdk: BindingLiquidSdk) {
        // ANCHOR: get-current-pay-onchain-limits
        try {
            val currentLimits = sdk.onchainPaymentLimits()
            // Log.v("Breez", "Minimum amount, in sats: ${currentLimits.minSat}")
            // Log.v("Breez", "Maximum amount, in sats: ${currentLimits.maxSat}")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: get-current-pay-onchain-limits
    }

    fun preparePayOnchain(sdk: BindingLiquidSdk, currentLimits: OnchainPaymentLimitsResponse) {
        // ANCHOR: prepare-pay-onchain
        val amountSat = currentLimits.minSat
        val satPerVbyte = 10.toUInt()
        try {
            val prepareRequest = PrepareOnchainPaymentRequest(amountSat, SwapAmountType.SEND, satPerVbyte)
            val prepareRes = sdk.prepareOnchainPayment(prepareRequest)
            // Log.v("Breez", "Sender amount: ${prepareRes.senderAmountSat} sats")
            // Log.v("Breez", "Recipient amount: ${prepareRes.recipientAmountSat} sats")
            // Log.v("Breez", "Total fees: ${prepareRes.totalFees} sats")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-pay-onchain
    }

    fun startReverseSwap(sdk: BindingLiquidSdk, prepareRes: PrepareOnchainPaymentResponse) {
        // ANCHOR: start-reverse-swap
        val address = "bc1.."
        try {
            sdk.payOnchain(PayOnchainRequest(address, prepareRes))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: start-reverse-swap
    }

    fun checkRevSwapStatus(sdk: BindingLiquidSdk) {
        // ANCHOR: check-reverse-swaps-status
        for (rs in sdk.inProgressOnchainPayments()) {
            // Log.v("Breez", "Onchain payment ${rs.id} in progress, status is ${rs.status}")
        }
        // ANCHOR_END: check-reverse-swaps-status
    }
}