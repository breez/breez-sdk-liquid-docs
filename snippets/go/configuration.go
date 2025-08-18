package example

import (
	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func ConfigureAssetMetadata() error {
	// ANCHOR: configure-asset-metadata
	// Create the default config
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return err
	}

	// Configure asset metadata. Setting the optional fiat ID will enable
	// paying fees using the asset (if available).
	fiatId := "EUR"
	assetMetadata := []breez_sdk_liquid.AssetMetadata{
		{
			AssetId:   "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
			Name:      "PEGx EUR",
			Ticker:    "EURx",
			Precision: 8,
			FiatId:    &fiatId,
		},
	}
	config.AssetMetadata = &assetMetadata
	// ANCHOR_END: configure-asset-metadata
	return nil
}

func ConfigureParsers() error {
	// ANCHOR: configure-external-parser
	// Create the default config
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return err
	}

	// Configure external parsers
	parsers := []breez_sdk_liquid.ExternalInputParser{
		{
			ProviderId: "provider_a",
			InputRegex: "^provider_a",
			ParserUrl:  "https://parser-domain.com/parser?input=<input>",
		},
		{
			ProviderId: "provider_b",
			InputRegex: "^provider_b",
			ParserUrl:  "https://parser-domain.com/parser?input=<input>",
		},
	}
	config.ExternalInputParsers = &parsers
	// ANCHOR_END: configure-external-parser
	return nil
}

func ConfigureMagicRoutingHints() error {
	// ANCHOR: configure-magic-routing-hints
	// Create the default config
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return err
	}

	// Configure magic routing hints
	config.UseMagicRoutingHints = false
	// ANCHOR_END: configure-magic-routing-hints
	return nil
}
