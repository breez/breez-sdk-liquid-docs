package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func RegisterWebhook(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: register-webook
	if err := sdk.RegisterWebhook("https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>"); err != nil {
		log.Printf("Webhook register failed: %v", err)
	}
	// ANCHOR_END: register-webook
}

func UnregisterWebhook(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: unregister-webook
	if err := sdk.UnregisterWebhook(); err != nil {
		log.Printf("Webhook unregister failed: %v", err)
	}
	// ANCHOR_END: unregister-webook
}
