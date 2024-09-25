package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func PrepareReceiveLightning(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-receive-payment-lightning
	// Fetch the lightning Receive limits
	if currentLimits, err := sdk.FetchLightningLimits(); err == nil {
		log.Printf("Minimum amount, in sats: %v", currentLimits.Receive.MinSat)
		log.Printf("Maximum amount, in sats: %v", currentLimits.Receive.MaxSat)
	}

	// Set the invoice amount you wish the payer to send, which should be within the above limits
	optionalPayerAmountSat := uint64(5_000)
	prepareRequest := breez_sdk_liquid.PrepareReceiveRequest{
		PaymentMethod:  breez_sdk_liquid.PaymentMethodLightning,
		PayerAmountSat: &optionalPayerAmountSat,
	}
	if prepareResponse, err := sdk.PrepareReceivePayment(prepareRequest); err == nil {
		// If the fees are acceptable, continue to create the Receive Payment
		receiveFeesSat := prepareResponse.FeesSat
		log.Printf("Fees: %v sats", receiveFeesSat)
	}
	// ANCHOR_END: prepare-receive-payment-lightning
}

func PrepareReceiveOnchain(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-receive-payment-onchain
	// Fetch the onchain Receive limits
	if currentLimits, err := sdk.FetchOnchainLimits(); err == nil {
		log.Printf("Minimum amount, in sats: %v", currentLimits.Receive.MinSat)
		log.Printf("Maximum amount, in sats: %v", currentLimits.Receive.MaxSat)
	}

	// Set the onchain amount you wish the payer to send, which should be within the above limits
	optionalPayerAmountSat := uint64(5_000)
	prepareRequest := breez_sdk_liquid.PrepareReceiveRequest{
		PaymentMethod:  breez_sdk_liquid.PaymentMethodBitcoinAddress,
		PayerAmountSat: &optionalPayerAmountSat,
	}
	if prepareResponse, err := sdk.PrepareReceivePayment(prepareRequest); err == nil {
		// If the fees are acceptable, continue to create the Receive Payment
		receiveFeesSat := prepareResponse.FeesSat
		log.Printf("Fees: %v sats", receiveFeesSat)
	}
	// ANCHOR_END: prepare-receive-payment-onchain
}

func PrepareReceiveLiquid(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-receive-payment-liquid
	// Create a Liquid BIP21 URI/address to receive a payment to.
	// There are no limits, but the payer amount should be greater than broadcast fees when specified
	// Note: Not setting the amount will generate a plain Liquid address
	optionalPayerAmountSat := uint64(5_000)
	prepareRequest := breez_sdk_liquid.PrepareReceiveRequest{
		PaymentMethod:  breez_sdk_liquid.PaymentMethodLiquidAddress,
		PayerAmountSat: &optionalPayerAmountSat,
	}
	if prepareResponse, err := sdk.PrepareReceivePayment(prepareRequest); err == nil {
		// If the fees are acceptable, continue to create the Receive Payment
		receiveFeesSat := prepareResponse.FeesSat
		log.Printf("Fees: %v sats", receiveFeesSat)
	}
	// ANCHOR_END: prepare-receive-payment-liquid
}

func ReceivePayment(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PrepareReceiveResponse) {
	// ANCHOR: receive-payment
	optionalDescription := "<description>"
	req := breez_sdk_liquid.ReceivePaymentRequest{
		PrepareResponse: prepareResponse,
		Description:     &optionalDescription,
	}
	if res, err := sdk.ReceivePayment(req); err == nil {
		// If the fees are acceptable, continue to create the Receive Payment
		destination := res.Destination
		log.Printf("Destination: %v", destination)
	}
	// ANCHOR_END: receive-payment
}
