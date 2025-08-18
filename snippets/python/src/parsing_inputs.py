import logging
from breez_sdk_liquid import BindingLiquidSdk, ConnectRequest, InputType, LiquidNetwork, connect, default_config, ExternalInputParser

def parse_input(sdk: BindingLiquidSdk):
    # ANCHOR: parse-inputs
    input = "an input to be parsed..."

    try:
        parsed_input = sdk.parse(input)
        if isinstance(parsed_input, InputType.BITCOIN_ADDRESS):
            logging.debug(f"Input is Bitcoin address {parsed_input.address.address}")
        elif isinstance(parsed_input, InputType.BOLT11):
            amount = "unknown"
            if parsed_input.invoice.amount_msat:
                amount = str(parsed_input.invoice.amount_msat)
            logging.debug(f"Input is BOLT11 invoice for {amount} msats")
        elif isinstance(parsed_input, InputType.BOLT12_OFFER):
            logging.debug(f"Input is BOLT12 offer for min {parsed_input.offer.min_amount} msats - BIP353 was used: {parsed_input.bip353_address is not None}")
        elif isinstance(parsed_input, InputType.LN_URL_PAY):
            logging.debug(f"Input is LNURL-Pay/Lightning address accepting min/max {parsed_input.data.min_sendable}/{parsed_input.data.max_sendable} msats - BIP353 was used: {parsed_input.bip353_address is not None}")
        elif isinstance(parsed_input, InputType.LN_URL_WITHDRAW):
            logging.debug(f"Input is LNURL-Withdraw for min/max {parsed_input.data.min_withdrawable}/{parsed_input.data.max_withdrawable} msats")
        # Other input types are available
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: parse-inputs
