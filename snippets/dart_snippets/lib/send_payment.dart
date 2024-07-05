import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<SendPaymentResponse> sendPayment({required String bolt11}) async {
  // ANCHOR: send-payment
  // Set the BOLT11 invoice you wish to pay
  PrepareSendResponse prepareSendResponse = await breezLiquidSDK.instance!
    .prepareSendPayment(
      req: PrepareSendRequest(invoice: "...")
    );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;

  SendPaymentResponse sendPaymentResponse = await breezLiquidSDK.instance!
    .sendPayment(req: prepareSendResponse);
  Payment payment = sendPaymentResponse.payment;
  // ANCHOR_END: send-payment
  return sendPaymentResponse;
}
