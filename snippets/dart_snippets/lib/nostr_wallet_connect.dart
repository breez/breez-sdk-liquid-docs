import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> nostrWalletConnect() async {
  // ANCHOR: init-nwc
  Config config = defaultConfig(
    network: LiquidNetwork.mainnet,
    breezApiKey: "<your-Breez-API-key>"
  );

  config = config.copyWith(enableNwc: true);

  // Optional: You can specify your own Relay URLs
  config = config.copyWith(nwcRelayUrls: ["<your-relay-url-1>"]);
  // ANCHOR_END: init-nwc
  
  // ANCHOR: create-connection-string
  String nwcConnectionUri = await sdk.getNwcUri();
  // ANCHOR_END: create-connection-string
} 