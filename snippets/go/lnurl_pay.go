package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func LnurlPay(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: lnurl-pay
	// Endpoint can also be of the form:
	// lnurlp://domain.com/lnurl-pay?key=val
	// lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
	lnurlPayUrl := "lightning@address.com"

	if input, err := breez_sdk_liquid.Parse(lnurlPayUrl); err != nil {
		switch inputType := input.(type) {
		case breez_sdk_liquid.InputTypeLnUrlPay:
			amountMsat := inputType.Data.MinSendable
			optionalComment := "<comment>"
			optionalPaymentLabel := "<label>"
			lnUrlPayRequest := breez_sdk_liquid.LnUrlPayRequest{
				Data:         inputType.Data,
				AmountMsat:   amountMsat,
				Comment:      &optionalComment,
				PaymentLabel: &optionalPaymentLabel,
			}
			if result, err := sdk.LnurlPay(lnUrlPayRequest); err != nil {
				switch result.(type) {
				case breez_sdk_liquid.LnUrlPayResultEndpointSuccess:
					log.Printf("Successfully paid")
				default:
					log.Printf("Failed to pay")
				}
			}
		}
	}
	// ANCHOR_END: lnurl-pay
}
