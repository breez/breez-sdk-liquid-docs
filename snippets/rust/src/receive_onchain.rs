use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn list_refundables(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: list-refundables
    let refundables = sdk.list_refundables().await?;
    // ANCHOR_END: list-refundables

    Ok(())
}

async fn execute_refund(
    sdk: Arc<LiquidSdk>,
    refund_tx_fee_rate: u32,
    refundable: RefundableSwap,
) -> Result<()> {
    // ANCHOR: execute-refund
    let destination_address = "...".into();
    let sat_per_vbyte = refund_tx_fee_rate;

    sdk.refund(&RefundRequest {
        swap_address: refundable.swap_address,
        refund_address: destination_address,
        sat_per_vbyte,
    })
    .await?;
    // ANCHOR_END: execute-refund

    Ok(())
}

async fn rescan_swaps(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: rescan-swaps
    sdk.rescan_onchain_swaps().await?;
    // ANCHOR_END: rescan-swaps

    Ok(())
}
