import logging
from breez_sdk_liquid import BindingLiquidSdk, PrepareSendRequest, SendPaymentRequest


def send_payment(sdk: BindingLiquidSdk):
    # ANCHOR: send-payment
    # Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
    destination = "Invoice, Liquid BIP21 or address"
    try:
        optional_amount_sat = 5_000
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount_sat))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat

        send_response = sdk.send_payment(SendPaymentRequest(prepare_response))
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment
