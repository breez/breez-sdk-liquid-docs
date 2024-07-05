import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<List<FiatCurrency>> listFiatCurrencies() async {
  // ANCHOR: list-fiat-currencies
  List<FiatCurrency> fiatCurrencyList = await breezLiquidSDK.instance!.listFiatCurrencies();
  // ANCHOR_END: list-fiat-currencies
  return fiatCurrencyList;
}

Future<Map<String, Rate>> fetchFiatRates() async {
  // ANCHOR: fetch-fiat-rates
  final List<Rate> rates = await breezLiquidSDK.instance!.fetchFiatRates();
  final fiatRatesMap = rates.fold<Map<String, Rate>>({}, (map, rate) {
    map[rate.coin] = rate;
    return map;
  });
  // print your desired rate
  print(fiatRatesMap["USD"]?.value);
  // ANCHOR_END: fetch-fiat-rates
  return fiatRatesMap;
}
