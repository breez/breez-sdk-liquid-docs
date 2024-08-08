import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> registerWebhook() async {
  // ANCHOR: register-webook
  await breezSDKLiquid.instance!.registerWebhook(webhookUrl: "https://your-nds-service.com/notify?platform=ios&token=<PUSH_TOKEN>");
  // ANCHOR_END: register-webook
}

Future<void> unregisterWebhook() async {
  // ANCHOR: unregister-webook
  await breezSDKLiquid.instance!.unregisterWebhook();
  // ANCHOR_END: unregister-webook
}
