import BreezSDKLiquid

func configureAssetMetadata() throws {
    // ANCHOR: configure-asset-metadata
    // Create the default config
    var config = try defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Configure asset metadata. Setting the optional fiat ID will enable
    // paying fees using the asset (if available).
    config.assetMetadata = [
        AssetMetadata(
            assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            name: "PEGx EUR",
            ticker: "EURx",
            precision: 8,
            fiatId: "EUR"
        )
    ]
    // ANCHOR_END: configure-asset-metadata
}

func configureParsers() throws {
    // ANCHOR: configure-external-parser
    // Create the default config
    var config = try defaultConfig(
        network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Configure external parsers
    config.externalInputParsers = [
        ExternalInputParser(
            providerId: "provider_a",
            inputRegex: "^provider_a",
            parserUrl: "https://parser-domain.com/parser?input=<input>"
        ),
        ExternalInputParser(
            providerId: "provider_b",
            inputRegex: "^provider_b",
            parserUrl: "https://parser-domain.com/parser?input=<input>"
        ),
    ]
    // ANCHOR_END: configure-external-parser
}

func configureMagicRoutingHints() throws {
    // ANCHOR: configure-magic-routing-hints
    // Create the default config
    var config = try defaultConfig(
        network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>")

    // Configure magic routing hints
    config.useMagicRoutingHints = false
    // ANCHOR_END: configure-magic-routing-hints
}
