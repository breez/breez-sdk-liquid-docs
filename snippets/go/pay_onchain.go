package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func GetCurrentRevSwapLimits(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: get-current-pay-onchain-limits
	if currentLimits, err := sdk.FetchOnchainLimits(); err == nil {
		log.Printf("Minimum amount, in sats: %v", currentLimits.Send.MinSat)
		log.Printf("Maximum amount, in sats: %v", currentLimits.Send.MaxSat)
	}
	// ANCHOR_END: get-current-pay-onchain-limits
}

func PreparePayOnchain(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-pay-onchain
	amount := breez_sdk_liquid.PayOnchainAmountReceiver{AmountSat: 5_000}
	prepareRequest := breez_sdk_liquid.PreparePayOnchainRequest{
		Amount: amount,
	}

	if prepareResponse, err := sdk.PreparePayOnchain(prepareRequest); err == nil {
		// Check if the fees are acceptable before proceeding
		totalFeesSat := prepareResponse.TotalFeesSat
		log.Printf("Fees: %v sats", totalFeesSat)
	}
	// ANCHOR_END: prepare-pay-onchain
}

func PreparePayOnchainDrain(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-pay-onchain-drain
	amount := breez_sdk_liquid.PayOnchainAmountDrain{}
	prepareRequest := breez_sdk_liquid.PreparePayOnchainRequest{
		Amount: amount,
	}

	if prepareResponse, err := sdk.PreparePayOnchain(prepareRequest); err == nil {
		// Check if the fees are acceptable before proceeding
		totalFeesSat := prepareResponse.TotalFeesSat
		log.Printf("Fees: %v sats", totalFeesSat)
	}
	// ANCHOR_END: prepare-pay-onchain-drain
}

func PreparePayOnchainFeeRate(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-pay-onchain-fee-rate
	amount := breez_sdk_liquid.PayOnchainAmountReceiver{AmountSat: 5_000}
	optionalSatPerVbyte := uint32(21)
	prepareRequest := breez_sdk_liquid.PreparePayOnchainRequest{
		Amount:             amount,
		FeeRateSatPerVbyte: &optionalSatPerVbyte,
	}

	if prepareResponse, err := sdk.PreparePayOnchain(prepareRequest); err == nil {
		// Check if the fees are acceptable before proceeding
		claimFeesSat := prepareResponse.ClaimFeesSat
		totalFeesSat := prepareResponse.TotalFeesSat
		log.Printf("Claim fees: %v sats, total fees: %v sats", claimFeesSat, totalFeesSat)
	}
	// ANCHOR_END: prepare-pay-onchain-fee-rate
}

func StartReverseSwap(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PreparePayOnchainResponse) {
	// ANCHOR: start-reverse-swap
	address := "bc1.."
	payOnchainRequest := breez_sdk_liquid.PayOnchainRequest{
		Address:         address,
		PrepareResponse: prepareResponse,
	}

	if reverseSwapInfo, err := sdk.PayOnchain(payOnchainRequest); err == nil {
		log.Printf("%#v", reverseSwapInfo)
	}
	// ANCHOR_END: start-reverse-swap
}
