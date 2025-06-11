import 'dart:async';

import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';
// ANCHOR: init-sdk-app-group
import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

const String APP_GROUP = 'group.com.example.application';
const String MNEMONIC_KEY = 'BREEZ_SDK_LIQUID_SEED_MNEMONIC';

Future<void> initSdk() async {
  // Read the mnemonic from secure storage using the app group
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      groupId: APP_GROUP,
    ),
  );
  final String? mnemonic = await storage.read(key: MNEMONIC_KEY);
  if (mnemonic == null) {
    throw Exception('Mnemonic not found');
  }

  // Create the default config, providing your Breez API key
  Config config = defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>");
  
  // Set the working directory to the app group path
  config = config.copyWith(workingDir: await getWorkingDir());

  ConnectRequest connectRequest = ConnectRequest(mnemonic: mnemonic, config: config);

  await breezSDKLiquid.connect(req: connectRequest);
}

static Future<String> getWorkingDir() async {
  String path = '';
  if (defaultTargetPlatform == TargetPlatform.android) {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    path = documentsDir.path;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    final Directory? sharedDirectory = await AppGroupDirectory().getAppGroupDirectory(
      APP_GROUP,
    );
    if (sharedDirectory == null) {
      throw Exception('Could not get shared directory');
    }
    path = sharedDirectory.path;
  }
  return "$path/breezSdkLiquid";
}
// ANCHOR_END: init-sdk-app-group
