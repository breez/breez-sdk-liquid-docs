use breez_sdk_liquid::prelude::*;
use breez_sdk_liquid::error::SdkError;
use breez_sdk_liquid_nwc::{NwcConfig, SdkNwcService};
use std::sync::Arc;
use std::sync::Weak;
use async_trait::async_trait;

pub fn create_nwc_config() -> NwcConfig {
  NwcConfig {
    relay_urls: Some(vec!["<your-relay-url-1>".to_string()]),
    secret_key_hex: None,
  }
}

pub fn create_sdk_config() -> Result<Config, SdkError> {
  let mut config = LiquidSdk::default_config(LiquidNetwork::Testnet, None)?;
  config.working_dir = "path to an existing directory".into();
  Ok(config)
}

pub fn create_connect_request(config: Config) -> ConnectRequest {
  ConnectRequest {
    config,
    mnemonic: Some("<your-mnemonic-here>".to_string()),
    passphrase: None,
    seed: None,
  }
}

pub async fn connect_with_nwc_plugin() -> Result<Arc<LiquidSdk>, SdkError> {
  //ANCHOR: create-plugin-config
  // Create Plugin Config
  let nwc_config = create_nwc_config(); 

  // Initialize Plugin
  let nwc_service = SdkNwcService::new(nwc_config);
  
  // Create SDK Config
  let config = create_sdk_config()?;
  let plugins: Vec<Arc<dyn Plugin>> = vec![Arc::new(nwc_service)];
  
  // Create Connect Request
  let connect_request = create_connect_request(config);
  
  // Connect to the SDK with the plugins
  let sdk = LiquidSdk::connect(connect_request, Some(plugins)).await?;
  //ANCHOR_END: create-plugin-config
  Ok(sdk)
}

//ANCHOR: my-custom-plugin
struct MyPlugin {}

#[async_trait]
impl Plugin for MyPlugin {
  fn id(&self) -> String {
    // Return the unique identifier for your plugin
    "my-custom-plugin".to_string()
  }

  async fn on_start(&self, sdk: Weak<LiquidSdk>, storage: PluginStorage) {
    // Initialize your plugin here
  }

  async fn on_stop(&self) {
    // Cleanup your plugin here
  }
}
//ANCHOR_END: my-custom-plugin