async fn nostr_wallet_connect(network: LiquidNetwork, breez_api_key: Option<String>) -> Result<(), SdkError> {
    // ANCHOR: init-nwc
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    config.enable_nwc = true;

    // Optional: You can specify your own Relay URLs
    config.nwc_relay_urls = vec![
        "<your-relay-url-1>".to_string(),
    ];
    // ANCHOR_END: init-nwc

    // ANCHOR: create-connection-string
    let nwc_connection_uri = sdk.get_nwc_uri().await?;
    // ANCHOR_END: create-connection-string
    
    Ok(())
}