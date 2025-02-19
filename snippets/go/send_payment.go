package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func PrepareSendPaymentLightningBolt11(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-lightning-bolt11
	// Set the bolt11 invoice you wish to pay
	destination := "<bolt11 invoice>"
	prepareRequest := breez_sdk_liquid.PrepareSendRequest{
		Destination: destination,
	}
	prepareResponse, err := sdk.PrepareSendPayment(prepareRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	sendFeesSat := prepareResponse.FeesSat
	log.Printf("Fees: %v sats", sendFeesSat)
	// ANCHOR_END: prepare-send-payment-lightning-bolt11
}

func PrepareSendPaymentLightningBolt12(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-lightning-bolt12
	// Set the bolt12 offer you wish to pay
	destination := "<bolt12 offer>"
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountBitcoin{
		ReceiverAmountSat: uint64(5_000),
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
	// ANCHOR_END: prepare-send-payment-lightning-bolt12
	log.Printf("prepareResponse: %v", prepareResponse)
}

func PrepareSendPaymentLiquid(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-liquid
	// Set the Liquid BIP21 or Liquid address you wish to pay
	destination := "<Liquid BIP21 or address>"
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountBitcoin{
		ReceiverAmountSat: uint64(5_000),
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
	// ANCHOR_END: prepare-send-payment-liquid
}

func PrepareSendPaymentLiquidDrain(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-liquid-drain
	// Set the Liquid BIP21 or Liquid address you wish to pay
	destination := "<Liquid BIP21 or address>"
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountDrain{}

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
	// ANCHOR_END: prepare-send-payment-liquid-drain
}

func SendPayment(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PrepareSendResponse) {
	// ANCHOR: send-payment
	req := breez_sdk_liquid.SendPaymentRequest{
		PrepareResponse: prepareResponse,
	}
	if response, err := sdk.SendPayment(req); err == nil {
		payment := response.Payment
		log.Printf("Payment: %#v", payment)
	}
	// ANCHOR_END: send-payment
}
