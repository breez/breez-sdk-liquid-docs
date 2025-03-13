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
                           "${inputType.data.minSendable}/${inputType.data.maxSendable} msats - BIP353 was used: ${inputType.bip353Address != null}")
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

    fun configureParsers() {
        // ANCHOR: configure-external-parser
        val mnemonic = "<mnemonic words>"

        // Create the default config, providing your Breez API key
        val config : Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")

        // Configure external parsers
        config.externalInputParsers = listOf(
            ExternalInputParser(
                providerId = "provider_a",
                inputRegex = "^provider_a",
                parserUrl = "https://parser-domain.com/parser?input=<input>"
            ),
            ExternalInputParser(
                providerId = "provider_b", 
                inputRegex = "^provider_b",
                parserUrl = "https://parser-domain.com/parser?input=<input>"
            )
        )

        try {
            val connectRequest = ConnectRequest(config, mnemonic)
            val sdk = connect(connectRequest)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: configure-external-parser
    }
}
