package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ListPayments {
    fun getPayment(sdk: BindingLiquidSdk) {
        // ANCHOR: get-payment
        try {
            val paymentHash = "<payment hash>";
            val payment = sdk.getPayment(GetPaymentRequest.Lightning(paymentHash))
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
}