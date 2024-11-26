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
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-lightning
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentLiquid() async {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  PayAmount_Receiver optionalAmount = PayAmount_Receiver(amountSat: 5000 as BigInt);
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: "<Liquid BIP21 or address>",
    amount: optionalAmount,
  );

  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-liquid
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentLiquidDrain() async {
  // ANCHOR: prepare-send-payment-liquid-drain
  // Set the Liquid BIP21 or Liquid address you wish to pay
  PayAmount_Drain optionalAmount = PayAmount_Drain();
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: "<Liquid BIP21 or address>",
    amount: optionalAmount,
  );

  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt sendFeesSat = prepareSendResponse.feesSat;
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-liquid-drain
  return prepareSendResponse;
}

Future<SendPaymentResponse> sendPayment({required PrepareSendResponse prepareResponse}) async {
  // ANCHOR: send-payment
  SendPaymentResponse sendPaymentResponse = await breezSDKLiquid.instance!.sendPayment(
    req: SendPaymentRequest(prepareResponse: prepareResponse),
  );
  Payment payment = sendPaymentResponse.payment;
  // ANCHOR_END: send-payment
  print(payment);
  return sendPaymentResponse;
}
