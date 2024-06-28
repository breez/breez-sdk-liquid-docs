use std::sync::Arc;

use anyhow::Result;
use breez_liquid_sdk::prelude::*;
use log::info;

async fn get_current_limits(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: get-current-pay-onchain-limits
    let current_limits = sdk.fetch_onchain_limits().await?;

    info!("Minimum amount: {} sats", current_limits.send_min_payer_amount_sat);
    info!("Maximum amount: {} sats", current_limits.send_max_payer_amount_sat);
    // ANCHOR_END: get-current-pay-onchain-limits

    Ok(())
}

async fn prepare_pay_onchain(
    sdk: Arc<LiquidSdk>,
) -> Result<()> {
    // ANCHOR: prepare-pay-onchain
    let prepare_res = sdk.prepare_pay_onchain(
        &PreparePayOnchainRequest {
            amount_sat: 5_000,
        }
    ).await?;

    // Check if the fees are acceptable before proceeding
    let fees_sat = prepare_res.fees_sat;
    // ANCHOR_END: prepare-pay-onchain

    Ok(())
}

async fn start_reverse_swap(
    sdk: Arc<LiquidSdk>,
    prepare_res: PreparePayOnchainResponse,
) -> Result<()> {
    // ANCHOR: start-reverse-swap
    let destination_address = String::from("bc1..");

    sdk.pay_onchain(&PayOnchainRequest {
        address: destination_address,
        prepare_res,
    })
    .await?;
    // ANCHOR_END: start-reverse-swap

    Ok(())
}
