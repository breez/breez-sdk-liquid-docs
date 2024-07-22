import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> fetchOnchainLimits() async {
  // ANCHOR: onchain-limits
  OnchainPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLimits.receive.maxSat} sats");
  // ANCHOR_END: onchain-limits
  print(currentLimits);
  return currentLimits;
}

Future<PrepareBuyBitcoinResponse> prepareBuyBitcoin(currentLimits: OnchainPaymentLimitsResponse) async {
  // ANCHOR: prepare-buy-btc
  PrepareBuyBitcoinRequest req = const PrepareBuyBitcoinRequest(
    provider: BuyBitcoinProvider.Moonpay,
    amountSat: currentLimits.receive.minSat
  );
  PrepareBuyBitcoinResponse prepareRes = await breezSDKLiquid.instance!.prepareBuyBitcoin(req: req);

  // Check the fees are acceptable before proceeding
  BigInt receiveFeesSat = prepareRes.feesSat;
  print("Fees: ${receiveFeesSat} sats");
  // ANCHOR_END: prepare-buy-btc
  return prepareRes;
}

Future<String> buyBitcoin(prepareRes: PrepareBuyBitcoinResponse) async {
  // ANCHOR: buy-btc
  BuyBitcoinRequest req = const BuyBitcoinRequest(prepareRes: prepareRes);
  String url = await breezSDKLiquid.instance!.buyBitcoin(req: req);
  // ANCHOR_END: buy-btc
  return url;
}
