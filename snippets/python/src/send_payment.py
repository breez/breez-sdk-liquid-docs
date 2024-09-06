import logging
from breez_sdk_liquid import BindingLiquidSdk, PrepareSendRequest, SendPaymentRequest, PrepareSendResponse


def prepare_send_payment_lightning(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-lightning
    # Set the bolt11 invoice you wish to pay
    destination = "<bolt11 invoice>"
    try:
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-lightning

def prepare_send_payment_liquid(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-liquid
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        optional_amount_sat = 5_000
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount_sat))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-liquid

def send_payment(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    # ANCHOR: send-payment
    try:
        send_response = sdk.send_payment(SendPaymentRequest(prepare_response))
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment
