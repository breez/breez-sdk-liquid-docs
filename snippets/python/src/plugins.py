import asyncio
from breez_sdk_liquid import (
    NwcConfig, 
    BindingNwcService, 
    Plugin, 
    PluginStorage,
    default_config,
    connect,
    ConnectRequest,
    LiquidNetwork,
    BindingLiquidSdk
)

def create_nwc_config():
    return NwcConfig(
        relay_urls=["<your-relay-url-1>"],
        secret_key_hex=None
    )

def create_sdk_config():
    config = default_config(
        network=LiquidNetwork.TESTNET,
        breez_api_key=None
    )
    config.working_dir = "path to an existing directory"
    return config

def create_connect_request(config):
    return ConnectRequest(
        config=config,
        mnemonic="<your-mnemonic-here>"
    )

def connect_with_nwc_plugin():
    #ANCHOR: create-plugin-config
    # Create Plugin Config
    nwc_config = create_nwc_config()

    # Initialize Plugin
    nwc_service = BindingNwcService(nwc_config)
    
    # Create SDK Config
    config = create_sdk_config()
    plugins = [nwc_service]
    
    # Create Connect Request
    connect_request = create_connect_request(config)
    
    # Connect to the SDK with the plugins
    sdk = connect(connect_request, plugins)
    #ANCHOR_END: create-plugin-config
    return sdk

#ANCHOR: my-custom-plugin
class MyPlugin(Plugin):
    def id(self):
        # Return the unique identifier for your plugin
        return "my-custom-plugin"

    def on_start(self, sdk: BindingLiquidSdk, storage: PluginStorage):
        # Initialize your plugin here
        pass

    def on_stop(self):
        # Cleanup your plugin here
        pass
#ANCHOR_END: my-custom-plugin