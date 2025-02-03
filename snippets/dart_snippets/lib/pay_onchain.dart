import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> getCurrentLimits() async {
  // ANCHOR: get-current-pay-onchain-limits
  OnchainPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.send.minSat} sats");
  print("Maximum amount: ${currentLimits.send.maxSat} sats");
  // ANCHOR_END: get-current-pay-onchain-limits
  return currentLimits;
}

Future<PreparePayOnchainResponse> preparePayOnchain() async {
  // ANCHOR: prepare-pay-onchain
  PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
    amount: PayAmount_Bitcoin(receiverAmountSat: 5000 as BigInt),
  );
  PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
    req: preparePayOnchainRequest,
  );

  // Check if the fees are acceptable before proceeding
  BigInt totalFeesSat = prepareRes.totalFeesSat;
  // ANCHOR_END: prepare-pay-onchain
  print(totalFeesSat);
  return prepareRes;
}

Future<PreparePayOnchainResponse> preparePayOnchainDrain() async {
  // ANCHOR: prepare-pay-onchain-drain
  PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
    amount: PayAmount_Drain(),
  );
  PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
    req: preparePayOnchainRequest,
  );

  // Check if the fees are acceptable before proceeding
  BigInt totalFeesSat = prepareRes.totalFeesSat;
  // ANCHOR_END: prepare-pay-onchain-drain
  print(totalFeesSat);
  return prepareRes;
}

Future<PreparePayOnchainResponse> preparePayOnchainFeeRate() async {
  // ANCHOR: prepare-pay-onchain-fee-rate
  int optionalSatPerVbyte = 21;

  PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
    amount: PayAmount_Bitcoin(receiverAmountSat: 5000 as BigInt),
    feeRateSatPerVbyte: optionalSatPerVbyte,
  );
  PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
    req: preparePayOnchainRequest,
  );

  // Check if the fees are acceptable before proceeding
  BigInt claimFeesSat = prepareRes.claimFeesSat;
  BigInt totalFeesSat = prepareRes.totalFeesSat;
  // ANCHOR_END: prepare-pay-onchain-fee-rate
  print(claimFeesSat);
  print(totalFeesSat);
  return prepareRes;
}

Future<SendPaymentResponse> startReverseSwap({
  required PreparePayOnchainResponse prepareRes,
}) async {
  // ANCHOR: start-reverse-swap
  String destinationAddress = "bc1..";

  PayOnchainRequest req = PayOnchainRequest(
    address: destinationAddress,
    prepareResponse: prepareRes,
  );
  SendPaymentResponse res = await breezSDKLiquid.instance!.payOnchain(req: req);
  // ANCHOR_END: start-reverse-swap
  return res;
}
