package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ReceiveOnchain {
    fun generateReceiveOnchainAddress(sdk: BindingLiquidSdk) {
        // ANCHOR: generate-receive-onchain-address
        try {
            // Fetch the Onchain Receive limits
            val currentLimits = sdk.fetchOnchainLimits()
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}")

            // Set the amount you wish the payer to send, which should be within the above limits
            val prepareResponse = sdk.prepareReceiveOnchain(PrepareReceiveOnchainRequest(50_000.toULong()))

            // If the fees are acceptable, continue to create the Onchain Receive Payment
            val receiveFeesSat = prepareResponse.feesSat

            val receiveOnchainResponse = sdk.receiveOnchain(prepareResponse)

            // Send your funds to the bellow bitcoin address
            val address = receiveOnchainResponse.address
            val bip21 = receiveOnchainResponse.bip21
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: generate-receive-onchain-address
    }

    fun listRefundables(sdk: BindingLiquidSdk) {
        // ANCHOR: list-refundables
        try {
            val refundables = sdk.listRefundables()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-refundables
    }

    fun executeRefund(sdk: BindingLiquidSdk, refundTxFeeRate: UInt, refundable: RefundableSwap) {
        // ANCHOR: execute-refund
        val destinationAddress = "..."
        val satPerVbyte = refundTxFeeRate
        try {
            sdk.refund(RefundRequest(refundable.swapAddress, destinationAddress, satPerVbyte))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: execute-refund
    }

    fun rescanSwaps(sdk: BindingLiquidSdk) {
      // ANCHOR: rescan-swaps
      try {
          sdk.rescanOnchainSwaps()
      } catch (e: Exception) {
          // handle error
      }
      // ANCHOR_END: rescan-swaps
  }
}