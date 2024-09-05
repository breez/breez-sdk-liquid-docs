import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<PrepareSendResponse> prepareSendPaymentLightning() async {
  // ANCHOR: prepare-send-payment-lightning
  // Set the bolt11 invoice you wish to pay
  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: PrepareSendRequest(destination: "<bolt11 invoice>"),
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;
  // ANCHOR_END: prepare-send-payment-lightning
  print(sendFeesSat);
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentLiquid() async {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  BigInt optionalAmountSat = BigInt.from(5000);

  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: PrepareSendRequest(destination: "<Liquid BIP21 or address>", amountSat: optionalAmountSat),
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;
  // ANCHOR_END: prepare-send-payment-liquid
  print(sendFeesSat);
  return prepareSendResponse;
}

Future<SendPaymentResponse> sendPayment({required PrepareSendResponse prepareResponse}) async {
  // ANCHOR: send-payment
  SendPaymentResponse sendPaymentResponse = await breezSDKLiquid.instance!.sendPayment(
    req: SendPaymentRequest(prepareResponse: prepareResponse),
  );
  Payment payment = sendPaymentResponse.payment;
  // ANCHOR_END: send-payment
  print(sendFeesSat);
  print(payment);
  return sendPaymentResponse;
}
