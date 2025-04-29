import logging
from breez_sdk_liquid import BindingLiquidSdk, PrepareReceiveRequest, PaymentMethod, PrepareReceiveResponse, ReceivePaymentRequest, ReceiveAmount


def prepare_receive_lightning(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-lightning
    try:
        # Fetch the lightning Receive limits
        current_limits = sdk.fetch_lightning_limits()
        logging.debug(f"Minimum amount allowed to deposit in sats {current_limits.receive.min_sat}")
        logging.debug(f"Maximum amount allowed to deposit in sats {current_limits.receive.max_sat}")

        # Set the invoice amount you wish the payer to send, which should be within the above limits
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.LIGHTNING,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-receive-payment-lightning

def prepare_receive_lightning_bolt12(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-lightning-bolt12
    try:
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.BOLT12_OFFER
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        min_receive_fees_sat = prepare_response.fees_sat
        swapper_feerate = prepare_response.swapper_feerate
        logging.debug(f"Fees: {min_receive_fees_sat} sats + {swapper_feerate}% of the sent amount")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-receive-payment-lightning-bolt12

def prepare_receive_onchain(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-onchain
    try:
        # Fetch the onchain Receive limits
        current_limits = sdk.fetch_onchain_limits()
        logging.debug(f"Minimum amount allowed to deposit in sats {current_limits.receive.min_sat}")
        logging.debug(f"Maximum amount allowed to deposit in sats {current_limits.receive.max_sat}")

        # Set the onchain amount you wish the payer to send, which should be within the above limits
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.BITCOIN_ADDRESS,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-receive-payment-onchain

def prepare_receive_liquid(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-liquid
    try:
        # Create a Liquid BIP21 URI/address to receive a payment to.
        # There are no limits, but the payer amount should be greater than broadcast fees when specified
        # Note: Not setting the amount will generate a plain Liquid address
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.LIQUID_ADDRESS,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-receive-payment-liquid

def receive_payment(sdk: BindingLiquidSdk, prepare_response: PrepareReceiveResponse):
    # ANCHOR: receive-payment
    try:
        optional_description = "<description>"
        req = ReceivePaymentRequest(
            prepare_response=prepare_response,
            description=optional_description
        )
        res = sdk.receive_payment(req)
        destination = res.destination
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: receive-payment
