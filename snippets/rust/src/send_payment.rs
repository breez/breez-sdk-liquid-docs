use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn prepare_send_payment_lightning_bolt11(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-lightning-bolt11
    // Set the bolt11 invoice you wish to pay
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<bolt11 invoice>".to_string(),
            amount: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {:?} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-lightning-bolt11
    Ok(())
}

async fn prepare_send_payment_lightning_bolt12(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-lightning-bolt12
    // Set the bolt12 offer you wish to pay to
    let optional_amount = Some(PayAmount::Bitcoin {
        receiver_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<bolt12 offer>".to_string(),
            amount: optional_amount,
        })
        .await?;
    // ANCHOR_END: prepare-send-payment-lightning-bolt12
    Ok(())
}

async fn prepare_send_payment_liquid(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-liquid
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optional_amount = Some(PayAmount::Bitcoin {
        receiver_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {:?} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-liquid
    Ok(())
}

async fn prepare_send_payment_liquid_drain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-liquid-drain
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optional_amount = Some(PayAmount::Drain);
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {:?} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-liquid-drain
    Ok(())
}

async fn send_payment(sdk: Arc<LiquidSdk>, prepare_response: PrepareSendResponse) -> Result<()> {
    // ANCHOR: send-payment
    let send_response = sdk
        .send_payment(&SendPaymentRequest {
            prepare_response,
            use_asset_fees: None,
        })
        .await?;
    let payment = send_response.payment;
    // ANCHOR_END: send-payment
    dbg!(payment);
    Ok(())
}
