package example

import (
	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func NostrWalletConnect() {
	// ANCHOR: init-nwc
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return
	}

	config.EnableNwc = true

	// Optional: You can specify your own Relay URLs
	config.NwcRelayUrls = []string{"<your-relay-url-1>"}
	// ANCHOR_END: init-nwc
	
	// ANCHOR: create-connection-string
	nwcConnectionUri, err := sdk.GetNwcUri()
	if err != nil {
		return
	}
	// ANCHOR_END: create-connection-string
} 