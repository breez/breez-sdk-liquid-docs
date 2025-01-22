import logging
from breez_sdk_liquid import BindingLiquidSdk, PayAmount, PrepareSendRequest, SendPaymentRequest, PrepareSendResponse


def prepare_send_payment_lightning_bolt11(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-lightning-bolt11
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
    # ANCHOR_END: prepare-send-payment-lightning-bolt11

def prepare_send_payment_lightning_bolt12(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-lightning-bolt12
    # Set the bolt12 offer you wish to pay
    destination = "<bolt12 offer>"
    try:
        optional_amount = PayAmount.BITCOIN(5_000)

        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-lightning-bolt12

def prepare_send_payment_liquid(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-liquid
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        optional_amount = PayAmount.BITCOIN(5_000)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-liquid

def prepare_send_payment_liquid_drain(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-liquid-drain
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        optional_amount = PayAmount.DRAIN
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-liquid-drain

def send_payment(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    # ANCHOR: send-payment
    try:
        send_response = sdk.send_payment(SendPaymentRequest(prepare_response))
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment
