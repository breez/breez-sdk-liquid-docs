use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn fetch_onchain_limits(sdk: Arc<LiquidSdk>) -> Result<OnchainPaymentLimitsResponse> {
    // ANCHOR: onchain-limits
    let current_limits = sdk.fetch_onchain_limits().await?;

    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);
    // ANCHOR_END: onchain-limits
    Ok(current_limits)
}

async fn prepare_buy_bitcoin(
    sdk: Arc<LiquidSdk>,
    current_limits: OnchainPaymentLimitsResponse,
) -> Result<PrepareBuyBitcoinResponse> {
    // ANCHOR: prepare-buy-btc
    let prepare_response = sdk
        .prepare_buy_bitcoin(PrepareBuyBitcoinRequest {
            provider: BuyBitcoinProvider::Moonpay,
            amount_sat: current_limits.receive.min_sat,
        })
        .await?;

    // Check the fees are acceptable before proceeding
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    // ANCHOR_END: prepare-buy-btc
    Ok(prepare_response)
}

async fn buy_bitcoin(
    sdk: Arc<LiquidSdk>,
    prepare_response: PrepareBuyBitcoinResponse,
) -> Result<String> {
    // ANCHOR: buy-btc
    let url = sdk.buy_bitcoin(BuyBitcoinRequest {
        prepare_response,
        redirect_url: None,
    })
    .await?;
    // ANCHOR_END: buy-btc
    Ok(url)
}
