use breez_sdk_liquid::plugin::Plugin;
use breez_sdk_liquid_nwc::{
    NwcConfig,
    SdkNwcService,
    error::NwcError,
    event::{NwcEvent, NwcEventDetails, NwcEventListener},
    NwcService,
};
use std::sync::Arc;
use anyhow::Result;
use async_trait::async_trait;

async fn nostr_wallet_connect() -> Result<()> {
    // ANCHOR: nwc-config
    let nwc_config = NwcConfig {
        relay_urls: Some(vec!["<your-relay-url-1>".to_string()]),          // Optional: Custom relay URLs (uses default if None)
        secret_key_hex: Some("your-nostr-secret-key-hex".to_string()),     // Optional: Custom Nostr secret key
    };
    
    let nwc_service = Arc::new(SdkNwcService::new(nwc_config));
    
    // Add the plugin to your SDK
    let plugins: Vec<Arc<dyn Plugin>> = vec![nwc_service.clone()];
    // ANCHOR_END: nwc-config

    // ANCHOR: add-connection
    let connection_name  = "my-app-connection";
    let connection_string = nwc_service.add_connection_string(connection_name.to_string()).await?;
    // ANCHOR_END: add-connection

    // ANCHOR: list-connections
    let connections = nwc_service.list_connection_strings().await?;
    // ANCHOR_END: list-connections

    // ANCHOR: remove-connection
    nwc_service.remove_connection_string(connection_name.to_string()).await?;
    // ANCHOR_END: remove-connection

    // ANCHOR: event-listener
    struct MyNwcEventListener;

    #[async_trait]
    impl NwcEventListener for MyNwcEventListener {
        async fn on_event(&self, event: NwcEvent) {
            match event.details {
                NwcEventDetails::Connected => println!("NWC connected"),
                NwcEventDetails::Disconnected => println!("NWC disconnected"),
                NwcEventDetails::PayInvoice { success, .. } => {
                    println!("Payment {}", if success { "successful" } else { "failed" });
                }
                NwcEventDetails::ListTransactions => println!("Transactions requested"),
                NwcEventDetails::GetBalance => println!("Balance requested"),
            }
        }
    }
    // ANCHOR_END: event-listener

    // ANCHOR: event-management
    // Add event listener
    let listener = Box::new(MyNwcEventListener);
    let listener_id = nwc_service.add_event_listener(listener).await;

    // Remove event listener when no longer needed
    nwc_service.remove_event_listener(&listener_id).await;
    // ANCHOR_END: event-management

    // ANCHOR: error-handling
    match nwc_service.add_connection_string("test".to_string()).await {
        Ok(connection_string) => println!("Connection created: {}", connection_string),
        Err(NwcError::Generic { err }) => eprintln!("Generic error: {}", err),
        Err(NwcError::Persist { err }) => eprintln!("Persistence error: {}", err),
    }
    // ANCHOR_END: error-handling
    
    Ok(())
}