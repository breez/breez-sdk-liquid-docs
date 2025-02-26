import logging
import breez_sdk_liquid
from breez_sdk_liquid import connect, default_config, BindingLiquidSdk, ConnectRequest, EventListener, LiquidNetwork, LogEntry, Logger, SdkEvent

def start():
    # ANCHOR: init-sdk
    mnemonic = "<mnemonic words>"

    # Create the default config, providing your Breez API key
    config = default_config(network=LiquidNetwork.MAINNET, breez_api_key="<your-Breez-API-key>")

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
        info = sdk.get_info()
        balance_sat = info.wallet_info.balance_sat
        pending_send_sat = info.wallet_info.pending_send_sat
        pending_receive_sat = info.wallet_info.pending_receive_sat
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: fetch-balance

# ANCHOR: logging
class SdkLogger(Logger):
    def log(self, log_entry: LogEntry):
        logging.debug(f"Received log [{log_entry.level}]: {log_entry.line}")

def set_logger(logger: SdkLogger):
    try:
        breez_sdk_liquid.set_logger(logger)
    except Exception as error:
        logging.error(error)
        raise
# ANCHOR_END: logging

# ANCHOR: add-event-listener
class SdkListener(EventListener):
    def on_event(self, sdk_event: SdkEvent):
        logging.debug(f"Received event {sdk_event}")

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

# ANCHOR: disconnect
def disconnect(sdk: BindingLiquidSdk):
    try:
        sdk.disconnect()
    except Exception as error:
        logging.error(error)
        raise
# ANCHOR_END: disconnect
