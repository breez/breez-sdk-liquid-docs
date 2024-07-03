package com.example.kotlinmpplib

import breez_liquid_sdk.*
class ReceiveOnchain {
    fun generateReceiveOnchainAddress(sdk: BindingLiquidSdk) {
        // ANCHOR: generate-receive-onchain-address
        try {
            val swapInfo = sdk.receiveOnchain(ReceiveOnchainRequest())
            // Send your funds to the bellow bitcoin address
            val address = swapInfo.bitcoinAddress
            // Log.v("Breez", "Minimum amount allowed to deposit in sats: ${swapInfo.minAllowedDeposit}")
            // Log.v("Breez", "Maximum amount allowed to deposit in sats: ${swapInfo.maxAllowedDeposit}")            
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: generate-receive-onchain-address
    }

    fun inProgressSwap(sdk: BindingLiquidSdk) {
        // ANCHOR: in-progress-swap
        try {
            val swapInfo = sdk.inProgressSwap()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: in-progress-swap
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

    fun executeRefund(sdk: BindingLiquidSdk) {
        // ANCHOR: execute-refund
        val swapAddress = "..."
        val toAddress = "..."
        val satPerVbyte = 1.toUInt()
        try {
            sdk.refund(RefundRequest(swapAddress, toAddress, satPerVbyte))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: execute-refund
    }

    fun getChannelOpeningFees(sdk: BindingLiquidSdk) {
        // ANCHOR: get-channel-opening-fees
        try {
            val amountMsat = 5_000.toULong();
            val channelFees = sdk.openChannelFee(OpenChannelFeeRequest(amountMsat))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: get-channel-opening-fees
    }

    fun rescanSwaps(sdk: BindingLiquidSdk) {
      // ANCHOR: rescan-swaps
      try {
          sdk.rescanSwaps()
      } catch (e: Exception) {
          // handle error
      }
      // ANCHOR_END: rescan-swaps
  }
}