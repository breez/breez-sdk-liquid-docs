package example

import (
	"context"
	"fmt"
	"log"

	breez_sdk_liquid "github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

// ANCHOR: event-listener
type MyNwcEventListener struct{}

func (l *MyNwcEventListener) OnEvent(ctx context.Context, event breez_sdk_liquid.NwcEvent) error {
	switch details := event.Details.(type) {
	case breez_sdk_liquid.NwcEventDetailsConnected:
		fmt.Println("NWC connected")
	case breez_sdk_liquid.NwcEventDetailsDisconnected:
		fmt.Println("NWC disconnected")
	case breez_sdk_liquid.NwcEventDetailsPayInvoice:
		if details.Success {
			fmt.Println("Payment successful")
		} else {
			fmt.Println("Payment failed")
		}
	case breez_sdk_liquid.NwcEventDetailsListTransactions:
		fmt.Println("Transactions requested")
	case breez_sdk_liquid.NwcEventDetailsGetBalance:
		fmt.Println("Balance requested")
	}
	return nil
}

// ANCHOR_END: event-listener

func nostrWalletConnect() error {
	// ANCHOR: nwc-config
	nwcConfig := breez_sdk_liquid.NwcConfig{
		RelayUrls:    []string{"<your-relay-url-1>"}, // Optional: Custom relay URLs (uses default if nil)
		SecretKeyHex: "your-nostr-secret-key-hex",    // Optional: Custom Nostr secret key
	}

	nwcService := breez_sdk_liquid.NewBindingNwcService(nwcConfig)

	// Add the plugin to your SDK
	plugins := []breez_sdk_liquid.Plugin{nwcService}
	// ANCHOR_END: nwc-config
	_ = plugins

	// ANCHOR: add-connection
	connectionName := "my-app-connection"
	connectionString, err := nwcService.AddConnectionString(connectionName)
	if err != nil {
		return err
	}
	// ANCHOR_END: add-connection

	// ANCHOR: list-connections
	connections, err := nwcService.ListConnectionStrings()
	if err != nil {
		return err
	}
	// ANCHOR_END: list-connections
	_ = connections

	// ANCHOR: remove-connection
	err = nwcService.RemoveConnectionString(connectionName)
	if err != nil {
		return err
	}
	// ANCHOR_END: remove-connection

	// ANCHOR: event-management
	// Add event listener
	listener := &MyNwcEventListener{}
	listenerId, err := nwcService.AddEventListener(listener)
	if err != nil {
		return err
	}

	// Remove event listener when no longer needed
	err = nwcService.RemoveEventListener(listenerId)
	if err != nil {
		return err
	}
	// ANCHOR_END: event-management

	// ANCHOR: error-handling
	connectionString, err = nwcService.AddConnectionString("test")
	if err != nil {
		switch e := err.(type) {
		case breez_sdk_liquid.NwcErrorGeneric:
			log.Printf("Generic error: %s", e.Message)
		case breez_sdk_liquid.NwcErrorPersist:
			log.Printf("Persistence error: %s", e.Message)
		default:
			log.Printf("Unknown error: %v", err)
		}
		return err
	}
	fmt.Printf("Connection created: %s", connectionString)
	// ANCHOR_END: error-handling

	return nil
}
