import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> configureAssetMatedata() async {
  // ANCHOR: configure-asset-metadata
  // Create the default config
  Config config = defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>");

  // Configure asset metadata. Setting the optional fiat ID will enable
  // paying fees using the asset (if available).
  config = config.copyWith(
    assetMetadata: [
      AssetMetadata(
        assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
        name: "PEGx EUR",
        ticker: "EURx",
        precision: 8,
        fiatId: "EUR",
      ),
    ],
  );
  // ANCHOR_END: configure-asset-metadata
}

Future<void> configureParsers() async {
  // ANCHOR: configure-external-parser
  // Create the default config
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
  // ANCHOR_END: configure-external-parser
}

Future<void> configureMagicRoutingHints() async {
  // ANCHOR: configure-magic-routing-hints
  // Create the default config
  Config config = defaultConfig(
    network: LiquidNetwork.mainnet,
    breezApiKey: "<your-Breez-API-key>",
  );

  // Configure magic routing hints
  config = config.copyWith(
    useMagicRoutingHints: false,
  );
  // ANCHOR_END: configure-magic-routing-hints
}
