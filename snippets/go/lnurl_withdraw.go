package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func LnurlWithdraw(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: lnurl-withdraw
	// Endpoint can also be of the form:
	// lnurlw://domain.com/lnurl-withdraw?key=val
	lnurlWithdrawUrl := "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk"

	if input, err := sdk.Parse(lnurlWithdrawUrl); err != nil {
		switch inputType := input.(type) {
		case breez_sdk_liquid.InputTypeLnUrlWithdraw:
			amountMsat := inputType.Data.MinWithdrawable
			description := "comment"
			if result, err := sdk.LnurlWithdraw(breez_sdk_liquid.LnUrlWithdrawRequest{
				Data:        inputType.Data,
				AmountMsat:  amountMsat,
				Description: &description,
			}); err != nil {
				switch result.(type) {
				case breez_sdk_liquid.LnUrlCallbackStatusOk:
					log.Printf("Successfully withdrawn")
				default:
					log.Printf("Failed to withdraw")
				}
			}
		}
	}
	// ANCHOR_END: lnurl-withdraw
}
