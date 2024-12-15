package com.example.kotlinmpplib

import breez_sdk_liquid.*
class ParsingInputs {
    fun parseInput(sdk: BindingLiquidSdk) {
        // ANCHOR: parse-inputs
        val input = "an input to be parsed..."

        try {
            val inputType = sdk.parse(input)
            when (inputType) {
                is InputType.BitcoinAddress -> {
                    println("Input is Bitcoin address ${inputType.address.address}")
                }
                is InputType.Bolt11 -> {
                    val amountStr = inputType.invoice.amountMsat?.toString() ?: "unknown"
                    println("Input is BOLT11 invoice for $amountStr msats")
                }
                is InputType.LnUrlPay -> {
                    println("Input is LNURL-Pay/Lightning address accepting min/max " +
                           "${inputType.data.minSendable}/${inputType.data.maxSendable} msats")
                }
                is InputType.LnUrlWithdraw -> {
                    println("Input is LNURL-Withdraw for min/max " +
                           "${inputType.data.minWithdrawable}/${inputType.data.maxWithdrawable} msats")
                }
                else -> {
                    // Handle other input types
                } 
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: parse-inputs
    }
}
