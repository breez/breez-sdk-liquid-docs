import logging
from breez_sdk_liquid import AssetMetadata, BindingLiquidSdk, default_config, LiquidNetwork, PayAmount, PaymentMethod, PrepareReceiveRequest, PrepareSendRequest, ReceiveAmount


def prepare_receive_asset(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-receive-payment-asset
    try:
        # Create a Liquid BIP21 URI/address to receive an asset payment to.
        # Note: Not setting the amount will generate an amountless BIP21 URI.
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        optional_amount = ReceiveAmount.ASSET(usdt_asset_id, 1.50)
        prepare_request = PrepareReceiveRequest(PaymentMethod.LIQUID_ADDRESS, optional_amount)
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", receive_fees_sat, " sats")
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
        optional_amount = PayAmount.ASSET(usdt_asset_id, 1.50, False)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
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
        optional_amount = PayAmount.ASSET(usdt_asset_id, 1.50, True)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        # If the asset fees are set, you can use these fees to pay to send the asset
        send_asset_fees = prepare_response.asset_fees
        logging.debug("Fees: ", send_asset_fees)

        # If the asset fess are not set, you can use the sats fees to pay to send the asset
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-send-payment-asset-fees

def send_payment_fees(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    # ANCHOR: send-payment-fees
    try:
        # Set the use asset fees param to true
        send_response = sdk.send_payment(SendPaymentRequest(prepare_response, True))
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: send-payment-fees

def configure_asset_metadata():
    # ANCHOR: configure-asset-metadata
    # Create the default config
    config = default_config(network=LiquidNetwork.MAINNET, breez_api_key="<your-Breez-API-key>")

    # Configure asset metadata. Setting the optional fiat ID will enable
    # paying fees using the asset (if available).
    config.asset_metadata = [
        AssetMetadata(
            asset_id="18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            name="PEGx EUR",
            ticker="EURx",
            precision=8,
            fiat_id="EUR"
        )
    ]
    # ANCHOR_END: configure-asset-metadata

def fetch_asset_balance(sdk: BindingLiquidSdk):
    # ANCHOR: fetch-asset-balance
    try:
        info = sdk.get_info()
        asset_balances = info.wallet_info.asset_balances
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: fetch-asset-balance
