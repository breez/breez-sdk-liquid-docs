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
        InputType::Bolt12Offer { offer, bip353_address } => {
            println!(
                "Input is BOLT12 offer for min {:?} msats - BIP353 was used: {}",
                offer.min_amount,
                bip353_address.is_some()
            );
        }
        InputType::LnUrlPay { data, bip353_address } => {
            println!(
                "Input is LNURL-Pay/Lightning address accepting min/max {}/{} msats - BIP353 was used: {}",
                data.min_sendable, data.max_sendable, bip353_address.is_some()
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
