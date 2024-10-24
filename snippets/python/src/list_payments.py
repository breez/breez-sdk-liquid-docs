from breez_sdk_liquid import BindingLiquidSdk, GetPaymentRequest, ListPaymentsRequest, PaymentType
import logging


def get_payment(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: get-payment
        payment_hash = "<payment hash>"
        sdk.get_payment(GetPaymentRequest.LIGHTNING(payment_hash))
        # ANCHOR_END: get-payment
    except Exception as error:
        logging.error(error)
        raise

def list_payments(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: list-payments
        sdk.list_payments(ListPaymentsRequest())
        # ANCHOR_END: list-payments
    except Exception as error:
        logging.error(error)
        raise

def list_payments_filtered(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: list-payments-filtered
        req = ListPaymentsRequest(
            [PaymentType.SEND], 
            from_timestamp = 1696880000, 
            to_timestamp = 1696959200, 
            offset = 0,
            limit = 50)
        sdk.list_payments(req)
        # ANCHOR_END: list-payments-filtered
    except Exception as error:
        logging.error(error)
        raise