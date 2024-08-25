use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn send_payment(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: send-payment
    // Set the BOLT11 invoice you wish to pay
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "Invoice, Liquid BIP21 or address".to_string(),
            amount_sat: Some(5_000),
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let _send_fees_sat = prepare_response.fees_sat;

    let send_response = sdk
        .send_payment(&SendPaymentRequest { prepare_response })
        .await?;
    let payment = send_response.payment;
    // ANCHOR_END: send-payment

    Ok(())
}
