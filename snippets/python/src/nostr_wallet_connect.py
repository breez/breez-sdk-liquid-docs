import asyncio
from breez_sdk_liquid import (NwcConfig, BindingNwcService, Plugin, NwcEventListener, NwcEvent, NwcEventDetails, NwcErrorGeneric, NwcErrorPersist
)

def nostr_wallet_connect():
    # ANCHOR: nwc-config
    nwc_config = NwcConfig(
        relay_urls=["<your-relay-url-1>"],               # Optional: Custom relay URLs (uses default if None)
        secret_key_hex="your-nostr-secret-key-hex"       # Optional: Custom Nostr secret key
    )
    
    nwc_service = BindingNwcService(nwc_config)
    
    # Add the plugin to your SDK
    plugins = [nwc_service]
    # ANCHOR_END: nwc-config

    # ANCHOR: add-connection
    connection_name = "my-app-connection"
    connection_string = nwc_service.add_connection_string(connection_name)
    # ANCHOR_END: add-connection

    # ANCHOR: list-connections
    connections = nwc_service.list_connection_strings()
    # ANCHOR_END: list-connections

    # ANCHOR: remove-connection
    nwc_service.remove_connection_string(connection_name)
    # ANCHOR_END: remove-connection

    # ANCHOR: event-listener
    class MyNwcEventListener(NwcEventListener):
        def on_event(self, event: NwcEvent):
            if isinstance(event.details, NwcEventDetails.Connected):
                print("NWC connected")
            elif isinstance(event.details, NwcEventDetails.Disconnected):
                print("NWC disconnected")
            elif isinstance(event.details, NwcEventDetails.PayInvoice):
                success = event.details.success
                print(f"Payment {'successful' if success else 'failed'}")
            elif isinstance(event.details, NwcEventDetails.ListTransactions):
                print("Transactions requested")
            elif isinstance(event.details, NwcEventDetails.GetBalance):
                print("Balance requested")
    # ANCHOR_END: event-listener

    # ANCHOR: event-management
    # Add event listener
    listener = MyNwcEventListener()
    listener_id = nwc_service.add_event_listener(listener)

    # Remove event listener when no longer needed
    nwc_service.remove_event_listener(listener_id)
    # ANCHOR_END: event-management

    # ANCHOR: error-handling
    try:
        connection_string = nwc_service.add_connection_string("test")
        print(f"Connection created: {connection_string}")
    except NwcErrorGeneric as e:
        print(f"Generic error: {e.err}")
    except NwcErrorPersist as e:
        print(f"Persistence error: {e.err}")
    except Exception as e:
        print(f"Unknown error: {e}")
    # ANCHOR_END: error-handling