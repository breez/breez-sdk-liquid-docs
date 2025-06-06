use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn register_webhook(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: register-webook
    sdk.register_webhook(
        "https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>".to_string(),
    )
    .await?;
    // ANCHOR_END: register-webook

    Ok(())
}

async fn unregister_webhook(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: unregister-webook
    sdk.unregister_webhook().await?;
    // ANCHOR_END: unregister-webook

    Ok(())
}
