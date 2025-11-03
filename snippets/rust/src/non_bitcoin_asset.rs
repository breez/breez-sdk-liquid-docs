use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn prepare_receive_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-receive-payment-asset
    // Create a Liquid BIP21 URI/address to receive an asset payment to.
    // Note: Not setting the amount will generate an amountless BIP21 URI.
    let usdt_asset_id =
        "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
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
    // you must specify an asset amount
    let usdt_asset_id =
        "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let optional_amount = Some(PayAmount::Asset {
        to_asset: usdt_asset_id,
        from_asset: None,
        receiver_amount: 1.50,
        estimate_asset_fees: Some(false),
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination,
            amount: optional_amount,
            disable_mrh: None,
            payment_timeout_sec: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {:?} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-asset
    Ok(())
}

async fn prepare_send_payment_asset_fees(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-send-payment-asset-fees
    let destination = "<Liquid BIP21 or address>".to_string();
    let usdt_asset_id =
        "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    // Set the optional estimate asset fees param to true
    let optional_amount = Some(PayAmount::Asset {
        to_asset: usdt_asset_id,
        from_asset: None,
        receiver_amount: 1.50,
        estimate_asset_fees: Some(true),
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination,
            amount: optional_amount,
            disable_mrh: None,
            payment_timeout_sec: None,
        })
        .await?;

    // If the asset fees are set, you can use these fees to pay to send the asset
    let send_asset_fees = prepare_response.estimated_asset_fees;
    info!("Estimated Fees: ~{:?}", send_asset_fees);

    // If the asset fess are not set, you can use the sats fees to pay to send the asset
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {:?} sats", send_fees_sat);
    // ANCHOR_END: prepare-send-payment-asset-fees
    Ok(())
}

async fn send_self_payment_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: send-self-payment-asset
    // Create a Liquid address to receive to
    let prepare_receive_res = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::LiquidAddress,
            amount: None,
        })
        .await?;
    let receive_res = sdk
        .receive_payment(&ReceivePaymentRequest {
            prepare_response: prepare_receive_res,
            description: None,
            use_description_hash: None,
            payer_note: None,
        })
        .await?;

    // Swap your funds to the address we've created
    let usdt_asset_id =
        "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let btc_asset_id =
        "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d".to_string();
    let prepare_send_res = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: receive_res.destination,
            amount: Some(PayAmount::Asset {
                to_asset: usdt_asset_id,
                // We want to receive 1.5 USDt
                receiver_amount: 1.5,
                estimate_asset_fees: None,
                from_asset: Some(btc_asset_id),
            }),
            disable_mrh: None,
            payment_timeout_sec: None,
        })
        .await?;
    let payment = sdk
        .send_payment(&SendPaymentRequest {
            prepare_response: prepare_send_res,
            use_asset_fees: None,
            payer_note: None,
        })
        .await?;
    // ANCHOR_END: send-self-payment-asset
    dbg!(payment);
    Ok(())
}

async fn send_payment_fees(
    sdk: Arc<LiquidSdk>,
    prepare_response: PrepareSendResponse,
) -> Result<()> {
    // ANCHOR: send-payment-fees
    // Set the use asset fees param to true
    let send_response = sdk
        .send_payment(&SendPaymentRequest {
            prepare_response,
            payer_note: None,
            use_asset_fees: Some(true),
        })
        .await?;
    let payment = send_response.payment;
    // ANCHOR_END: send-payment-fees
    dbg!(payment);
    Ok(())
}

async fn fetch_asset_balance(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: fetch-asset-balance
    let info = sdk.get_info().await?;
    let asset_balances = info.wallet_info.asset_balances;
    // ANCHOR_END: fetch-asset-balance

    Ok(())
}
