package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func PrepareLnurlPay(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: prepare-lnurl-pay
	// Endpoint can also be of the form:
	// lnurlp://domain.com/lnurl-pay?key=val
	// lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
	lnurlPayUrl := "lightning@address.com"

	if input, err := sdk.Parse(lnurlPayUrl); err != nil {
		switch inputType := input.(type) {
		case breez_sdk_liquid.InputTypeLnUrlPay:
			var amount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountBitcoin{
				ReceiverAmountSat: uint64(5_000),
			}
			optionalComment := "<comment>"
			optionalValidateSuccessActionUrl := true

			req := breez_sdk_liquid.PrepareLnUrlPayRequest{
				Data:                     inputType.Data,
				Amount:                   amount,
				Comment:                  &optionalComment,
				ValidateSuccessActionUrl: &optionalValidateSuccessActionUrl,
			}
			prepareResponse, err := sdk.PrepareLnurlPay(req)
			if err != nil {
				log.Printf("Error: %#v", err)
				return
			}

			// If the fees are acceptable, continue to create the LNURL Pay
			feesSat := prepareResponse.FeesSat
			log.Printf("Fees: %v sats", feesSat)
		}
	}
	// ANCHOR_END: prepare-lnurl-pay
}

func PrepareLnurlPayDrain(sdk *breez_sdk_liquid.BindingLiquidSdk, data breez_sdk_liquid.LnUrlPayRequestData) {
	// ANCHOR: prepare-lnurl-pay-drain
	var amount breez_sdk_liquid.PayAmount = breez_sdk_liquid.PayAmountDrain{}
	optionalComment := "<comment>"
	optionalValidateSuccessActionUrl := true

	req := breez_sdk_liquid.PrepareLnUrlPayRequest{
		Data:                     data,
		Amount:                   amount,
		Comment:                  &optionalComment,
		ValidateSuccessActionUrl: &optionalValidateSuccessActionUrl,
	}
	prepareResponse, err := sdk.PrepareLnurlPay(req)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}
	// ANCHOR_END: prepare-lnurl-pay-drain
	log.Printf("prepareResponse: %#v", prepareResponse)
}

func LnurlPay(sdk *breez_sdk_liquid.BindingLiquidSdk, prepareResponse breez_sdk_liquid.PrepareLnUrlPayResponse) {
	// ANCHOR: lnurl-pay
	req := breez_sdk_liquid.LnUrlPayRequest{
		PrepareResponse: prepareResponse,
	}
	if result, err := sdk.LnurlPay(req); err != nil {
		log.Printf("Result: %#v", result)
	}
	// ANCHOR_END: lnurl-pay
}
