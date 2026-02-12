import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

NwcConfig createNwcConfig() {
  return NwcConfig(
    relayUrls: ["<your-relay-url-1>"],
    secretKeyHex: null,
  );
}

Config createSdkConfig() {
  var config = defaultConfig(network: LiquidNetwork.testnet, breezApiKey: null);
  config = config.copyWith(workingDir: "path to an existing directory");
  return config;
}

ConnectRequest createConnectRequest(Config config) {
  return ConnectRequest(
    config: config,
    mnemonic: "<your-mnemonic-here>",
  );
}

Future<BreezSdkLiquid> connectWithNwcPlugin() async {
  //ANCHOR: create-plugin-config
  // Create Plugin Config
  var nwcConfig = createNwcConfig();

  // Initialize Plugin
  var nwcService = BindingNwcService(nwcConfig);

  // Create SDK Config
  var config = createSdkConfig();
  var plugins = <Plugin>[nwcService];

  // Create Connect Request
  var connectRequest = createConnectRequest(config);

  // Connect to the SDK with the plugins
  var sdk = await connect(req: connectRequest, plugins: plugins);
  //ANCHOR_END: create-plugin-config
  return sdk;
}

//ANCHOR: my-custom-plugin
class MyPlugin {
  String id() {
    // Return the unique identifier for your plugin
    return "my-custom-plugin";
  }

  @override
  Future<void> onStart(BreezSdkLiquid sdk, PluginStorage storage) async {
    // Initialize your plugin here
  }

  @override
  Future<void> onStop() async {
    // Cleanup your plugin here
  }
}
//ANCHOR_END: my-custom-plugin
