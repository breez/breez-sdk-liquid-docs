import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> parseInput() async {
  // ANCHOR: parse-inputs
  String input = "an input to be parsed...";

  InputType inputType = await breezSDKLiquid.instance!.parse(input: input);
  if (inputType is InputType_BitcoinAddress) {
    print("Input is Bitcoin address ${inputType.address.address}");
  } else if (inputType is InputType_Bolt11) {
    String amountStr =
        inputType.invoice.amountMsat != null ? inputType.invoice.amountMsat.toString() : "unknown";
    print("Input is BOLT11 invoice for $amountStr msats");
  } else if (inputType is InputType_LnUrlPay) {
    print(
        "Input is LNURL-Pay/Lightning address accepting min/max ${inputType.data.minSendable}/${inputType.data.maxSendable} msats - BIP353 was used: ${inputType.bip353Address != null}");
  } else if (inputType is InputType_LnUrlWithdraw) {
    print(
        "Input is LNURL-Withdraw for min/max ${inputType.data.minWithdrawable}/${inputType.data.maxWithdrawable} msats");
  } else {
    // Other input types are available
  }
  // ANCHOR_END: parse-inputs
}

Future<void> configureParsers() async {
  // ANCHOR: configure-external-parser
  // Create the default config
  String mnemonic = "<mnemonic words>";

  // Create the default config, providing your Breez API key
  Config config = defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>");

  // Configure external parsers
  config = config.copyWith(
    externalInputParsers: [
      ExternalInputParser(
        providerId: "provider_a",
        inputRegex: "^provider_a",
        parserUrl: "https://parser-domain.com/parser?input=<input>",
      ),
      ExternalInputParser(
        providerId: "provider_b",
        inputRegex: "^provider_b",
        parserUrl: "https://parser-domain.com/parser?input=<input>",
      ),
    ],
  );

  ConnectRequest connectRequest = ConnectRequest(mnemonic: mnemonic, config: config);

  await breezSDKLiquid.connect(req: connectRequest);

  // ANCHOR_END: configure-external-parser
}
