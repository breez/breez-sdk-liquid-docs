use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn prepare_receive_lightning(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-receive-payment-lightning
    // Fetch the Receive lightning limits
    let current_limits = sdk.fetch_lightning_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::Lightning,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    // ANCHOR_END: prepare-receive-payment-lightning
    Ok(())
}

async fn prepare_receive_onchain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-receive-payment-onchain
    // Fetch the Receive onchain limits
    let current_limits = sdk.fetch_onchain_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::BitcoinAddress,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    // ANCHOR_END: prepare-receive-payment-onchain
    Ok(())
}

async fn prepare_receive_liquid(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-receive-payment-liquid
    // Create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    // Note: Not setting the amount will generate a plain Liquid address
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::LiquidAddress,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    // ANCHOR_END: prepare-receive-payment-liquid
    Ok(())
}

async fn receive_payment(
    sdk: Arc<LiquidSdk>,
    prepare_response: PrepareReceiveResponse,
) -> Result<()> {
    // ANCHOR: receive-payment
    let optional_description = Some("<description>".to_string());
    let res = sdk
        .receive_payment(&ReceivePaymentRequest {
            prepare_response,
            description: optional_description,
            use_description_hash: None,
        })
        .await?;

    let destination = res.destination;
    // ANCHOR_END: receive-payment
    dbg!(destination);
    Ok(())
}
