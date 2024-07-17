use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn list_payments(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    // ANCHOR: list-payments
    let payments = sdk.list_payments(&ListPaymentsRequest::default()).await?;
    // ANCHOR_END: list-payments

    Ok(payments)
}

async fn list_payments_filtered(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    // ANCHOR: list-payments-filtered
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: Some(vec![PaymentType::Send]),
            from_timestamp: Some(1696880000),
            to_timestamp: Some(1696959200),
            offset: Some(0),
            limit: Some(50),
        })
        .await?;
    // ANCHOR_END: list-payments-filtered

    Ok(payments)
}
