package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func PrepareReceiveAsset(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-receive-payment-asset
	// Create a Liquid BIP21 URI/address to receive an asset payment to.
	// Note: Not setting the amount will generate an amountless BIP21 URI.
	usdtAssetId := "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
	payerAmount := float64(1.50)
	var optionalAmount breez_sdk_liquid.ReceiveAmount = breez_sdk_liquid.ReceiveAmountAsset{
		AssetId:     usdtAssetId,
		PayerAmount: &payerAmount,
	}
	prepareRequest := breez_sdk_liquid.PrepareReceiveRequest{
		PaymentMethod: breez_sdk_liquid.PaymentMethodLiquidAddress,
		Amount:        &optionalAmount,
	}
	if prepareResponse, err := sdk.PrepareReceivePayment(prepareRequest); err == nil {
		// If the fees are acceptable, continue to create the Receive Payment
		receiveFeesSat := prepareResponse.FeesSat
		log.Printf("Fees: %v sats", receiveFeesSat)
	}
	// ANCHOR_END: prepare-receive-payment-asset
}

func PrepareSendPaymentAsset(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-asset
	// Set the Liquid BIP21 or Liquid address you wish to pay
	destination := "<Liquid BIP21 or address>"
	// If the destination is an address or an amountless BIP21 URI,
	// you must specify an asset amount
	usdtAssetId := "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
	receiverAmount := float64(1.50)
	estimateAssetFees := false
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountAsset{
		AssetId:           usdtAssetId,
		ReceiverAmount:    receiverAmount,
		EstimateAssetFees: &estimateAssetFees,
	}

	prepareRequest := breez_sdk_liquid.PrepareSendRequest{
		Destination: destination,
		Amount:      &optionalAmount,
	}
	prepareResponse, err := sdk.PrepareSendPayment(prepareRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	sendFeesSat := prepareResponse.FeesSat
	log.Printf("Fees: %v sats", sendFeesSat)
	// ANCHOR_END: prepare-send-payment-asset
}

func PrepareSendPaymentAssetFees(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-asset-fees
	destination := "<Liquid BIP21 or address>"
	usdtAssetId := "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
	receiverAmount := float64(1.50)
	// Set the optional estimate asset fees param to true
	estimateAssetFees := true
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountAsset{
		AssetId:           usdtAssetId,
		ReceiverAmount:    receiverAmount,
		EstimateAssetFees: &estimateAssetFees,
	}

	prepareRequest := breez_sdk_liquid.PrepareSendRequest{
		Destination: destination,
		Amount:      &optionalAmount,
	}
	prepareResponse, err := sdk.PrepareSendPayment(prepareRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	// If the asset fees are set, you can use these fees to pay to send the asset
	sendAssetFees := prepareResponse.EstimatedAssetFees
	log.Printf("Estimated Fees: ~%v", sendAssetFees)

	// If the asset fess are not set, you can use the sats fees to pay to send the asset
	sendFeesSat := prepareResponse.FeesSat
	log.Printf("Fees: %v sats", sendFeesSat)
	// ANCHOR_END: prepare-send-payment-asset-fees
}

func SendPaymentFees(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PrepareSendResponse) {
	// ANCHOR: send-payment-fees
	// Set the use asset fees param to true
	useAssetFees := true
	req := breez_sdk_liquid.SendPaymentRequest{
		PrepareResponse: prepareResponse,
		UseAssetFees:    &useAssetFees,
	}
	if response, err := sdk.SendPayment(req); err == nil {
		payment := response.Payment
		log.Printf("Payment: %#v", payment)
	}
	// ANCHOR_END: send-payment-fees
}

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

func FetchAssetBalance(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: fetch-asset-balance
	if info, err := sdk.GetInfo(); err == nil {
		assetBalances := info.WalletInfo.AssetBalances
		log.Printf("Asset balances: %#v", assetBalances)
	}
	// ANCHOR_END: fetch-asset-balance
}
