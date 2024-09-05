import logging
from breez_sdk_liquid import BindingLiquidSdk


def register_webhook(sdk: BindingLiquidSdk):
    # ANCHOR: register-webook
    try:
        sdk.register_webhook("https://your-nds-service.com/notify?platform=ios&token=<PUSH_TOKEN>")
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: register-webook

def unregister_webhook(sdk: BindingLiquidSdk):
    # ANCHOR: unregister-webook
    try:
        sdk.unregister_webhook()
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: unregister-webook
