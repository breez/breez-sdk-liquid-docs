use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::sdk::LiquidSdk;

use breez_sdk_liquid::plugin::Plugin;
use breez_sdk_liquid_nwc::{
    model::{AddConnectionRequest, NwcConfig},
    NwcService, SdkNwcService,
};

async fn nwc_connect(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: connecting
    use breez_sdk_liquid::plugin::Plugin;
    use breez_sdk_liquid_nwc::{model::NwcConfig, SdkNwcService};

    let nwc_config = NwcConfig {
        relay_urls: None,
        secret_key_hex: None,
        listen_to_events: None,
    };
    let nwc_service = Arc::new(SdkNwcService::new(nwc_config));
    sdk.start_plugin(nwc_service.clone()).await;

    // ...

    // Automatically stops the plugin
    sdk.disconnect();
    // Alternatively, you can stop the plugin manually, without disconnecting the SDK
    nwc_service.on_stop();
    // ANCHOR_END: connecting
    Ok(())
}

async fn nwc_connections(nwc_service: Arc<SdkNwcService>) -> Result<()> {
    // ANCHOR: add-connection
    use breez_sdk_liquid_nwc::model::{AddConnectionRequest, PeriodicBudgetRequest};

    // This connection will only allow spending at most 10_000 sats/hour
    let periodic_budget_req = PeriodicBudgetRequest {
        max_budget_sat: 10000,
        renewal_time_mins: Some(60), // Renews every hour
    };
    nwc_service
        .add_connection(AddConnectionRequest {
            name: "my new connection".to_string(),
            expiry_time_mins: Some(60), // Expires after one hour
            periodic_budget_req: Some(periodic_budget_req),
            receive_only: None, // Defaults to false
        })
        .await?;
    // ANCHOR_END: add-connection

    // ANCHOR: edit-connection
    use breez_sdk_liquid_nwc::model::EditConnectionRequest;

    let new_expiry_time = 60 * 24;
    nwc_service
        .edit_connection(EditConnectionRequest {
            name: "my new connection".to_string(),
            expiry_time_mins: Some(new_expiry_time), // The connection will now expire after 1 day
            periodic_budget_req: None,
            receive_only: None,
            remove_expiry: None,
            remove_periodic_budget: Some(true), // The periodic budget has been removed
        })
        .await?;
    // ANCHOR_END: edit-connection

    // ANCHOR: list-connections
    let connections = nwc_service.list_connections().await?;
    for (connection_name, connection) in connections {
        println!(
            "Connection: {} - Expires at: {:?}, Periodic Budget: {:?}",
            connection_name, connection.expires_at, connection.periodic_budget
        );
        // ...
    }
    // ANCHOR_END: list-connections

    // ANCHOR: remove-connection
    nwc_service
        .remove_connection("my new connection".to_string())
        .await?;
    // ANCHOR_END: remove-connection
    Ok(())
}

#[allow(unused_variables)]
async fn nwc_get_info(nwc_service: Arc<SdkNwcService>) -> Result<()> {
    // ANCHOR: get-info
    let info = nwc_service.get_info().await;
    // ANCHOR_END: get-info
    Ok(())
}

#[allow(unused_variables)]
async fn nwc_events(nwc_service: Arc<SdkNwcService>) -> Result<()> {
    // ANCHOR: events
    use breez_sdk_liquid_nwc::event::{NwcEvent, NwcEventDetails, NwcEventListener};

    struct MyListener {}
    #[async_trait::async_trait]
    impl NwcEventListener for MyListener {
        async fn on_event(&self, event: NwcEvent) {
            match event.details {
                NwcEventDetails::Connected => {
                    // ...
                }
                NwcEventDetails::Disconnected => {
                    // ...
                }
                NwcEventDetails::PayInvoice {
                    success,
                    preimage,
                    fees_sat,
                    error,
                } => {
                    // ...
                }
                NwcEventDetails::ZapReceived { invoice } => {
                    // ...
                }
                _ => {}
            }
        }
    }
    let event_listener = Box::new(MyListener {});
    let my_listener_id = nwc_service.add_event_listener(event_listener).await;

    // If you wish to remove the event_listener later on, you can call:
    nwc_service.remove_event_listener(&my_listener_id).await;
    // Otherwise, it will be automatically removed on service stop

    // ANCHOR_END: events
    Ok(())
}

async fn nwc_list_payments(nwc_service: Arc<SdkNwcService>) -> Result<()> {
    // ANCHOR: payments
    nwc_service
        .list_connection_payments("my new connection".to_string())
        .await?;
    // ANCHOR_END: payments
    Ok(())
}
