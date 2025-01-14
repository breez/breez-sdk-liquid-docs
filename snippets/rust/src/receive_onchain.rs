use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::model::PaymentState::WaitingFeeAcceptance;
use breez_sdk_liquid::prelude::*;
use log::info;

async fn list_refundables(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: list-refundables
    let refundables = sdk.list_refundables().await?;
    // ANCHOR_END: list-refundables

    Ok(())
}

async fn execute_refund(
    sdk: Arc<LiquidSdk>,
    refund_tx_fee_rate: u32,
    refundable: RefundableSwap,
) -> Result<()> {
    // ANCHOR: execute-refund
    let destination_address = "...".into();
    let fee_rate_sat_per_vbyte = refund_tx_fee_rate;

    sdk.refund(&RefundRequest {
        swap_address: refundable.swap_address,
        refund_address: destination_address,
        fee_rate_sat_per_vbyte,
    })
    .await?;
    // ANCHOR_END: execute-refund

    Ok(())
}

async fn rescan_swaps(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: rescan-swaps
    sdk.rescan_onchain_swaps().await?;
    // ANCHOR_END: rescan-swaps

    Ok(())
}

async fn recommended_fees(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: recommended-fees
    let fees = sdk.recommended_fees().await?;
    // ANCHOR_END: recommended-fees
    dbg!(fees);
    Ok(())
}

async fn handle_payments_waiting_fee_acceptance(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: handle-payments-waiting-fee-acceptance
    // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
    let payments_waiting_fee_acceptance = sdk
        .list_payments(&ListPaymentsRequest {
            states: Some(vec![WaitingFeeAcceptance]),
            ..Default::default()
        })
        .await?;

    for payment in payments_waiting_fee_acceptance {
        let PaymentDetails::Bitcoin { swap_id, .. } = payment.details else {
            // Only Bitcoin payments can be `WaitingFeeAcceptance`
            continue;
        };

        let fetch_fees_response = sdk
            .fetch_payment_proposed_fees(&FetchPaymentProposedFeesRequest { swap_id })
            .await?;

        info!(
            "Payer sent {} and currently proposed fees are {}",
            fetch_fees_response.payer_amount_sat, fetch_fees_response.fees_sat
        );

        // If the user is ok with the fees, accept them, allowing the payment to proceed
        sdk.accept_payment_proposed_fees(&AcceptPaymentProposedFeesRequest {
            response: fetch_fees_response,
        })
        .await?;
    }
    // ANCHOR_END: handle-payments-waiting-fee-acceptance

    Ok(())
}
