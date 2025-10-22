import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

// ANCHOR: event-listener
class MyNwcEventListener implements NwcEventListener {
  @override
  Future<void> onEvent(NwcEvent event) async {
    switch (event.details) {
      case NwcEventDetails.connected():
        print("NWC connected");
        break;
      case NwcEventDetails.disconnected():
        print("NWC disconnected");
        break;
      case NwcEventDetails.payInvoice(
        success: final success,
        preimage: _,
        feesSat: _,
        error: _,
      ):
        print("Payment ${success ? "successful" : "failed"}");
        break;
      case NwcEventDetails.listTransactions():
        print("Transactions requested");
        break;
      case NwcEventDetails.getBalance():
        print("Balance requested");
        break;
    }
  }
}
// ANCHOR_END: event-listener

Future<void> nostrWalletConnect() async {
  // ANCHOR: nwc-config
  final nwcConfig = NwcConfig(
    relayUrls: [
      "<your-relay-url-1>",
    ], // Optional: Custom relay URLs (uses default if null)
    secretKeyHex:
        "your-nostr-secret-key-hex", // Optional: Custom Nostr secret key
  );

  final nwcService = SdkNwcService(nwcConfig);

  // Add the plugin to your SDK
  final plugins = <Plugin>[nwcService];
  // ANCHOR_END: nwc-config

  // ANCHOR: add-connection
  final connectionName = "my-app-connection";
  final connectionString = await nwcService.addConnectionString(connectionName);
  // ANCHOR_END: add-connection

  // ANCHOR: list-connections
  final connections = await nwcService.listConnectionStrings();
  // ANCHOR_END: list-connections

  // ANCHOR: remove-connection
  await nwcService.removeConnectionString(connectionName);
  // ANCHOR_END: remove-connection

  // ANCHOR: event-listener
  // Event listener class is defined above
  // ANCHOR_END: event-listener

  // ANCHOR: event-management
  // Add event listener
  final listener = MyNwcEventListener();
  final listenerId = await nwcService.addEventListener(listener);

  // Remove event listener when no longer needed
  await nwcService.removeEventListener(listenerId);
  // ANCHOR_END: event-management

  // ANCHOR: error-handling
  try {
    final connectionString = await nwcService.addConnectionString("test");
    print("Connection created: $connectionString");
  } on NwcErrorGeneric catch (e) {
    print("Generic error: ${e.message}");
  } on NwcErrorPersist catch (e) {
    print("Persistence error: ${e.message}");
  }
  // ANCHOR_END: error-handling
}
