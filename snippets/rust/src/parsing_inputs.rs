use anyhow::Result;
use bip39::{Language, Mnemonic};
use breez_sdk_liquid::model::{ConnectRequest, LiquidNetwork};
use breez_sdk_liquid::prelude::LiquidSdk;
use breez_sdk_liquid::{ExternalInputParser, InputType};
use std::sync::Arc;

async fn parse_input(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: parse-inputs
    let input = "an input to be parsed...";

    match sdk.parse(input).await? {
        InputType::BitcoinAddress { address } => {
            println!("Input is Bitcoin address {}", address.address);
        }
        InputType::Bolt11 { invoice } => {
            println!(
                "Input is BOLT11 invoice for {} msats",
                invoice
                    .amount_msat
                    .map_or("unknown".to_string(), |a| a.to_string())
            );
        }
        InputType::LnUrlPay { data } => {
            println!(
                "Input is LNURL-Pay/Lightning address accepting min/max {}/{} msats",
                data.min_sendable, data.max_sendable
            );
        }
        InputType::LnUrlWithdraw { data } => {
            println!(
                "Input is LNURL-Withdraw for min/max {}/{} msats",
                data.min_withdrawable, data.max_withdrawable
            );
        }
        // Other input types are available
        _ => {}
    }
    // ANCHOR_END: parse-inputs
    Ok(())
}

async fn configure_parsers() -> Result<Arc<LiquidSdk>> {
    // ANCHOR: configure-external-parser
    let mnemonic = Mnemonic::generate_in(Language::English, 12)?;

    // Create the default config, providing your Breez API key
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

    let connect_request = ConnectRequest {
        mnemonic: mnemonic.to_string(),
        config,
    };
    let sdk = LiquidSdk::connect(connect_request).await?;
    // ANCHOR_END: configure-external-parser
    Ok(sdk)
}
