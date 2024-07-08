import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<List<Payment>> listPayments() async {
  // ANCHOR: list-payments
  List<Payment> paymentsList = await breezLiquidSDK.instance!.listPayments();
  // ANCHOR_END: list-payments
  return paymentsList;
}
