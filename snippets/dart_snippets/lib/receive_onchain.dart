import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<List<RefundableSwap>> listRefundables() async {
  // ANCHOR: list-refundables
  List<RefundableSwap> refundables = await breezSDKLiquid.instance!.listRefundables();
  // ANCHOR_END: list-refundables
  return refundables;
}

Future<RefundResponse> executeRefund({
  required int refundTxFeeRate,
  required RefundableSwap refundable,
}) async {
  // ANCHOR: execute-refund
  String destinationAddress = "...";
  int satPerVbyte = refundTxFeeRate;

  RefundRequest req = RefundRequest(
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    satPerVbyte: satPerVbyte,
  );
  RefundResponse resp = await breezSDKLiquid.instance!.refund(req: req);
  print(resp.refundTxId);
  // ANCHOR_END: execute-refund
  return resp;
}

Future rescanSwaps() async {
  // ANCHOR: rescan-swaps
  await breezSDKLiquid.instance!.rescanOnchainSwaps();
  // ANCHOR_END: rescan-swaps
}