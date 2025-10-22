use anyhow::Result;
use breez_sdk_liquid::prelude::*;


fn configure_asset_metadata() -> Result<Config> {
    // ANCHOR: configure-asset-metadata
    // Create the default config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure asset metadata. Setting the optional fiat ID will enable
    // paying fees using the asset (if available).
    config.asset_metadata = Some(vec![
        AssetMetadata {
            asset_id: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec".to_string(),
            name: "PEGx EUR".to_string(),
            ticker: "EURx".to_string(),
            precision: 8,
            fiat_id: Some("EUR".to_string()),
        },
    ]);
    // ANCHOR_END: configure-asset-metadata
    Ok(config)
}

fn configure_parsers() -> Result<Config> {
    // ANCHOR: configure-external-parser
    // Create the default config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure external parsers
    config.external_input_parsers = Some(vec![
        ExternalInputParser {
            provider_id: "provider_a".to_string(),
            input_regex: "^provider_a".to_string(),
            parser_url: "https://parser-domain.com/parser?input=<input>".to_string(),
        },
        ExternalInputParser {
            provider_id: "provider_b".to_string(),
            input_regex: "^provider_b".to_string(),
            parser_url: "https://parser-domain.com/parser?input=<input>".to_string(),
        },
    ]);
    // ANCHOR_END: configure-external-parser
    Ok(config)
}

fn configure_magic_routing_hints() -> Result<Config> {
    // ANCHOR: configure-magic-routing-hints
    // Create the default config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure magic routing hints
    config.use_magic_routing_hints = false;
    // ANCHOR_END: configure-magic-routing-hints
    Ok(config)
}
