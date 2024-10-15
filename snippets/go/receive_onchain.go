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
