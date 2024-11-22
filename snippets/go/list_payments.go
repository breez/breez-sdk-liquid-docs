package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func GetPayment(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: get-payment
	paymentHash := "<payment hash>"
	req := breez_sdk_liquid.GetPaymentRequestLightning{
		PaymentHash: paymentHash,
	}
	if payment, err := sdk.GetPayment(req); err == nil {
		log.Printf("%#v", payment)
	}
	// ANCHOR_END: get-payment
}

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

func ListPaymentsDetailsAddress(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-payments-details-address
	address := "<Bitcoin address>"
	var details breez_sdk_liquid.ListPaymentDetails = breez_sdk_liquid.ListPaymentDetailsBitcoin{Address: address}
	listPaymentsRequest := breez_sdk_liquid.ListPaymentsRequest{
		Details: &details,
	}
	if payments, err := sdk.ListPayments(listPaymentsRequest); err == nil {
		log.Printf("%#v", payments)
	}
	// ANCHOR_END: list-payments-details-address
}

func ListPaymentsDetailsDestination(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-payments-details-destination
	destination := "<Liquid BIP21 or address>"
	var details breez_sdk_liquid.ListPaymentDetails = breez_sdk_liquid.ListPaymentDetailsLiquid{Destination: destination}
	listPaymentsRequest := breez_sdk_liquid.ListPaymentsRequest{
		Details: &details,
	}
	if payments, err := sdk.ListPayments(listPaymentsRequest); err == nil {
		log.Printf("%#v", payments)
	}
	// ANCHOR_END: list-payments-details-destination
}
