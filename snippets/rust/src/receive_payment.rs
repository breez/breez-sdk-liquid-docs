use std::sync::Arc;

use anyhow::{anyhow, Result};
use breez_sdk_liquid::prelude::*;
use log::info;

async fn receive_payment(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: receive-payment
    // Fetch the Receive lightning limits
    let current_limits = sdk.fetch_lightning_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payer_amount_sat: Some(5_000),
            payment_method: PaymentMethod::Lightning,
        })
        .await?;

    // Fetch the Receive onchain limits
    let current_limits = sdk.fetch_onchain_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payer_amount_sat: Some(5_000),
            payment_method: PaymentMethod::BitcoinAddress,
        })
        .await?;

    // Or simply create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payer_amount_sat: Some(5_000), // Not specifying the amount will create a plain Liquid address instead
            payment_method: PaymentMethod::LiquidAddress,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let _receive_fees_sat = prepare_response.fees_sat;

    let optional_description = Some("<description>".to_string());
    let res = sdk
        .receive_payment(&ReceivePaymentRequest {
            prepare_response,
            description: optional_description,
        })
        .await?;

    match parse(&res.destination).await {
        Ok(InputType::Bolt11 { .. }) => {}
        Ok(InputType::BitcoinAddress { .. }) => {}
        Ok(InputType::LiquidAddress { .. }) => {}
        _ => {
            anyhow!("Unexpected destination: {}", res.destination);
        }
    };
    // ANCHOR_END: receive-payment

    Ok(())
}
