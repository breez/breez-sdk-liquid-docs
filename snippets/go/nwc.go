package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid_nwc"
)

func NwcConnect(sdk *breez_sdk_liquid.BindingLiquidSdk) (*breez_sdk_liquid_nwc.SdkNwcService, error) {
	// ANCHOR: connecting
	nwcConfig := breez_sdk_liquid_nwc.NwcConfig{
		RelayUrls:      nil,
		SecretKeyHex:   nil,
		ListenToEvents: nil,
	}
	nwcService, err := sdk.UseNwcPlugin(nwcConfig)
	if err != nil {
		return nil, err
	}

	// ...

	// Automatically stops the plugin
	sdk.Disconnect()
	// Alternatively, you can stop the plugin manually, without disconnecting the SDK
	nwcService.Stop()
	// ANCHOR_END: connecting

	return nwcService, nil
}

func NwcAddConnection(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	// ANCHOR: add-connection
	// This connection will only allow spending at most 10,000 sats/hour
	renewalTimeMins := uint32(60)
	periodicBudgetReq := breez_sdk_liquid_nwc.PeriodicBudgetRequest{
		MaxBudgetSat:    10000,
		RenewalTimeMins: &renewalTimeMins, // Renews every hour
	}
	expiryTimeMins := uint32(60)
	req := breez_sdk_liquid_nwc.AddConnectionRequest{
		Name:               "my new connection",
		ExpiryTimeMins:     &expiryTimeMins, // Expires after one hour
		PeriodicBudgetReq:  &periodicBudgetReq,
		ReceiveOnly:        nil, // Defaults to false
	}
	addResponse, err := nwcService.AddConnection(req)
	if err != nil {
		return err
	}
	log.Printf("%s", addResponse.Connection.ConnectionString)
	// ANCHOR_END: add-connection
	return nil
}

func NwcEditConnection(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	// ANCHOR: edit-connection
	newExpiryTime := uint32(60 * 24)
	removePeriodicBudget := true
	req := breez_sdk_liquid_nwc.EditConnectionRequest{
		Name:                "my new connection",
		ExpiryTimeMins:      &newExpiryTime, // The connection will now expire after 1 day
		PeriodicBudgetReq:   nil,
		ReceiveOnly:         nil,
		RemoveExpiry:        nil,
		RemovePeriodicBudget: &removePeriodicBudget, // The periodic budget has been removed
	}
	editResponse, err := nwcService.EditConnection(req)
	if err != nil {
		return err
	}
	log.Printf("%s", editResponse.Connection.ConnectionString)
	// ANCHOR_END: edit-connection
	return nil
}

func NwcListConnections(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	// ANCHOR: list-connections
	connections, err := nwcService.ListConnections()
	if err != nil {
		return err
	}
	for connectionName, connection := range connections {
		log.Printf(
			"Connection: %s - Expires at: %v, Periodic Budget: %v",
			connectionName, connection.ExpiresAt, connection.PeriodicBudget,
		)
		// ...
	}
	// ANCHOR_END: list-connections
	return nil
}

func NwcRemoveConnection(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	// ANCHOR: remove-connection
	if err := nwcService.RemoveConnection("my new connection"); err != nil {
		return err
	}
	// ANCHOR_END: remove-connection
	return nil
}

func NwcGetInfo(nwcService *breez_sdk_liquid_nwc.SdkNwcService) {
	// ANCHOR: get-info
	info := nwcService.GetInfo()
	_ = info
	// ANCHOR_END: get-info
}

// ANCHOR: events
type MyNwcListener struct{}

func (MyNwcListener) OnEvent(event breez_sdk_liquid_nwc.NwcEvent) {
	switch details := event.Details.(type) {
	case breez_sdk_liquid_nwc.NwcEventDetailsConnected:
		// ...
	case breez_sdk_liquid_nwc.NwcEventDetailsDisconnected:
		// ...
	case breez_sdk_liquid_nwc.NwcEventDetailsConnectionExpired:
		// ...
	case breez_sdk_liquid_nwc.NwcEventDetailsConnectionRefreshed:
		// ...
	case breez_sdk_liquid_nwc.NwcEventDetailsPayInvoice:
		// details.Success, details.Preimage, details.FeesSat, details.Error
		_ = details
		// ...
	case breez_sdk_liquid_nwc.NwcEventDetailsZapReceived:
		// details.Invoice
		_ = details
		// ...
	}
}

func NwcEvents(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	eventListener := MyNwcListener{}
	myListenerId, err := nwcService.AddEventListener(eventListener)
	if err != nil {
		return err
	}
	// If you wish to remove the event_listener later on, you can call:
	nwcService.RemoveEventListener(myListenerId)
	// Otherwise, it will be automatically removed on service stop
	// ANCHOR_END: events
	return nil
}

func NwcListPayments(nwcService *breez_sdk_liquid_nwc.SdkNwcService) error {
	// ANCHOR: payments
	if _, err := nwcService.ListConnectionPayments("my new connection"); err != nil {
		return err
	}
	// ANCHOR_END: payments
	return nil
}
