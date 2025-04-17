import logging
from breez_sdk_liquid import BindingLiquidSdk, OnchainPaymentLimitsResponse, BuyBitcoinProvider, PrepareBuyBitcoinRequest, PrepareBuyBitcoinResponse, BuyBitcoinRequest

def fetch_onchain_limits(sdk: BindingLiquidSdk):
    # ANCHOR: onchain-limits
    try:
        current_limits = sdk.fetch_onchain_limits()
        logging.debug(f"Minimum amount, in sats {current_limits.receive.min_sat}")
        logging.debug(f"Maximum amount, in sats {current_limits.receive.max_sat}")
        return current_limits
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: onchain-limits

def prepare_buy_btc(sdk: BindingLiquidSdk, current_limits: OnchainPaymentLimitsResponse):
    # ANCHOR: prepare-buy-btc
    try:
        req = PrepareBuyBitcoinRequest(BuyBitcoinProvider.MOONPAY, current_limits.receive.min_sat)
        prepare_response = sdk.prepare_buy_bitcoin(req)

        # Check the fees are acceptable before proceeding
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-buy-btc

def buy_btc(sdk: BindingLiquidSdk, prepareResponse: PrepareBuyBitcoinResponse):
    # ANCHOR: buy-btc
    try:
        req = BuyBitcoinRequest(prepareResponse)
        url = sdk.buy_bitcoin(req)
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: buy-btc
