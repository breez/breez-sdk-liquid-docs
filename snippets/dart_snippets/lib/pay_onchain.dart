import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> getCurrentLimits() async {
  // ANCHOR: get-current-pay-onchain-limits
  OnchainPaymentLimitsResponse currentLimits = await breezLiquidSDK.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.send.minSat} sats");
  print("Maximum amount: ${currentLimits.send.maxSat} sats");
  // ANCHOR_END: get-current-pay-onchain-limits
  return currentLimits;
}

Future<PreparePayOnchainResponse> preparePayOnchain() async {
  // ANCHOR: prepare-pay-onchain
  PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
    receiverAmountSat: 5000 as BigInt,
  );
  PreparePayOnchainResponse prepareRes = await breezLiquidSDK.instance!.preparePayOnchain(
    req: preparePayOnchainRequest,
  );

  // Check if the fees are acceptable before proceeding
  BigInt feesSat = prepareRes.feesSat;
  // ANCHOR_END: prepare-pay-onchain
  print(feesSat);
  return prepareRes;
}

Future<SendPaymentResponse> startReverseSwap({
  required PreparePayOnchainResponse prepareRes,
}) async {
  // ANCHOR: start-reverse-swap
  String destinationAddress = "bc1..";

  PayOnchainRequest req = PayOnchainRequest(
    address: destinationAddress,
    prepareRes: prepareRes,
  );
  SendPaymentResponse res = await breezLiquidSDK.instance!.payOnchain(req: req);
  // ANCHOR_END: start-reverse-swap
  return res;
}
