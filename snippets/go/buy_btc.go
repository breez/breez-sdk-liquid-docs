package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func FetchOnchainLimits(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: onchain-limits
	if currentLimits, err := sdk.FetchOnchainLimits(); err == nil {
		log.Printf("Minimum amount, in sats: %v", currentLimits.Receive.MinSat)
		log.Printf("Maximum amount, in sats: %v", currentLimits.Receive.MaxSat)
	}
	// ANCHOR_END: onchain-limits
}

func PrepareBuyBtc(sdk *breez_sdk_liquid.BindingLiquidSdk, currentLimits breez_sdk_liquid.OnchainPaymentLimitsResponse) {
	// ANCHOR: prepare-buy-btc
	req := breez_sdk_liquid.PrepareBuyBitcoinRequest{
		Provider:  breez_sdk_liquid.BuyBitcoinProviderMoonpay,
		AmountSat: currentLimits.Receive.MinSat,
	}

	// Check the fees are acceptable before proceeding
	if prepareResponse, err := sdk.PrepareBuyBitcoin(req); err == nil {
		receiveFeesSat := prepareResponse.FeesSat
		log.Printf("Fees: %v sats", receiveFeesSat)
	}
	// ANCHOR_END: prepare-buy-btc
}

func BuyBtc(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PrepareBuyBitcoinResponse) {
	// ANCHOR: buy-btc
	req := breez_sdk_liquid.BuyBitcoinRequest{
		PrepareResponse: prepareResponse,
	}

	if url, err := sdk.BuyBitcoin(req); err == nil {
		log.Printf("Url: %v", url)
	}
	// ANCHOR_END: buy-btc
}
