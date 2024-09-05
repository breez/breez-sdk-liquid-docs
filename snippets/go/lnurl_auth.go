package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func LnurlAuth(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: lnurl-auth
	// keyauth://domain.com/auth?key=val
	lnurlAuthUrl := "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu"

	if input, err := breez_sdk_liquid.Parse(lnurlAuthUrl); err != nil {
		switch inputType := input.(type) {
		case breez_sdk_liquid.InputTypeLnUrlAuth:
			if result, err := sdk.LnurlAuth(inputType.Data); err != nil {
				switch result.(type) {
				case breez_sdk_liquid.LnUrlCallbackStatusOk:
					log.Printf("Successfully authenticated")
				default:
					log.Printf("Failed to authenticate")
				}
			}
		}
	}
	// ANCHOR_END: lnurl-auth
}
