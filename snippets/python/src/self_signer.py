import logging
import breez_sdk_liquid
from breez_sdk_liquid import connect, connect_with_signer, default_config, BindingLiquidSdk, ConnectRequest, EventListener, LiquidNetwork, LogEntry, Logger, SdkEvent, Signer, ConnectWithSignerRequest
 
 # ANCHOR: self-signer
def connect_with_self_signer(signer: Signer):
   
    # Create the default config, providing your Breez API key
    config = default_config(network=LiquidNetwork.MAINNET, breez_api_key="<your-Breez-API-key>")

    # Customize the config object according to your needs
    config.working_dir = "path to an existing directory"

    try:
        connect_request = ConnectWithSignerRequest(config)
        sdk = connect_with_signer(connect_request, signer)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: self-signer
