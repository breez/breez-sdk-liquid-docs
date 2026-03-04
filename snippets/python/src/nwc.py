import logging
from breez_sdk_liquid import BindingLiquidSdk
from breez_sdk_liquid_nwc import (
    SdkNwcService,
    NwcConfig,
    AddConnectionRequest,
    EditConnectionRequest,
    PeriodicBudgetRequest,
    NwcEventListener,
    NwcEvent,
    NwcEventDetails,
)


def nwc_connect(sdk: BindingLiquidSdk):
    # ANCHOR: connecting
    nwc_config = NwcConfig(
        relay_urls=None,
        secret_key_hex=None,
        listen_to_events=None,
    )
    nwc_service = sdk.use_nwc_plugin(nwc_config)

    # ...

    # Automatically stops the plugin
    sdk.disconnect()
    # Alternatively, you can stop the plugin manually, without disconnecting the SDK
    nwc_service.stop()
    # ANCHOR_END: connecting

    return nwc_service


def nwc_add_connection(nwc_service: SdkNwcService):
    # ANCHOR: add-connection
    # This connection will only allow spending at most 10,000 sats/hour
    periodic_budget_req = PeriodicBudgetRequest(
        max_budget_sat=10000,
        renewal_time_mins=60,  # Renews every hour
    )
    try:
        add_response = nwc_service.add_connection(
            AddConnectionRequest(
                name="my new connection",
                expiry_time_mins=60,  # Expires after one hour
                periodic_budget_req=periodic_budget_req,
                receive_only=None,  # Defaults to False
            )
        )
        logging.debug(add_response.connection.connection_string)
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: add-connection


def nwc_edit_connection(nwc_service: SdkNwcService):
    # ANCHOR: edit-connection
    new_expiry_time = 60 * 24
    try:
        edit_response = nwc_service.edit_connection(
            EditConnectionRequest(
                name="my new connection",
                expiry_time_mins=new_expiry_time,  # The connection will now expire after 1 day
                periodic_budget_req=None,
                receive_only=None,
                remove_expiry=None,
                remove_periodic_budget=True,  # The periodic budget has been removed
            )
        )
        logging.debug(edit_response.connection.connection_string)
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: edit-connection


def nwc_list_connections(nwc_service: SdkNwcService):
    # ANCHOR: list-connections
    try:
        connections = nwc_service.list_connections()
        for connection_name, connection in connections.items():
            logging.debug(
                f"Connection: {connection_name} - Expires at: {connection.expires_at}, Periodic Budget: {connection.periodic_budget}"
            )
            # ...
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: list-connections


def nwc_remove_connection(nwc_service: SdkNwcService):
    # ANCHOR: remove-connection
    try:
        nwc_service.remove_connection("my new connection")
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: remove-connection


def nwc_get_info(nwc_service: SdkNwcService):
    # ANCHOR: get-info
    info = nwc_service.get_info()
    # ANCHOR_END: get-info


def nwc_events(nwc_service: SdkNwcService):
    # ANCHOR: events
    class MyListener(NwcEventListener):
        def on_event(self, event: NwcEvent):
            if isinstance(event.details, NwcEventDetails.CONNECTED):
                pass  # ...
            elif isinstance(event.details, NwcEventDetails.DISCONNECTED):
                pass  # ...
            elif isinstance(event.details, NwcEventDetails.CONNECTION_EXPIRED):
                pass  # ...
            elif isinstance(event.details, NwcEventDetails.CONNECTION_REFRESHED):
                pass  # ...
            elif isinstance(event.details, NwcEventDetails.PAY_INVOICE):
                # event.details.success, event.details.preimage, event.details.fees_sat, event.details.error
                pass  # ...
            elif isinstance(event.details, NwcEventDetails.ZAP_RECEIVED):
                # event.details.invoice
                pass  # ...

    event_listener = MyListener()
    my_listener_id = nwc_service.add_event_listener(event_listener)
    # If you wish to remove the event_listener later on, you can call:
    nwc_service.remove_event_listener(my_listener_id)
    # Otherwise, it will be automatically removed on service stop
    # ANCHOR_END: events


def nwc_list_payments(nwc_service: SdkNwcService):
    # ANCHOR: payments
    try:
        nwc_service.list_connection_payments("my new connection")
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: payments
