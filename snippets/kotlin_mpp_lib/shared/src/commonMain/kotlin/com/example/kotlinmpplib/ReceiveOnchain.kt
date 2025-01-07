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

    fun recommendedFees(sdk: BindingLiquidSdk) {
        // ANCHOR: recommended-fees
        try {
            val fees = sdk.recommendedFees()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: recommended-fees
    }

    fun handlePaymentsWaitingFeeAcceptance(sdk: BindingLiquidSdk) {
        // ANCHOR: handle-payments-waiting-fee-acceptance
        try {
            // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
            val paymentsWaitingFeeAcceptance = sdk.listPayments(ListPaymentsRequest(
                states = listOf(PaymentState.WaitingFeeAcceptance)
            ))

            for (payment in paymentsWaitingFeeAcceptance) {
                when (val details = payment.details) {
                    is PaymentDetails.Bitcoin -> {
                        val fetchFeesResponse = sdk.fetchPaymentProposedFees(
                            FetchPaymentProposedFeesRequest(details.swapId)
                        )

                        println("Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}")

                        // If the user is ok with the fees, accept them, allowing the payment to proceed
                        sdk.acceptPaymentProposedFees(AcceptPaymentProposedFeesRequest(fetchFeesResponse))
                    }
                    else -> {
                        // Only Bitcoin payments can be `WaitingFeeAcceptance`
                        continue
                    }
                }
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: handle-payments-waiting-fee-acceptance
    }
}
