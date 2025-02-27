import logging
from breez_sdk_liquid import BindingLiquidSdk, CheckMessageRequest, SignMessageRequest


def sign_message(sdk: BindingLiquidSdk):
    # ANCHOR: sign-message
    message = "<message to sign>"
    try:
        sign_message_response = sdk.sign_message(SignMessageRequest(message))

        # Get the wallet info for your pubkey
        info = sdk.get_info()

        signature = sign_message_response.signature
        pubkey = info.wallet_info.pubkey

        logging.debug(f"Pubkey: {pubkey}")
        logging.debug(f"Signature: {signature}")
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: sign-message

def check_message(sdk: BindingLiquidSdk):
    # ANCHOR: check-message
    message = "<message>"
    pubkey = "<pubkey of signer>"
    signature = "<message signature>"
    try:
        check_message_request = CheckMessageRequest(message, pubkey, signature)
        check_message_response = sdk.check_message(check_message_request)

        is_valid = check_message_response.is_valid

        logging.debug(f"Signature valid: {is_valid}")
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: check-message
