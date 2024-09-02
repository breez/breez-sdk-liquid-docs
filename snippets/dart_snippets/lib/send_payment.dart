import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<SendPaymentResponse> sendPayment({required String bolt11}) async {
  // ANCHOR: send-payment
  // Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
  BigInt optionalAmountSat = BigInt.from(2000);
  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: PrepareSendRequest(destination: "Invoice, Liquid BIP21 or address", amountSat: optionalAmountSat),
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;

  SendPaymentResponse sendPaymentResponse = await breezSDKLiquid.instance!.sendPayment(
    req: SendPaymentRequest(prepareResponse: prepareSendResponse),
  );
  Payment payment = sendPaymentResponse.payment;
  // ANCHOR_END: send-payment
  print(sendFeesSat);
  print(payment);
  return sendPaymentResponse;
}
