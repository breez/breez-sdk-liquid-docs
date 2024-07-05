import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<ReceiveOnchainResponse> generateReceiveOnchainAddress() async {
  // ANCHOR: generate-receive-onchain-address
  // Fetch the Onchain Receive limits
  OnchainPaymentLimitsResponse currentLimits = await breezLiquidSDK.instance!
    .fetchOnchainLimits();
  print("Minimum amount: ${currentLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLimits.receive.maxSat} sats");

  // Set the amount you wish the payer to send, which should be within the above limits
  PrepareReceiveOnchainResponse prepareResponse = await breezLiquidSDK.instance!
    .prepareReceiveOnchain(req: PrepareReceiveOnchainRequest (
      payerAmountSat: 50000 as BigInt,
    ));

  // If the fees are acceptable, continue to create the Onchain Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;

  ReceiveOnchainResponse receiveOnchainResponse = await breezLiquidSDK.instance!
    .receiveOnchain(req: prepareResponse);

  // Send your funds to the below bitcoin address
  String address = receiveOnchainResponse.address;
  String bip21 = receiveOnchainResponse.bip21;
  // ANCHOR_END: generate-receive-onchain-address

  return receiveOnchainResponse;
}

Future<List<RefundableSwap>> listRefundables() async {
  // ANCHOR: list-refundables
  List<RefundableSwap> refundables = await breezLiquidSDK.instance!.listRefundables();
  // ANCHOR_END: list-refundables
  return refundables;
}

Future<RefundResponse> executeRefund({
  required int refundTxFeeRate,
  required RefundableSwap refundable
}) async {
  // ANCHOR: execute-refund
  String destinationAddress = "...";
  int satPerVbyte = refundTxFeeRate;

  RefundRequest req = RefundRequest(
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    satPerVbyte: satPerVbyte,
  );
  RefundResponse resp = await breezLiquidSDK.instance!.refund(req: req);
  print(resp.refundTxId);
  // ANCHOR_END: execute-refund
  return resp;
}

Future rescanSwaps() async {
  // ANCHOR: rescan-swaps
  await breezLiquidSDK.instance!.rescanOnchainSwaps();
  // ANCHOR_END: rescan-swaps  
}
