package example

import (
	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func CreateNwcConfig() breez_sdk_liquid.NwcConfig {
	return breez_sdk_liquid.NwcConfig{
		RelayUrls:    []string{"<your-relay-url-1>"},
		SecretKeyHex: nil,
	}
}

func CreateSdkConfig() (breez_sdk_liquid.Config, error) {
	config, err := breez_sdk_liquid.DefaultConfig(breez_sdk_liquid.LiquidNetworkTestnet, nil)
	if err != nil {
		return breez_sdk_liquid.Config{}, err
	}
	config.WorkingDir = "path to an existing directory"
	return config, nil
}

func CreateConnectRequest(config breez_sdk_liquid.Config) breez_sdk_liquid.ConnectRequest {
	mnemonic := "<your-mnemonic-here>"
	return breez_sdk_liquid.ConnectRequest{
		Config:   config,
		Mnemonic: &mnemonic,
	}
}

func ConnectWithNwcPlugin() (*breez_sdk_liquid.BindingLiquidSdk, error) {
	//ANCHOR: create-plugin-config
	// Create Plugin Config
	nwcConfig := CreateNwcConfig()

	// Initialize Plugin
	nwcService := breez_sdk_liquid.NewBindingNwcService(nwcConfig)

	// Create SDK Config
	config, err := CreateSdkConfig()
	if err != nil {
		return nil, err
	}
	plugins := []breez_sdk_liquid.Plugin{nwcService}

	// Create Connect Request
	connectRequest := CreateConnectRequest(config)

	// Connect to the SDK with the plugins
	sdk, err := breez_sdk_liquid.Connect(connectRequest, plugins)
	//ANCHOR_END: create-plugin-config
	return sdk, err
}

// ANCHOR: my-custom-plugin
type MyPlugin struct{}

func (p MyPlugin) Id() string {
	// Return the unique identifier for your plugin
	return "my-custom-plugin"
}

func (p MyPlugin) OnStart(sdk *breez_sdk_liquid.BindingLiquidSdk, storage breez_sdk_liquid.PluginStorage) error {
	// Initialize your plugin here
	return nil
}

func (p MyPlugin) OnStop() error {
	// Cleanup your plugin here
	return nil
}

//ANCHOR_END: my-custom-plugin
