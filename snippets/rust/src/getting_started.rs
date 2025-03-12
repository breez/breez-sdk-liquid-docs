use std::fs;
use std::path::PathBuf;
use std::sync::Arc;

use anyhow::Result;
use bip39::{Language, Mnemonic};
use breez_sdk_liquid::prelude::*;
use log::info;

async fn getting_started() -> Result<Arc<LiquidSdk>> {
    // ANCHOR: init-sdk
    let mnemonic = Mnemonic::generate_in(Language::English, 12)?;

    // Create the default config, providing your Breez API key
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Customize the config object according to your needs
    config.working_dir = "path to an existing directory".into();

    let connect_request = ConnectRequest {
        config,
        mnemonic: Some(mnemonic.to_string()),
        passphrase: None,
        seed: None,
    };
    let sdk = LiquidSdk::connect(connect_request).await?;
    // ANCHOR_END: init-sdk

    Ok(sdk)
}

async fn getting_started_node_info(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: fetch-balance
    let info = sdk.get_info().await?;
    let balance_sat = info.wallet_info.balance_sat;
    let pending_send_sat = info.wallet_info.pending_send_sat;
    let pending_receive_sat = info.wallet_info.pending_receive_sat;
    // ANCHOR_END: fetch-balance

    Ok(())
}

async fn getting_started_logging(data_dir: String) -> Result<()> {
    // ANCHOR: logging
    let data_dir_path = PathBuf::from(&data_dir);
    fs::create_dir_all(data_dir_path)?;

    LiquidSdk::init_logging(&data_dir, None)?;
    // ANCHOR_END: logging

    Ok(())
}

// ANCHOR: add-event-listener
struct CliEventListener {}
impl EventListener for CliEventListener {
    fn on_event(&self, e: SdkEvent) {
        info!("Received event: {:?}", e);
    }
}

async fn add_event_listener(
    sdk: Arc<LiquidSdk>,
    listener: Box<CliEventListener>,
) -> Result<String> {
    let listener_id = sdk.add_event_listener(listener).await?;
    Ok(listener_id)
}
// ANCHOR_END: add-event-listener

// ANCHOR: remove-event-listener
async fn remove_event_listener(sdk: Arc<LiquidSdk>, listener_id: String) -> Result<()> {
    sdk.remove_event_listener(listener_id).await?;
    Ok(())
}
// ANCHOR_END: remove-event-listener

// ANCHOR: disconnect
async fn disconnect(sdk: Arc<LiquidSdk>) -> Result<()> {
    sdk.disconnect().await?;
    Ok(())
}
// ANCHOR_END: disconnect
