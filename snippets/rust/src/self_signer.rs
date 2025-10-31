use std::sync::Arc;
use std::path::PathBuf;
use std::fs;

use anyhow::Result;
use bip39::{Language, Mnemonic};
use breez_sdk_liquid::prelude::*;
use log::{info};

// ANCHOR: self-signer  
async fn connect_with_self_signer(signer: Signer) -> Result<Arc<LiquidSdk>> {  
  // Create the default config, providing your Breez API key
  let mut config = LiquidSdk::default_config(LiquidNetwork::Mainnet, Some("<your-Breez-API-key>".to_string()))?;

  // Customize the config object according to your needs
  config.working_dir = "path to an existing directory".into();

  let connect_request = ConnectWithSignerRequest {      
      config,
  };
  let sdk = LiquidSdk::connect_with_signer(connect_request, signer, None).await?;

  Ok(sdk)
}
// ANCHOR_END: self-signer