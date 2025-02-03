use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn prepare_receive_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-receive-payment-asset
    // Create a Liquid BIP21 URI/address to receive an asset payment to.
    // Note: Not setting the amount will generate an amountless BIP21 URI.
    let usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let optional_amount = Some(ReceiveAmount::Asset {
        asset_id: usdt_asset_id,
        payer_amount: Some(1.50),
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
    // ANCHOR_END: prepare-receive-payment-asset
    Ok(())
}

async fn prepare_send_payment_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-asset
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let destination = "<Liquid BIP21 or address>".to_string();
    // If the destination is an address or an amountless BIP21 URI,
    // you must specifiy an asset amount
    let usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let optional_amount = Some(PayAmount::Asset {
        asset_id: usdt_asset_id,
        receiver_amount: Some(1.50),
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-asset
    Ok(())
}

async fn configure_asset_metadata() -> Result<Arc<LiquidSdk>> {
    // ANCHOR: configure-asset-metadata
    // Create the default config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure asset metadata
    config.asset_metadata = Some(vec![
        AssetMetadata {
            asset_id: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec".to_string(),
            name: "PEGx EUR".to_string(),
            ticker: "EURx".to_string(),
            precision: 8,
        },
    ]);
    // ANCHOR_END: configure-asset-metadata
    Ok(sdk)
}

async fn fetch_asset_balance(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: fetch-asset-balance
    let info = sdk.get_info().await?;
    let asset_balances = info.wallet_info.asset_balances;
    // ANCHOR_END: fetch-asset-balance

    Ok(())
}
