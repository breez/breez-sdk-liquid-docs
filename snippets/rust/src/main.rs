mod configuration;
mod fiat_currencies;
mod getting_started;
mod list_payments;
mod lnurl_auth;
mod lnurl_pay;
mod lnurl_withdraw;
mod non_bitcoin_asset;
mod nostr_wallet_connect;
mod parsing_inputs;
mod pay_onchain;
mod plugins;
mod receive_onchain;
mod receive_payment;
mod send_payment;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use log::info;
use async_trait::async_trait;

struct AppEventListener {}

#[async_trait]
impl EventListener for AppEventListener {
    async fn on_event(&self, e: SdkEvent) {
        info!("Received Breez event: {e:?}");
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    Ok(())
}
