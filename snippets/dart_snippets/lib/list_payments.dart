import 'package:flutter_breez_liquid/breez_liquid.dart';
import 'package:flutter_breez_liquid/bridge_generated.dart';

Future<List<Payment>> listPayments() async {
  // ANCHOR: list-payments
  ListPaymentsRequest req = ListPaymentsRequest();
  List<Payment> paymentsList = await breezSDK.listPayments(req: req);
  print(paymentsList);
  // ANCHOR_END: list-payments
  return paymentsList;
}

Future<List<Payment>> listPaymentsFiltered({
  int? fromTimestamp,
  int? toTimestamp,
  bool? includeFailures,
  int? offset,
  int? limit,
}) async {
  // ANCHOR: list-payments-filtered
  /// Get the desired epoch timestamp in seconds
  int fromTimestamp = DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000;

  ListPaymentsRequest req = ListPaymentsRequest(
    filters: [PaymentTypeFilter.Sent],
    fromTimestamp: fromTimestamp,
    toTimestamp: toTimestamp,
    includeFailures: includeFailures,
    offset: offset,
    limit: limit,
  );
  List<Payment> paymentsList = await breezSDK.listPayments(req: req);
  print(paymentsList);
  // ANCHOR_END: list-payments-filtered
  return paymentsList;
}
