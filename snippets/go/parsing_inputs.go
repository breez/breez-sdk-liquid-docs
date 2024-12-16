package example

import (
	"log"
	"strconv"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func ParseInput(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: parse-inputs
	input := "an input to be parsed..."

	if input, err := sdk.Parse(input); err == nil {
		switch inputType := input.(type) {
		case breez_sdk_liquid.InputTypeBitcoinAddress:
			log.Printf("Input is Bitcoin address %s", inputType.Address.Address)

		case breez_sdk_liquid.InputTypeBolt11:
			amount := "unknown"
			if inputType.Invoice.AmountMsat != nil {
				amount = strconv.FormatUint(*inputType.Invoice.AmountMsat, 10)
			}
			log.Printf("Input is BOLT11 invoice for %s msats", amount)

		case breez_sdk_liquid.InputTypeLnUrlPay:
			log.Printf("Input is LNURL-Pay/Lightning address accepting min/max %d/%d msats",
				inputType.Data.MinSendable, inputType.Data.MaxSendable)

		case breez_sdk_liquid.InputTypeLnUrlWithdraw:
			log.Printf("Input is LNURL-Withdraw for min/max %d/%d msats",
				inputType.Data.MinWithdrawable, inputType.Data.MaxWithdrawable)

		default:
			// Other input types are available
		}
	}
	// ANCHOR_END: parse-inputs
}

func ConfigureParsers() (*breez_sdk_liquid.BindingLiquidSdk, error) {
	// ANCHOR: configure-external-parser
	mnemonic := "<mnemonic words>"

	// Create the default config, providing your Breez API key
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return nil, err
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

	connectRequest := breez_sdk_liquid.ConnectRequest{
		Config:   config,
		Mnemonic: mnemonic,
	}

	sdk, err := breez_sdk_liquid.Connect(connectRequest)

	return sdk, err
	// ANCHOR_END: configure-external-parser
}
