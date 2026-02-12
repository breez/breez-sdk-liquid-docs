package example

import (
	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

// ANCHOR: self-signer
func ConnectWithSelfSigner(signer breez_sdk_liquid.Signer) (*breez_sdk_liquid.BindingLiquidSdk, error) {

	// Create the default config, providing your Breez API key
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return nil, err
	}

	// Customize the config object according to your needs
	config.WorkingDir = "path to an existing directory"

	connectRequest := breez_sdk_liquid.ConnectWithSignerRequest{
		Config: config,
	}

	sdk, err := breez_sdk_liquid.ConnectWithSigner(connectRequest, signer, nil)

	return sdk, err
}

// ANCHOR_END: self-signer
