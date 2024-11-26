import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<Payment?> getPayment() async {
  // ANCHOR: get-payment
  String paymentHash = "<payment hash>";
  GetPaymentRequest req = GetPaymentRequest.lightning(paymentHash: paymentHash);
  Payment? payment = await breezSDKLiquid.instance!.getPayment(req: req);
  // ANCHOR_END: get-payment
  return payment;
}

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

Future<List<Payment>> listPaymentsDetailsAddress() async {
  // ANCHOR: list-payments-details-address
  String address = "<Bitcoin address>";
  ListPaymentsRequest req = ListPaymentsRequest(
    details: ListPaymentDetails_Bitcoin(address: address),
  );
  List<Payment> paymentsList = await breezSDKLiquid.instance!.listPayments(req: req);
  // ANCHOR_END: list-payments-details-address
  return paymentsList;
}

Future<List<Payment>> listPaymentsDetailsDestination() async {
  // ANCHOR: list-payments-details-destination
  String destination = "<Liquid BIP21 or address>";
  ListPaymentsRequest req = ListPaymentsRequest(
    details: ListPaymentDetails_Liquid(destination: destination),
  );
  List<Payment> paymentsList = await breezSDKLiquid.instance!.listPayments(req: req);
  // ANCHOR_END: list-payments-details-destination
  return paymentsList;
}
