use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn send_payment(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: send-payment
    // Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
    let optional_amount_sat = Some(5_000);
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "Invoice, Liquid BIP21 or address".to_string(),
            amount_sat: optional_amount_sat,
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
