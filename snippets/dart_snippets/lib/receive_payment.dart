import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<PrepareReceiveResponse> prepareReceivePaymentLightning() async {
  // ANCHOR: prepare-receive-payment-lightning
  // Fetch the Receive lightning limits
  LightningPaymentLimitsResponse currentLightningLimits =
      await breezSDKLiquid.instance!.fetchLightningLimits();
  print("Minimum amount: ${currentLightningLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLightningLimits.receive.maxSat} sats");

  // Create an invoice and set the amount you wish the payer to send
  ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: 5000 as BigInt);
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.lightning,
      amount: optionalAmount,
    ),
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;
  print("Fees: $receiveFeesSat sats");
  // ANCHOR_END: prepare-receive-payment-lightning
  return prepareResponse;
}

Future<PrepareReceiveResponse> prepareReceivePaymentOnchain() async {
  // ANCHOR: prepare-receive-payment-onchain
  // Fetch the Receive onchain limits
  OnchainPaymentLimitsResponse currentOnchainLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentOnchainLimits.receive.minSat} sats");
  print("Maximum amount: ${currentOnchainLimits.receive.maxSat} sats");

  // Or create a cross-chain transfer (Liquid to Bitcoin) via chain swap
  ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: 5000 as BigInt);
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.bitcoinAddress,
      amount: optionalAmount,
    ),
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;
  print("Fees: $receiveFeesSat sats");
  // ANCHOR_END: prepare-receive-payment-onchain
  return prepareResponse;
}

Future<PrepareReceiveResponse> prepareReceivePaymentLiquid() async {
  // ANCHOR: prepare-receive-payment-liquid
  // Create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  // Note: Not setting the amount will generate a plain Liquid address
  ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: 5000 as BigInt);
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.liquidAddress,
      amount: optionalAmount,
    ),
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;
  print("Fees: $receiveFeesSat sats");
  // ANCHOR_END: prepare-receive-payment-liquid
  return prepareResponse;
}

Future<ReceivePaymentResponse> receivePayment(PrepareReceiveResponse prepareResponse) async {
  // ANCHOR: receive-payment
  String optionalDescription = "<description>";
  ReceivePaymentResponse res = await breezSDKLiquid.instance!.receivePayment(
    req: ReceivePaymentRequest(
      description: optionalDescription,
      prepareResponse: prepareResponse,
    ),
  );

  String destination = res.destination;
  // ANCHOR_END: receive-payment
  print(destination);
  return res;
}
