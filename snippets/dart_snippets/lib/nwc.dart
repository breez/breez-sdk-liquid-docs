// ignore_for_file: unused_local_variable
import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<BreezNwcService> nwcConnect() async {
  // ANCHOR: connecting
  NwcConfig nwcConfig = NwcConfig(
    relayUrls: null,
    secretKeyHex: null,
    listenToEvents: null,
  );
  BreezNwcService nwcService = await breezSDKLiquid.instance!.useNwcPlugin(config: nwcConfig);

  // ...

  // Automatically stops the plugin
  await breezSDKLiquid.instance!.disconnect();
  // Alternatively, you can stop the plugin manually, without disconnecting the SDK
  await nwcService.onStop();
  // ANCHOR_END: connecting

  return nwcService;
}

Future<void> nwcAddConnection(BreezNwcService nwcService) async {
  // ANCHOR: add-connection
  // This connection will only allow spending at most 10,000 sats/hour
  PeriodicBudgetRequest periodicBudgetReq = PeriodicBudgetRequest(
    maxBudgetSat: BigInt.from(10000),
    renewalTimeMins: 60, // Renews every hour
  );
  final addResponse = await nwcService.addConnection(
    req: AddConnectionRequest(
      name: "my new connection",
      expiryTimeMins: 60, // Expires after one hour
      periodicBudgetReq: periodicBudgetReq,
      receiveOnly: null, // Defaults to false
    ),
  );
  print(addResponse.connection.connectionString);
  // ANCHOR_END: add-connection
}

Future<void> nwcEditConnection(BreezNwcService nwcService) async {
  // ANCHOR: edit-connection
  int newExpiryTime = 60 * 24;
  final editResponse = await nwcService.editConnection(
    req: EditConnectionRequest(
      name: "my new connection",
      expiryTimeMins: newExpiryTime, // The connection will now expire after 1 day
      periodicBudgetReq: null,
      receiveOnly: null,
      removeExpiry: null,
      removePeriodicBudget: true, // The periodic budget has been removed
    ),
  );
  print(editResponse.connection.connectionString);
  // ANCHOR_END: edit-connection
}

Future<void> nwcListConnections(BreezNwcService nwcService) async {
  // ANCHOR: list-connections
  Map<String, NwcConnection> connections = await nwcService.listConnections();
  for (var entry in connections.entries) {
    print(
      "Connection: ${entry.key} - Expires at: ${entry.value.expiresAt}, Periodic Budget: ${entry.value.periodicBudget}",
    );
    // ...
  }
  // ANCHOR_END: list-connections
}

Future<void> nwcRemoveConnection(BreezNwcService nwcService) async {
  // ANCHOR: remove-connection
  await nwcService.removeConnection(name: "my new connection");
  // ANCHOR_END: remove-connection
}

Future<void> nwcGetInfo(BreezNwcService nwcService) async {
  // ANCHOR: get-info
  NostrServiceInfo? info = await nwcService.getInfo();
  // ANCHOR_END: get-info
}

Future<void> nwcEvents(BreezNwcService nwcService) async {
  // ANCHOR: events
  final eventStream = nwcService.addEventListener().asBroadcastStream();
  eventStream.listen((event) async {
    if (event.details is NwcEventDetails_Connected) {
      // ...
    } else if (event.details is NwcEventDetails_Disconnected) {
      // ...
    } else if (event.details is NwcEventDetails_ConnectionExpired) {
      // ...
    } else if (event.details is NwcEventDetails_ConnectionRefreshed) {
      // ...
    } else if (event.details is NwcEventDetails_PayInvoice) {
      final details = event.details as NwcEventDetails_PayInvoice;
      // details.success, details.preimage, details.feesSat, details.error
      // ...
    } else if (event.details is NwcEventDetails_ZapReceived) {
      final details = event.details as NwcEventDetails_ZapReceived;
      // details.invoice
      // ...
    }
  });
  // ANCHOR_END: events
}

Future<void> nwcListPayments(BreezNwcService nwcService) async {
  // ANCHOR: payments
  await nwcService.listConnectionPayments(name: "my new connection");
  // ANCHOR_END: payments
}
