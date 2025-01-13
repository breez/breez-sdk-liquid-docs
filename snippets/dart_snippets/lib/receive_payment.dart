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
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.lightning,
      payerAmountSat: 5000 as BigInt,
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
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.bitcoinAddress,
      payerAmountSat: 5000 as BigInt,
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
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.liquidAddress,
      payerAmountSat: 5000 as BigInt, // Not specifying the amount will create a plain Liquid address instead
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
