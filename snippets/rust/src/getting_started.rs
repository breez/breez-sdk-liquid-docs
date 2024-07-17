use std::sync::Arc;

use anyhow::Result;
use bip39::{Language, Mnemonic};
use breez_sdk_liquid::prelude::*;

async fn getting_started() -> Result<Arc<LiquidSdk>> {
    // ANCHOR: init-sdk
    let mnemonic = Mnemonic::generate_in(Language::English, 12)?;

    // Create the default config
    let mut config = LiquidSdk::default_config(LiquidNetwork::Mainnet);

    // Customize the config object according to your needs
    config.working_dir = "path to an existing directory".into();

    let connect_request = ConnectRequest {
        mnemonic: mnemonic.to_string(),
        config,
    };
    let sdk = LiquidSdk::connect(connect_request).await?;
    // ANCHOR_END: init-sdk

    Ok(sdk)
}

async fn getting_started_node_info(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: fetch-balance
    let wallet_info = sdk.get_info().await?;
    let balance_sat = wallet_info.balance_sat;
    let pending_send_sat = wallet_info.pending_send_sat;
    let pending_receive_sat = wallet_info.pending_receive_sat;
    // ANCHOR_END: fetch-balance

    Ok(())
}
