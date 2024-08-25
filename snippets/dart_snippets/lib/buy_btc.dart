import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> fetchOnchainLimits() async {
  // ANCHOR: onchain-limits
  OnchainPaymentLimitsResponse currentLimits =
      await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLimits.receive.maxSat} sats");
  // ANCHOR_END: onchain-limits
  print(currentLimits);
  return currentLimits;
}

Future<PrepareBuyBitcoinResponse> prepareBuyBitcoin(
    OnchainPaymentLimitsResponse currentLimits) async {
  // ANCHOR: prepare-buy-btc
  PrepareBuyBitcoinRequest req = PrepareBuyBitcoinRequest(
      provider: BuyBitcoinProvider.moonpay,
      amountSat: currentLimits.receive.minSat);
  PrepareBuyBitcoinResponse prepareRes =
      await breezSDKLiquid.instance!.prepareBuyBitcoin(req: req);

  // Check the fees are acceptable before proceeding
  BigInt receiveFeesSat = prepareRes.feesSat;
  print("Fees: ${receiveFeesSat} sats");
  // ANCHOR_END: prepare-buy-btc
  return prepareRes;
}

Future<String> buyBitcoin(PrepareBuyBitcoinResponse prepareResponse) async {
  // ANCHOR: buy-btc
  BuyBitcoinRequest req = BuyBitcoinRequest(prepareResponse: prepareResponse);
  String url = await breezSDKLiquid.instance!.buyBitcoin(req: req);
  // ANCHOR_END: buy-btc
  return url;
}
