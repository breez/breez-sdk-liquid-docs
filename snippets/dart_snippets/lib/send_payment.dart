import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<PrepareSendResponse> prepareSendPaymentLightningBolt11() async {
  // ANCHOR: prepare-send-payment-lightning-bolt11
  // Set the bolt11 invoice you wish to pay
  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: PrepareSendRequest(destination: "<bolt11 invoice>"),
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt? sendFeesSat = prepareSendResponse.feesSat;
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-lightning-bolt11
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentLightningBolt12() async {
  // ANCHOR: prepare-send-payment-lightning-bolt12
  // Set the bolt12 offer you wish to pay
  PayAmount_Bitcoin optionalAmount = PayAmount_Bitcoin(receiverAmountSat: 5000 as BigInt);
  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: PrepareSendRequest(destination: "<bolt12 offer>", amount: optionalAmount),
  );
  // ANCHOR_END: prepare-send-payment-lightning-bolt12
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentLiquid() async {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  PayAmount_Bitcoin optionalAmount = PayAmount_Bitcoin(receiverAmountSat: 5000 as BigInt);
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: "<Liquid BIP21 or address>",
    amount: optionalAmount,
  );

  PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt? sendFeesSat = prepareSendResponse.feesSat;
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
  BigInt? sendFeesSat = prepareSendResponse.feesSat;
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
