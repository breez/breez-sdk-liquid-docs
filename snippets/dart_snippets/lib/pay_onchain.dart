import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> getCurrentLimits() async {
  // ANCHOR: get-current-pay-onchain-limits
  OnchainPaymentLimitsResponse currentLimits = await breezSDK.onchainPaymentLimits();
  print("Minimum amount, in sats: ${currentLimits.minSat}");
  print("Maximum amount, in sats: ${currentLimits.maxSat}");
  // ANCHOR_END: get-current-pay-onchain-limits
  return currentLimits;
}

Future<PrepareOnchainPaymentResponse> preparePayOnchain({
  required int amountSat,
  required int satPerVbyte,
}) async {
  // ANCHOR: prepare-pay-onchain
  PrepareOnchainPaymentRequest req = PrepareOnchainPaymentRequest(
    amountSat: amountSat,
    amountType: SwapAmountType.Send,
    claimTxFeerate: satPerVbyte,
  );
  PrepareOnchainPaymentResponse prepareRes = await breezSDK.prepareOnchainPayment(req: req);
  print("Sender amount: ${prepareRes.senderAmountSat} sats");
  print("Recipient amount: ${prepareRes.recipientAmountSat} sats");
  print("Total fees: ${prepareRes.totalFees} sats");
  // ANCHOR_END: prepare-pay-onchain
  return prepareRes;
}

Future<PayOnchainResponse> startReverseSwap({
  required String onchainRecipientAddress,
  required PrepareOnchainPaymentResponse prepareRes,
}) async {
  // ANCHOR: start-reverse-swap
  PayOnchainRequest req = PayOnchainRequest(
    recipientAddress: onchainRecipientAddress,
    prepareRes: prepareRes,
  );
  PayOnchainResponse res = await breezSDK.payOnchain(req: req);
  // ANCHOR_END: start-reverse-swap
  return res;
}

Future<List<ReverseSwapInfo>> checkReverseSwapStatus() async {
  // ANCHOR: check-reverse-swaps-status
  List<ReverseSwapInfo> inProgOnchainPaymentList = await breezSDK.inProgressOnchainPayments();
  for (var inProgOnchainPayment in inProgOnchainPaymentList) {
    print("Onchain payment ${inProgOnchainPayment.id} in progress, status is ${inProgOnchainPayment.status.name}");
  }
  // ANCHOR_END: check-reverse-swaps-status
  return inProgOnchainPaymentList;
}
