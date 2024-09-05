package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func ListPayments(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-payments
	if payments, err := sdk.ListPayments(breez_sdk_liquid.ListPaymentsRequest{}); err == nil {
		log.Printf("%#v", payments)
	}
	// ANCHOR_END: list-payments
}

func ListPaymentsFiltered(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-payments-filtered
	filters := []breez_sdk_liquid.PaymentType{breez_sdk_liquid.PaymentTypeSend}
	fromTimestamp := int64(1696880000)
	toTimestamp := int64(1696959200)
	limit := uint32(50)
	offset := uint32(0)
	listPaymentsRequest := breez_sdk_liquid.ListPaymentsRequest{
		Filters:       &filters,
		FromTimestamp: &fromTimestamp,
		ToTimestamp:   &toTimestamp,
		Offset:        &offset,
		Limit:         &limit,
	}
	if payments, err := sdk.ListPayments(listPaymentsRequest); err == nil {
		log.Printf("%#v", payments)
	}
	// ANCHOR_END: list-payments-filtered
}
