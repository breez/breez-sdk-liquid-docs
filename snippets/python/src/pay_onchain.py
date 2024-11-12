import logging
from breez_sdk_liquid import BindingLiquidSdk, PreparePayOnchainRequest, PreparePayOnchainResponse, PayAmount, PayOnchainRequest


def fetch_pay_onchain_limits(sdk: BindingLiquidSdk):
    # ANCHOR: get-current-pay-onchain-limits
    try:
        current_limits = sdk.fetch_onchain_limits()
        logging.debug("Minimum amount, in sats ", current_limits.send.min_sat)
        logging.debug("Maximum amount, in sats ", current_limits.send.max_sat)
        return current_limits
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: get-current-pay-onchain-limits

def prepare_pay_onchain(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-pay-onchain
    try:
        amount = PayAmount.RECEIVER(5_000)
        prepare_request = PreparePayOnchainRequest(amount)
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-pay-onchain

def prepare_pay_onchain_drain(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-pay-onchain-drain
    try:
        amount = PayAmount.DRAIN
        prepare_request = PreparePayOnchainRequest(amount)
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-pay-onchain-drain

def prepare_pay_onchain_fee_rate(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-pay-onchain-fee-rate
    try:
        amount = PayAmount.RECEIVER(5_000)
        optional_sat_per_vbyte = 21

        prepare_request = PreparePayOnchainRequest(amount, optional_sat_per_vbyte)
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        claim_fees_sat = prepare_response.claim_fees_sat
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: prepare-pay-onchain-fee-rate

def start_pay_onchain(sdk: BindingLiquidSdk, prepare_response: PreparePayOnchainResponse):
    # ANCHOR: start-reverse-swap
    address = "bc1.."
    try:
        sdk.pay_onchain(PayOnchainRequest(address, prepare_response))
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: start-reverse-swap
