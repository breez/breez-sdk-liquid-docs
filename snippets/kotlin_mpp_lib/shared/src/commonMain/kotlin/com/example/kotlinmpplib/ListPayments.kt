package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ListPayments {
    fun getPayment(sdk: BindingLiquidSdk) {
        // ANCHOR: get-payment
        try {
            val paymentHash = "<payment hash>";
            val paymentByHash = sdk.getPayment(GetPaymentRequest.PaymentHash(paymentHash))

            val swapId = "<swap id>";
            val paymentBySwapId = sdk.getPayment(GetPaymentRequest.SwapId(swapId))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: get-payment
    }

    fun listPayments(sdk: BindingLiquidSdk) {
        // ANCHOR: list-payments
        try {
            val payments = sdk.listPayments(ListPaymentsRequest())
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-payments
    }

    fun listPaymentsFiltered(sdk: BindingLiquidSdk) {
        // ANCHOR: list-payments-filtered
        try {
            val payments = sdk.listPayments(
                ListPaymentsRequest(
                    listOf(PaymentType.SEND),
                    fromTimestamp = 1696880000,
                    toTimestamp = 1696959200,
                    offset = 0u,
                    limit = 50u
                ))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-payments-filtered
    }

    fun listPaymentsDetailsAddress(sdk: BindingLiquidSdk) {
        // ANCHOR: list-payments-details-address
        try {
            val address = "<Bitcoin address>"
            val payments = sdk.listPayments(
                ListPaymentsRequest(
                    details = ListPaymentDetails.Bitcoin(address)
                ))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-payments-details-address
    }

    fun listPaymentsDetailsDestination(sdk: BindingLiquidSdk) {
        // ANCHOR: list-payments-details-destination
        try {
            val destination = "<Liquid BIP21 or address>"
            val payments = sdk.listPayments(
                ListPaymentsRequest(
                    details = ListPaymentDetails.Liquid(assetId = null, destination = destination)
                ))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-payments-details-destination
    }
}
