use std::sync::Arc;

use anyhow::Result;
use breez_liquid_sdk::prelude::*;

async fn generate_receive_onchain_address(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: generate-receive-onchain-address
    // Set the amount you wish the payer to send
    let prepare_response = sdk
        .prepare_receive_onchain(&PrepareReceiveOnchainRequest {
            amount_sat: 50_000,
        }).await?;

    // If the fees are acceptable, continue to create the Onchain Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;

    let receive_onchain_response = sdk.receive_onchain(
        &ReceiveOnchainRequest {
            prepare_res: prepare_response
        }
    ).await?;

    // Send your funds to the below bitcoin address
    let address = receive_onchain_response.address;
    let bip21 = receive_onchain_response.bip21;
    // ANCHOR_END: generate-receive-onchain-address

    Ok(())
}

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