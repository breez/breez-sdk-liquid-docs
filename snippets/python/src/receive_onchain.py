import logging
from breez_sdk_liquid import BindingLiquidSdk, RefundableSwap, RefundRequest


def list_refundables(sdk: BindingLiquidSdk):
    # ANCHOR: list-refundables
    try:
        refundables = sdk.list_refundables()
        return refundables
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: list-refundables

def execute_refund(sdk: BindingLiquidSdk, refund_txfee_rate: int, refundable: RefundableSwap):
    # ANCHOR: execute-refund
    destination_address = "..."
    sat_per_vbyte = refund_txfee_rate
    try:
        sdk.refund(RefundRequest(refundable.swap_address, destination_address, sat_per_vbyte))
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: execute-refund

def rescan_swaps(sdk: BindingLiquidSdk):
    # ANCHOR: rescan-swaps
    try:
        sdk.rescan_onchain_swaps()
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: rescan-swaps
