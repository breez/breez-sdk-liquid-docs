package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func SendPayment(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: send-payment
	// Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
	destination := "Invoice, Liquid BIP21 or address"
	optionalAmountSat := uint64(5_000)
	prepareRequest := breez_sdk_liquid.PrepareSendRequest{
		Destination: destination,
		AmountSat:   &optionalAmountSat,
	}
	prepareResponse, err := sdk.PrepareSendPayment(prepareRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	sendFeesSat := prepareResponse.FeesSat
	log.Printf("Fees: %v sats", sendFeesSat)

	req := breez_sdk_liquid.SendPaymentRequest{
		PrepareResponse: prepareResponse,
	}
	if response, err := sdk.SendPayment(req); err == nil {
		payment := response.Payment
		log.Printf("Payment: %#v", payment)
	}
	// ANCHOR_END: send-payment
}
