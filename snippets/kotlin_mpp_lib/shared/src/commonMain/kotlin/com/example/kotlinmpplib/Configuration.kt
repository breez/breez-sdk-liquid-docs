package com.example.kotlinmpplib

import breez_sdk_liquid.*
class Configuration {
    fun configureAssetMetadata() {
        // ANCHOR: configure-asset-metadata
        // Create the default config
        val config : Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")

        // Configure asset metadata. Setting the optional fiat ID will enable
        // paying fees using the asset (if available).
        config.assetMetadata = listOf(
            AssetMetadata(
                assetId = "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
                name = "PEGx EUR",
                ticker = "EURx",
                precision = 8.toUByte(),
                fiatId = "EUR"
            )
        )
        // ANCHOR_END: configure-asset-metadata
    }

    fun configureParsers() {
        // ANCHOR: configure-external-parser
        // Create the default config
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
        // ANCHOR_END: configure-external-parser
    }
    
    fun configureMagicRoutingHints() {
        // ANCHOR: configure-magic-routing-hints
        // Create the default config
        val config : Config = defaultConfig(LiquidNetwork.MAINNET, "<your Breez API key>")

        // Configure magic routing hints
        config.useMagicRoutingHints = false
        // ANCHOR_END: configure-magic-routing-hints
    }
}
