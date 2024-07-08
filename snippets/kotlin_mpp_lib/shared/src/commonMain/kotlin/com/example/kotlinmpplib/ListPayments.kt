package com.example.kotlinmpplib

import breez_liquid_sdk.*
class ListPayments {
    fun listPayments(sdk: BindingLiquidSdk) {
        // ANCHOR: list-payments
        try {
            val payments = sdk.listPayments()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-payments
    }

}