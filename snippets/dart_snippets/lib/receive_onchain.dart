import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<SwapInfo> generateReceiveOnchainAddress() async {
  // ANCHOR: generate-receive-onchain-address
  ReceiveOnchainRequest req = const ReceiveOnchainRequest();
  SwapInfo swapInfo = await breezSDK.receiveOnchain(req: req);

  // Send your funds to the below bitcoin address
  String address = swapInfo.bitcoinAddress;
  print(address);
  print("Minimum amount allowed to deposit in sats: ${swapInfo.minAllowedDeposit}");
  print("Maximum amount allowed to deposit in sats: ${swapInfo.maxAllowedDeposit}");
  return swapInfo;
  // ANCHOR_END: generate-receive-onchain-address
}

Future<SwapInfo?> getInProgressSwap() async {
  // ANCHOR: in-progress-swap
  SwapInfo? swapInfo = await breezSDK.inProgressSwap();
  print(swapInfo);
  // ANCHOR_END: in-progress-swap
  return swapInfo;
}

Future<List<SwapInfo>> listRefundables() async {
  // ANCHOR: list-refundables
  List<SwapInfo> refundables = await breezSDK.listRefundables();
  for (var refundable in refundables) {
    print(refundable.bitcoinAddress);
  }
  // ANCHOR_END: list-refundables
  return refundables;
}

Future<RefundResponse> executeRefund({
  required String swapAddress,
  required String toAddress,
  required int satPerVbyte,
}) async {
  // ANCHOR: execute-refund
  RefundRequest req = RefundRequest(
    swapAddress: swapAddress,
    toAddress: toAddress,
    satPerVbyte: satPerVbyte,
  );
  RefundResponse resp = await breezSDK.refund(req: req);
  print(resp.refundTxId);
  // ANCHOR_END: execute-refund
  return resp;
}

Future<OpenChannelFeeResponse> getChannelOpeningFees({
  required int amountMsat,
  int? expiry,
}) async {
  // ANCHOR: get-channel-opening-fees
  OpenChannelFeeRequest req = OpenChannelFeeRequest(amountMsat: amountMsat, expiry: expiry);
  OpenChannelFeeResponse resp = await breezSDK.openChannelFee(req: req);
  print(resp.feeMsat);
  // ANCHOR_END: get-channel-opening-fees
  return resp;
}

Future rescanSwaps() async {
  // ANCHOR: rescan-swaps
  await breezSDK.rescanSwaps();  
  // ANCHOR_END: rescan-swaps  
}
