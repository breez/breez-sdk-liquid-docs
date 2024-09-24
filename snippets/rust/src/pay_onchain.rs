use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn get_current_limits(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: get-current-pay-onchain-limits
    let current_limits = sdk.fetch_onchain_limits().await?;

    info!("Minimum amount: {} sats", current_limits.send.min_sat);
    info!("Maximum amount: {} sats", current_limits.send.max_sat);
    // ANCHOR_END: get-current-pay-onchain-limits

    Ok(())
}

async fn prepare_pay_onchain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-pay-onchain
    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayOnchainAmount.Receiver {
                amount_sat: 5_000,
            },
            sat_per_vbyte: None,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let total_fees_sat = prepare_res.total_fees_sat;
    // ANCHOR_END: prepare-pay-onchain

    Ok(())
}

async fn prepare_pay_onchain_drain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-pay-onchain-drain
    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayOnchainAmount.Drain,
            sat_per_vbyte: None,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let total_fees_sat = prepare_res.total_fees_sat;
    // ANCHOR_END: prepare-pay-onchain-drain

    Ok(())
}

async fn prepare_pay_onchain_fee_rate(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-pay-onchain-fee-rate
    let optional_sat_per_vbyte = Some(21);

    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayOnchainAmount.Receiver {
                amount_sat: 5_000,
            },
            sat_per_vbyte: optional_sat_per_vbyte,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let claim_fees_sat = prepare_res.claim_fees_sat;
    let total_fees_sat = prepare_res.total_fees_sat;
    // ANCHOR_END: prepare-pay-onchain-fee-rate

    Ok(())
}

async fn start_reverse_swap(
    sdk: Arc<LiquidSdk>,
    prepare_response: PreparePayOnchainResponse,
) -> Result<()> {
    // ANCHOR: start-reverse-swap
    let destination_address = String::from("bc1..");

    sdk.pay_onchain(&PayOnchainRequest {
        address: destination_address,
        prepare_response,
    })
    .await?;
    // ANCHOR_END: start-reverse-swap

    Ok(())
}
