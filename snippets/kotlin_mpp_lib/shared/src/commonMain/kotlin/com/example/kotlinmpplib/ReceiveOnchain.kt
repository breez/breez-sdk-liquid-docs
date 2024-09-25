package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ReceiveOnchain {
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
        val feeRateSatPerVbyte = refundTxFeeRate
        try {
            sdk.refund(RefundRequest(refundable.swapAddress, destinationAddress, feeRateSatPerVbyte))
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
