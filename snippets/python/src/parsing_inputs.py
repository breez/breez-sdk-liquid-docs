import logging
from breez_sdk_liquid import BindingLiquidSdk, InputType

def parse_input(sdk: BindingLiquidSdk):
    # ANCHOR: parse-inputs
    input = "an input to be parsed..."

    try:
        parsed_input = sdk.parse(input)
        match parsed_input:
            case InputType.BITCOIN_ADDRESS:
                logging.debug(f"Input is Bitcoin address {parsed_input.address.address}")
            case InputType.BOLT11:
                amount = "unknown"
                if parsed_input.invoice.amount_msat:
                    amount = str(parsed_input.invoice.amount_msat)
                logging.debug(f"Input is BOLT11 invoice for {amount} msats")
            case InputType.LN_URL_PAY:
                logging.debug(f"Input is LNURL-Pay/Lightning address accepting min/max {parsed_input.data.min_sendable}/{parsed_input.data.max_sendable} msats")
            case InputType.LN_URL_WITHDRAW:
                logging.debug(f"Input is LNURL-Withdraw for min/max {parsed_input.data.min_withdrawable}/{parsed_input.data.max_withdrawable} msats")
            # Other input types are available
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: parse-inputs
