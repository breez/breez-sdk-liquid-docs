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

def configure_parsers():
    # ANCHOR: configure-external-parser
    mnemonic = "<mnemonic words>"

    # Create the default config, providing your Breez API key
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure external parsers
    config.external_input_parsers = [
        ExternalInputParser(
            provider_id="provider_a",
            input_regex="^provider_a",
            parser_url="https://parser-domain.com/parser?input=<input>"
        ),
        ExternalInputParser(
            provider_id="provider_b",
            input_regex="^provider_b",
            parser_url="https://parser-domain.com/parser?input=<input>"
        )
    ]

    try:
        connect_request = ConnectRequest(
            config=config,
            mnemonic=mnemonic
        )
        sdk = connect(connect_request)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: configure-external-parser
