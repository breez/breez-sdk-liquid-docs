from breez_sdk_liquid import BindingLiquidSdk, GetPaymentRequest, ListPaymentDetails, ListPaymentsRequest, PaymentType
import logging


def get_payment(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: get-payment
        payment_hash = "<payment hash>"
        sdk.get_payment(GetPaymentRequest.PAYMENT_HASH(payment_hash))

        swap_id = "<swap id>"
        sdk.get_payment(GetPaymentRequest.SWAP_ID(swap_id=swap_id))
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
            filters = [PaymentType.SEND],
            from_timestamp = 1696880000, 
            to_timestamp = 1696959200, 
            offset = 0,
            limit = 50)
        sdk.list_payments(req)
        # ANCHOR_END: list-payments-filtered
    except Exception as error:
        logging.error(error)
        raise

def list_payments_details_address(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: list-payments-details-address
        address = "<Bitcoin address>"
        req = ListPaymentsRequest(
            details = ListPaymentDetails.BITCOIN(address=address))
        sdk.list_payments(req)
        # ANCHOR_END: list-payments-details-address
    except Exception as error:
        logging.error(error)
        raise

def list_payments_details_destination(sdk: BindingLiquidSdk):
    try:
        # ANCHOR: list-payments-details-destination
        destination = "<Liquid BIP21 or address>"
        req = ListPaymentsRequest(
            details = ListPaymentDetails.LIQUID(destination=destination,asset_id=None))
        sdk.list_payments(req)
        # ANCHOR_END: list-payments-details-destination
    except Exception as error:
        logging.error(error)
        raise
