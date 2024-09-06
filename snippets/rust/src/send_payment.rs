use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn prepare_send_payment_lightning(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-lightning
    // Set the bolt11 invoice you wish to pay
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<bolt11 invoice>".to_string(),
            amount_sat: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-lightning
    Ok(())
}

async fn prepare_send_payment_liquid(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-liquid
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optional_amount_sat = Some(5_000);
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount_sat: optional_amount_sat,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-liquid
    Ok(())
}

async fn send_payment(sdk: Arc<LiquidSdk>, prepare_response: PrepareSendResponse) -> Result<()> {
    // ANCHOR: send-payment
    let send_response = sdk
        .send_payment(&SendPaymentRequest { prepare_response })
        .await?;
    let payment = send_response.payment;
    // ANCHOR_END: send-payment
    dbg!(payment);
    Ok(())
}
