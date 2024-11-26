use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn get_payment(sdk: Arc<LiquidSdk>) -> Result<Option<Payment>> {
    // ANCHOR: get-payment
    let payment_hash = "<payment hash>".to_string();
    let payment = sdk.get_payment(&GetPaymentRequest::Lightning {
        payment_hash
    }).await?;
    // ANCHOR_END: get-payment

    Ok(payment)
}

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
            details: None,
        })
        .await?;
    // ANCHOR_END: list-payments-filtered

    Ok(payments)
}

async fn list_payments_details_address(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    // ANCHOR: list-payments-details-address
    let address = "<Bitcoin address>".to_string();
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: None,
            from_timestamp: None,
            to_timestamp: None,
            offset: None,
            limit: None,
            details: Some(ListPaymentDetails::Bitcoin {
                address,
            }),            
        })
        .await?;
    // ANCHOR_END: list-payments-details-address

    Ok(payments)
}

async fn list_payments_details_destination(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    // ANCHOR: list-payments-details-destination
    let destination = "<Liquid BIP21 or address>".to_string();
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: None,
            from_timestamp: None,
            to_timestamp: None,
            offset: None,
            limit: None,
            details: Some(ListPaymentDetails::Liquid {
                destination,
            }),            
        })
        .await?;
    // ANCHOR_END: list-payments-details-addrdestinationess

    Ok(payments)
}
