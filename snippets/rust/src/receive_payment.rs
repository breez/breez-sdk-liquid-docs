use std::sync::Arc;

use anyhow::Result;
use breez_liquid_sdk::prelude::*;

async fn receive_payment(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: receive-payment
    // Set the amount you wish the payer to send
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
