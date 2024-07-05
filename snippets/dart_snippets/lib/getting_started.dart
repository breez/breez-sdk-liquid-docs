import 'dart:typed_data';

import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> initializeSDK() async {
  // ANCHOR: init-sdk

  // It is recommended to use a single instance of BreezSDK across your Dart/Flutter app.
  //
  // All of the snippets assume a BreezSDK object is created on entrypoint of the app as such:
  //
  // BreezSDK breezSDK = BreezSDK();
  //
  // and is accessible throughout the app. There are various approaches on how to achieve this; creating a Singleton class using factory constructor, using state management libraries such as 'provider', 'GetX', 'Riverpod' and 'Redux' to name a few.

  // Initializes SDK events & log streams.
  //
  // Call once on your Dart entrypoint file, e.g.; `lib/main.dart`.
  // Initialize library
  await initialize();

  // Create the default config
  Uint8List seed = await breezSDK.mnemonicToSeed("<mnemonic words>");
  String inviteCode = "<invite code>";
  String apiKey = "<api key>";
  NodeConfig nodeConfig = NodeConfig.greenlight(
    config: GreenlightNodeConfig(
      partnerCredentials: null,
      inviteCode: inviteCode,
    ),
  );
  Config config = await breezSDK.defaultConfig(
    envType: EnvironmentType.Production,
    apiKey: apiKey,
    nodeConfig: nodeConfig,
  );

  // Customize the config object according to your needs
  config = config.copyWith(workingDir: "path to an existing directory");

  // Connect to the Breez SDK make it ready for use
  ConnectRequest connectRequest = ConnectRequest(config: config, seed: seed);
  return await breezSDK.connect(req: connectRequest);
  // ANCHOR_END: init-sdk
}

Future<void> connectRestoreOnly(Config config, Uint8List seed) async {
  // ANCHOR: init-sdk-restore-only
  ConnectRequest connectRequest = ConnectRequest(config: config, seed: seed, restoreOnly: true);
  return await breezSDK.connect(req: connectRequest);
  // ANCHOR_END: init-sdk-restore-only
}

Future<void> fetchBalance(String lspId) async {
  // ANCHOR: fetch-balance
  NodeState? nodeInfo = await breezSDK.nodeInfo();
  if (nodeInfo != null) {
    int lnBalance = nodeInfo.channelsBalanceMsat;
    int onchainBalance = nodeInfo.onchainBalanceMsat;
    print(lnBalance);
    print(onchainBalance);
  }
  // ANCHOR_END: fetch-balance
}

// ANCHOR: logging
void onLogEntry(log) {
  print("Received log ${log.level}]: ${log.line}");
}

void logging(BreezSDK breezSDK) {
  breezSDK.logStream.listen(onLogEntry);
}
// ANCHOR_END: logging
