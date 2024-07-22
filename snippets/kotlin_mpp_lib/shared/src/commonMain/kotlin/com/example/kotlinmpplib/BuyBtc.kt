package com.example.kotlinmpplib

import breez_sdk_liquid.*

class BuyBtc {
    fun fetchOnchainLimits(sdk: BindingLiquidSdk) {
        // ANCHOR: onchain-limits
        try {
            val currentLimits = sdk.fetchOnchainLimits()
            // Log.v("Breez", "Minimum amount, in sats: ${currentLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount, in sats: ${currentLimits.receive.maxSat}")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: onchain-limits
    }

    fun prepareBuyBtc(sdk: BindingLiquidSdk, currentLimits: OnchainPaymentLimitsResponse) {
        // ANCHOR: prepare-buy-btc
        try {
            val req = PrepareBuyBitcoinRequest(BuyBitcoinProvider.MOONPAY, currentLimits.receive.minSat)
            val prepareRes = sdk.prepareBuyBitcoin(req)

            // Check the fees are acceptable before proceeding
            val receiveFeesSat = prepareRes.feesSat;
            // Log.v("Breez", "Fees: ${receiveFeesSat} sats")
        } catch (e: Exception) {
            // Handle error
        }
        // ANCHOR_END: prepare-buy-btc
    }

    fun buyBtc(sdk: BindingLiquidSdk, prepareRes: PrepareBuyBitcoinResponse) {
        // ANCHOR: buy-btc
        try {
            val req = BuyBitcoinRequest(prepareRes)
            val url = sdk.buyBitcoin(req)
        } catch (e: Exception) {
            // Handle error
        }
        // ANCHOR_END: buy-btc
    }
}