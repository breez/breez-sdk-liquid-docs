import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<ReceivePaymentResponse> receivePayment() async {
  // ANCHOR: receive-payment
  // Fetch the Receive lightning limits
  LightningPaymentLimitsResponse currentLightningLimits =
      await breezSDKLiquid.instance!.fetchLightningLimits();
  print("Minimum amount: ${currentLightningLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLightningLimits.receive.maxSat} sats");

  // Create an invoice and set the amount you wish the payer to send
  PrepareReceiveResponse prepareResLightning =
      await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      payerAmountSat: 5000 as BigInt,
      paymentMethod: PaymentMethod.lightning,
    ),
  );

  // Fetch the Receive onchain limits
  OnchainPaymentLimitsResponse currentOnchainLimits =
      await breezSDKLiquid.instance!.fetchOnchainLimits();
  print("Minimum amount: ${currentOnchainLimits.receive.minSat} sats");
  print("Maximum amount: ${currentOnchainLimits.receive.maxSat} sats");

  // Or create a cross-chain transfer (Liquid to Bitcoin) via chain swap
  PrepareReceiveResponse prepareResBitcoin =
      await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      payerAmountSat: 5000 as BigInt,
      paymentMethod: PaymentMethod.bitcoinAddress,
    ),
  );

  // Or simply create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  PrepareReceiveResponse prepareResLiquid =
      await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      payerAmountSat: 5000
          as BigInt, // Not specifying the amount will create a plain Liquid address instead
      paymentMethod: PaymentMethod.liquidAddress,
    ),
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareResLightning.feesSat;

  String optionalDescription = "<description>";
  ReceivePaymentResponse res = await breezSDKLiquid.instance!.receivePayment(
    req: ReceivePaymentRequest(
      description: optionalDescription,
      prepareResponse: prepareResLightning,
    ),
  );

  // The output destination can then be parsed for confirmation
  InputType inputType = await parse(input: res.destination);
  if (inputType is InputType_LiquidAddress) {
    LiquidAddressData addressData = inputType.address;
    print(addressData.address);
    print(addressData.amountSat);
  }
  // ANCHOR_END: receive-payment

  print(prepareResLiquid.feesSat);
  print(prepareResBitcoin.feesSat);
  print(receiveFeesSat);
  return res;
}
