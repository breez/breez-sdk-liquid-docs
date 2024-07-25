import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<ReceivePaymentResponse> receivePayment() async {
  // ANCHOR: receive-payment
  // Fetch the Receive limits
  LightningPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchLightningLimits();
  print("Minimum amount: ${currentLimits.receive.minSat} sats");
  print("Maximum amount: ${currentLimits.receive.maxSat} sats");

  // Set the amount you wish the payer to send
  PrepareReceivePaymentResponse prepareRes = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceivePaymentRequest(
      payerAmountSat: 5000 as BigInt,
    ),
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareReceiveResponse.feesSat;

  String optionalDescription = "<description>";
  ReceivePaymentResponse res = await breezSDKLiquid.instance!.receivePayment(
    req: ReceivePaymentRequest(
      prepareRes: prepareRes,
      description: optionalDescription,
    ),
  );

  String invoice = res.invoice;
  // ANCHOR_END: receive-payment
  print(receiveFeesSat);
  print(invoice);
  return res;
}
