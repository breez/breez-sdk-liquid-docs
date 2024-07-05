import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<ReceivePaymentResponse> receivePayment() async {
  // ANCHOR: receive-payment
  ReceivePaymentRequest req = const ReceivePaymentRequest(
    amountMsat: 3000000,
    description: "Invoice for 3000 sats",
  );
  ReceivePaymentResponse receivePaymentResponse = await breezSDK.receivePayment(req: req);

  print(receivePaymentResponse.lnInvoice);
  // ANCHOR_END: receive-payment

  return receivePaymentResponse;
}
