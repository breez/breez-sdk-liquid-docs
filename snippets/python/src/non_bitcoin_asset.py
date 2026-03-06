import logging
from breez_sdk_liquid import * 


def prepare_receive_asset(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-asset
    try:
        # Create a Liquid BIP21 URI/address to receive an asset payment to.
        # Note: Not setting the amount will generate an amountless BIP21 URI.
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        optional_amount = ReceiveAmount.ASSET(usdt_asset_id, 1.50)
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
    # ANCHOR_END: prepare-receive-payment-asset

def prepare_send_payment_asset(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-asset
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        # If the destination is an address or an amountless BIP21 URI,
        # you must specify an asset amount
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        amount = PayAmount.ASSET(usdt_asset_id, 1.50, False, None)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination=destination, amount=amount))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-asset

def prepare_send_payment_asset_fees(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-send-payment-asset-fees
    destination = "<Liquid BIP21 or address>"
    try:
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        # Set the optional estimate asset fees param to true
        optional_amount = PayAmount.ASSET(usdt_asset_id, 1.50, True, None)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination=destination, amount=optional_amount))

        # If the asset fees are set, you can use these fees to pay to send the asset
        send_asset_fees = prepare_response.estimated_asset_fees
        logging.debug(f"Estimated Fees: ~{send_asset_fees}")

        # If the asset fess are not set, you can use the sats fees to pay to send the asset
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-asset-fees

def send_payment_fees(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    # ANCHOR: send-payment-fees
    try:
        # Set the use asset fees param to true
        send_response = sdk.send_payment(SendPaymentRequest(prepare_response=prepare_response, use_asset_fees=True))
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment-fees

def fetch_asset_balance(sdk: BindingLiquidSdk):
    # ANCHOR: fetch-asset-balance
    try:
        info = sdk.get_info()
        asset_balances = info.wallet_info.asset_balances
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: fetch-asset-balance


def send_self_payment_asset(sdk: BindingLiquidSdk):
    # ANCHOR: send-self-payment-asset
    try:
        # Create a Liquid address to receive to
        prepare_receive_res = sdk.prepare_receive_payment(
            PrepareReceiveRequest(
                payment_method=PaymentMethod.LIQUID_ADDRESS,
                amount=None,
            )
        )
        receive_res = sdk.receive_payment(
            ReceivePaymentRequest(
                prepare_response=prepare_receive_res,
            )
        )

        # Swap your funds to the address we've created
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        btc_asset_id = "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d"
        prepare_send_res = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=receive_res.destination,
                # We want to receive 1.5 USDt
                amount=PayAmount.ASSET(usdt_asset_id, 1.5, None, btc_asset_id),
            )
        )
        send_response = sdk.send_payment(
            SendPaymentRequest(
                prepare_response=prepare_send_res,
            )
        )
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-self-payment-asset
