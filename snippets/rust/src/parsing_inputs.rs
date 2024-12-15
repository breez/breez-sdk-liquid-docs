use anyhow::Result;
use breez_sdk_liquid::prelude::LiquidSdk;
use breez_sdk_liquid::InputType;
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
