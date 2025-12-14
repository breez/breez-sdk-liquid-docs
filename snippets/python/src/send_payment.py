import logging
from breez_sdk_liquid import BindingLiquidSdk, PayAmount, PrepareSendRequest, SendPaymentRequest, PrepareSendResponse

def fetch_pay_lightning_limits(sdk: BindingLiquidSdk):
    # ANCHOR: get-current-pay-lightning-limits
    try:
        current_limits = sdk.fetch_lightning_limits()
        logging.debug(f"Minimum amount, in sats {current_limits.send.min_sat}")
        logging.debug(f"Maximum amount, in sats {current_limits.send.max_sat}")
        return current_limits
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: get-current-pay-lightning-limits

def prepare_send_payment_lightning_bolt11(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-lightning-bolt11
    # Set the bolt11 invoice you wish to pay
    destination = "<bolt11 invoice>"
    try:
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
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

        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount,
            )
        )

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
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount,
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
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
        optional_amount = PayAmount.DRAIN()
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount,
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-liquid-drain

def send_payment(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    # ANCHOR: send-payment
    optional_payer_note = "<payer note>"
    try:
        send_response = sdk.send_payment(
            SendPaymentRequest(
                prepare_response=prepare_response,
                payer_note=optional_payer_note
            )
        )
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment
