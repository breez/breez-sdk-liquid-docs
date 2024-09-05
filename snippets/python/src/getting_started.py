import logging
import breez_sdk_liquid
from breez_sdk_liquid import connect, default_config, BindingLiquidSdk, ConnectRequest, EventListener, LiquidNetwork, LogEntry, Logger, SdkEvent

def start():
    # ANCHOR: init-sdk
    mnemonic = "<mnemonic words>"

    # Create the default config
    config = default_config(LiquidNetwork.MAINNET)

    # Customize the config object according to your needs
    config.working_dir = "path to an existing directory"

    try:
        connect_request = ConnectRequest(config, mnemonic)
        sdk = connect(connect_request)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: init-sdk

def fetch_balance(sdk: BindingLiquidSdk):
    # ANCHOR: fetch-balance
    try:
        wallet_info = sdk.get_info()
        balance_sat = wallet_info.balance_sat
        pending_send_sat = wallet_info.pending_send_sat
        pending_receive_sat = wallet_info.pending_receive_sat
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: fetch-balance

# ANCHOR: logging
class SdkLogger(Logger):
    def log(log_entry: LogEntry):
        logging.debug("Received log [", log_entry.level, "]: ", log_entry.line)

def set_logger(logger: SdkLogger):
    try:
        breez_sdk_liquid.set_logger(logger)
    except Exception as error:
        logging.error(error)
        raise
# ANCHOR_END: logging

# ANCHOR: add-event-listener
class SdkListener(EventListener):
    def on_event(sdk_event: SdkEvent):
        logging.debug("Received event ", sdk_event)

def add_event_listener(sdk: BindingLiquidSdk, listener: SdkListener):
    try:
        listener_id = sdk.add_event_listener(listener)
        return listener_id
    except Exception as error:
        logging.error(error)
        raise
# ANCHOR_END: add-event-listener

# ANCHOR: remove-event-listener
def remove_event_listener(sdk: BindingLiquidSdk, listener_id: str):
    try:
        sdk.remove_event_listener(listener_id)
    except Exception as error:
        logging.error(error)
        raise
# ANCHOR_END: remove-event-listener
