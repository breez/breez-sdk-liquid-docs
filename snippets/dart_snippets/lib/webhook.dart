import 'package:dart_snippets/sdk_instance.dart';

Future<void> registerWebhook() async {
  // ANCHOR: register-webook
  String webhookUrl = "https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>";
  await breezSDKLiquid.instance!.registerWebhook(webhookUrl: webhookUrl);
  // ANCHOR_END: register-webook
}

Future<void> unregisterWebhook() async {
  // ANCHOR: unregister-webook
  await breezSDKLiquid.instance!.unregisterWebhook();
  // ANCHOR_END: unregister-webook
}
