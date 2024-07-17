import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<List<Payment>> listPayments() async {
  // ANCHOR: list-payments
  ListPaymentsRequest req = ListPaymentsRequest();
  List<Payment> paymentsList = await breezSDKLiquid.instance!.listPayments(req: req);
  // ANCHOR_END: list-payments
  return paymentsList;
}

Future<List<Payment>> listPaymentsFiltered() async {
  // ANCHOR: list-payments-filtered
  ListPaymentsRequest req = ListPaymentsRequest(
    filters: [PaymentType.send],
    fromTimestamp: 1696880000,
    toTimestamp: 1696959200,
    offset: 0,
    limit: 50,
  );
  List<Payment> paymentsList = await breezSDKLiquid.instance!.listPayments(req: req);
  // ANCHOR_END: list-payments-filtered
  return paymentsList;
}
