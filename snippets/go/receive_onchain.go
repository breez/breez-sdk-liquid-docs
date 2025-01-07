package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func ListRefundables(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: list-refundables
	if refundables, err := sdk.ListRefundables(); err == nil {
		log.Printf("%#v", refundables)
	}
	// ANCHOR_END: list-refundables
}

func ExecuteRefund(sdk *breez_sdk_liquid.BindingLiquidSdk, refundTxFeeRate uint32, refundable breez_sdk_liquid.RefundableSwap) {
	// ANCHOR: execute-refund
	destinationAddress := "..."
	feeRateSatPerVbyte := refundTxFeeRate
	refundRequest := breez_sdk_liquid.RefundRequest{
		SwapAddress:        refundable.SwapAddress,
		RefundAddress:      destinationAddress,
		FeeRateSatPerVbyte: feeRateSatPerVbyte,
	}

	if result, err := sdk.Refund(refundRequest); err == nil {
		log.Printf("%v", result)
	}
	// ANCHOR_END: execute-refund
}

func RescanSwaps(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: rescan-swaps
	if err := sdk.RescanOnchainSwaps(); err == nil {
		log.Println("Rescan finished")
	}
	// ANCHOR_END: rescan-swaps
}

func RecommendedFees(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: recommended-fees
	if fees, err := sdk.RecommendedFees(); err == nil {
		log.Printf("%v", fees)
	}
	// ANCHOR_END: recommended-fees
}

func HandlePaymentsWaitingFeeAcceptance(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: handle-payments-waiting-fee-acceptance
	// Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
	request := breez_sdk_liquid.ListPaymentsRequest{
		States: &[]breez_sdk_liquid.PaymentState{breez_sdk_liquid.PaymentStateWaitingFeeAcceptance},
	}

	paymentsWaitingFeeAcceptance, err := sdk.ListPayments(request)
	if err != nil {
		return
	}

	for _, payment := range paymentsWaitingFeeAcceptance {
		bitcoinPayment, ok := payment.Details.(breez_sdk_liquid.PaymentDetailsBitcoin)
		if !ok {
			// Only Bitcoin payments can be `WaitingFeeAcceptance`
			continue
		}

		fetchFeesRequest := breez_sdk_liquid.FetchPaymentProposedFeesRequest{
			SwapId: bitcoinPayment.SwapId,
		}

		fetchFeesResponse, err := sdk.FetchPaymentProposedFees(fetchFeesRequest)
		if err != nil {
			continue
		}

		log.Printf("Payer sent %d and currently proposed fees are %d",
			fetchFeesResponse.PayerAmountSat, fetchFeesResponse.FeesSat)

		// If the user is ok with the fees, accept them, allowing the payment to proceed
		acceptFeesRequest := breez_sdk_liquid.AcceptPaymentProposedFeesRequest{
			Response: fetchFeesResponse,
		}
		sdk.AcceptPaymentProposedFees(acceptFeesRequest)
	}
	// ANCHOR_END: handle-payments-waiting-fee-acceptance
}
