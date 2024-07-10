import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<ReceiveOnchainResponse> generateReceiveOnchainAddress() async {
  // ANCHOR: generate-receive-onchain-address
  // Fetch the Onchain Receive limits
  OnchainPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLimits.receive.maxSat} sats");

  // Set the amount you wish the payer to send, which should be within the above limits
  PrepareReceiveOnchainResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceiveOnchain(
    req: PrepareReceiveOnchainRequest(
      payerAmountSat: 50000 as BigInt,
    ),
  );

  // If the fees are acceptable, continue to create the Onchain Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;

  ReceiveOnchainResponse receiveOnchainResponse = await breezSDKLiquid.instance!.receiveOnchain(
    req: prepareResponse,
  );

  // Send your funds to the below bitcoin address
  String address = receiveOnchainResponse.address;
  String bip21 = receiveOnchainResponse.bip21;
  // ANCHOR_END: generate-receive-onchain-address
  print(receiveFeesSat);
  print(address);
  print(bip21);
  return receiveOnchainResponse;
}

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
