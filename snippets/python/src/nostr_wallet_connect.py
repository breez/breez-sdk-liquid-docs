import logging
from breez_sdk_liquid import default_config, LiquidNetwork, Config

def nostr_wallet_connect():
    # ANCHOR: init-nwc
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    config.enable_nwc = True

    # Optional: You can specify your own Relay URLs
    config.nwc_relay_urls = ["<your-relay-url-1>"]
    # ANCHOR_END: init-nwc
    
    # ANCHOR: create-connection-string
    nwc_connection_uri = sdk.get_nwc_uri()
    # ANCHOR_END: create-connection-string 