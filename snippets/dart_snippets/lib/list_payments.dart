import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<List<Payment>> listPayments() async {
  // ANCHOR: list-payments
  ListPaymentsRequest req = ListPaymentsRequest();
  List<Payment> paymentsList = await breezSDK.listPayments(req: req);
  print(paymentsList);
  // ANCHOR_END: list-payments
  return paymentsList;
}
