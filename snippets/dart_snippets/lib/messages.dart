import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<SignMessageResponse> signMessage() async {
  // ANCHOR: sign-message
  SignMessageResponse signMessageResponse = breezSDKLiquid.instance!.signMessage(
    req: SignMessageRequest(message: "<message to sign>"),
  );

  // Get the wallet info for your pubkey
  GetInfoResponse? info = await breezSDKLiquid.instance!.getInfo();

  String signature = signMessageResponse.signature;
  String pubkey = info.walletInfo.pubkey;

  print("Pubkey: $pubkey");
  print("Signature: $signature");
  // ANCHOR_END: sign-message
  return signMessageResponse;
}

Future<CheckMessageResponse> checkMessage() async {
  // ANCHOR: check-message
  CheckMessageResponse checkMessageResponse = breezSDKLiquid.instance!.checkMessage(
    req: CheckMessageRequest(
      message: "<message>",
      pubkey: "<pubkey of signer>",
      signature: "<message signature>"
    ),
  );

  bool isValid = checkMessageResponse.isValid;

  print("Signature valid: $isValid");
  // ANCHOR_END: check-message
  return checkMessageResponse;
}
