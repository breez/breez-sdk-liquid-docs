import logging
from breez_sdk_liquid import BindingLiquidSdk, RefundableSwap, RefundRequest, PaymentDetails, PaymentState, ListPaymentsRequest, FetchPaymentProposedFeesRequest, AcceptPaymentProposedFeesRequest


def list_refundables(sdk: BindingLiquidSdk):
    # ANCHOR: list-refundables
    try:
        refundables = sdk.list_refundables()
        return refundables
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: list-refundables

def execute_refund(sdk: BindingLiquidSdk, refund_tx_fee_rate: int, refundable: RefundableSwap):
    # ANCHOR: execute-refund
    destination_address = "..."
    fee_rate_sat_per_vbyte = refund_tx_fee_rate
    try:
        sdk.refund(RefundRequest(
            swap_address=refundable.swap_address,
            refund_address=destination_address,
            fee_rate_sat_per_vbyte=fee_rate_sat_per_vbyte
        ))
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: execute-refund

def rescan_swaps(sdk: BindingLiquidSdk):
    # ANCHOR: rescan-swaps
    try:
        sdk.rescan_onchain_swaps()
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: rescan-swaps

def recommended_fees(sdk: BindingLiquidSdk):
    # ANCHOR: recommended-fees
    try:
        fees = sdk.recommended_fees()
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: recommended-fees

def handle_payments_waiting_fee_acceptance(sdk: BindingLiquidSdk):
    # ANCHOR: handle-payments-waiting-fee-acceptance
    try:
        # Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
        payments_waiting_fee_acceptance = sdk.list_payments(
            ListPaymentsRequest(
                states=[PaymentState.WAITING_FEE_ACCEPTANCE]
            )
        )

        for payment in payments_waiting_fee_acceptance:
            if not isinstance(payment.details, PaymentDetails.BITCOIN):
                # Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
                continue

            fetch_fees_response = sdk.fetch_payment_proposed_fees(
                FetchPaymentProposedFeesRequest(
                    swap_id=payment.details.swap_id
                )
            )

            logging.info(
                f"Payer sent {fetch_fees_response.payer_amount_sat} "
                f"and currently proposed fees are {fetch_fees_response.fees_sat}"
            )

            # If the user is ok with the fees, accept them, allowing the payment to proceed
            sdk.accept_payment_proposed_fees(
                AcceptPaymentProposedFeesRequest(
                    response=fetch_fees_response
                )
            )

    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: handle-payments-waiting-fee-acceptance
