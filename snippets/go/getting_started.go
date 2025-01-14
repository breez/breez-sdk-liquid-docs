package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func Start() (*breez_sdk_liquid.BindingLiquidSdk, error) {
	// ANCHOR: init-sdk
	mnemonic := "<mnemonic words>"

	// Create the default config, providing your Breez API key
	breezApiKey := "<your-Breez-API-key>"
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkMainnet, &breezApiKey)
	if err != nil {
		return nil, err
	}

	// Customize the config object according to your needs
	config.WorkingDir = "path to an existing directory"

	connectRequest := breez_sdk_liquid.ConnectRequest{
		Config:   config,
		Mnemonic: mnemonic,
	}

	sdk, err := breez_sdk_liquid.Connect(connectRequest)

	return sdk, err
	// ANCHOR_END: init-sdk
}

func FetchBalance(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: fetch-balance
	if info, err := sdk.GetInfo(); err == nil {
		balanceSat := info.WalletInfo.BalanceSat
		pendingSendSat := info.WalletInfo.PendingSendSat
		pendingReceiveSat := info.WalletInfo.PendingReceiveSat
		log.Printf("Balance: %v sats", balanceSat)
		log.Printf("Pending: send %v sats, receive %v sats", pendingSendSat, pendingReceiveSat)
	}
	// ANCHOR_END: fetch-balance
}

// ANCHOR: logging
type SdkLogger struct{}

func (SdkLogger) Log(l breez_sdk_liquid.LogEntry) {
	log.Printf("Received log [%v]: %v", l.Level, l.Line)
}

func SetLogger(logger SdkLogger) {
	breez_sdk_liquid.SetLogger(logger)
}

// ANCHOR_END: logging

// ANCHOR: add-event-listener
type SdkListener struct{}

func (SdkListener) OnEvent(e breez_sdk_liquid.SdkEvent) {
	log.Printf("Received event %#v", e)
}

func AddEventListener(sdk *breez_sdk_liquid.BindingLiquidSdk, listener SdkListener) (string, error) {
	return sdk.AddEventListener(listener)
}

// ANCHOR_END: add-event-listener

// ANCHOR: remove-event-listener
func RemoveEventListener(sdk *breez_sdk_liquid.BindingLiquidSdk, listenerId string) error {
	return sdk.RemoveEventListener(listenerId)
}

// ANCHOR_END: remove-event-listener

// ANCHOR: disconnect
func Disconnect(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	sdk.Disconnect()
}

// ANCHOR_END: disconnect
