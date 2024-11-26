package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func PrepareSendPaymentLightning(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-lightning
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
	// ANCHOR_END: prepare-send-payment-lightning
}

func PrepareSendPaymentLiquid(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-send-payment-liquid
	// Set the Liquid BIP21 or Liquid address you wish to pay
	destination := "<Liquid BIP21 or address>"
	var optionalAmount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountReceiver{AmountSat: uint64(5_000)}

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
