package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func ListFiatCurrencies(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-fiat-currencies
	if fiatCurrencies, err := sdk.ListFiatCurrencies(); err == nil {
		log.Printf("%#v", fiatCurrencies)
	}
	// ANCHOR_END: list-fiat-currencies
}

func FetchFiatRates(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: fetch-fiat-rates
	if fiatRates, err := sdk.FetchFiatRates(); err == nil {
		log.Printf("%#v", fiatRates)
	}
	// ANCHOR_END: fetch-fiat-rates
}
