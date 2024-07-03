use std::sync::Arc;

use anyhow::Result;
use breez_liquid_sdk::prelude::*;
use log::info;

async fn receive_payment(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: receive-payment
    // Fetch the Receive limits
    let current_limits = sdk.fetch_lightning_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the amount you wish the payer to send, which should be within the above limits
    let prepare_receive_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payer_amount_sat: 5_000,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_receive_response.fees_sat;

    let receive_payment_response = sdk.receive_payment(&prepare_receive_response).await?;

    let invoice = receive_payment_response.invoice;
    // ANCHOR_END: receive-payment

    Ok(())
}
