mod fiat_currencies;
mod getting_started;
mod list_payments;
mod lnurl_auth;
mod lnurl_pay;
mod lnurl_withdraw;
mod pay_onchain;
mod receive_onchain;
mod receive_payment;
mod send_payment;

use anyhow::Result;
use breez_liquid_sdk::prelude::*;
use log::info;

struct AppEventListener {}
impl EventListener for AppEventListener {
    fn on_event(&self, e: LiquidSdkEvent) {
        info!("Received Breez event: {e:?}");
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    Ok(())
}
