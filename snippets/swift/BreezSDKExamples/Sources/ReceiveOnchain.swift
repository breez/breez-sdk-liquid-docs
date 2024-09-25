import BreezSDKLiquid
import Foundation

func listRefundables(sdk: BindingLiquidSdk) -> [RefundableSwap]? {
    // ANCHOR: list-refundables
    let refundables = try? sdk.listRefundables()
    // ANCHOR_END: list-refundables
    return refundables
}

func executeRefund(sdk: BindingLiquidSdk, refundable: RefundableSwap, feeRateSatPerVbyte: UInt32) -> RefundResponse? {
    // ANCHOR: execute-refund
    let destinationAddress = "..."
    let feeRateSatPerVbyte = refundTxFeeRate
    let response = try? sdk.refund(req: RefundRequest(
        swapAddress: refundable.swapAddress,
        refundAddress: destinationAddress,
        feeRateSatPerVbyte: feeRateSatPerVbyte))
    // ANCHOR_END: execute-refund
    return response
}

func rescanSwaps(sdk: BindingLiquidSdk) -> Void {
    // ANCHOR: rescan-swaps
    try? sdk.rescanOnchainSwaps()
    // ANCHOR_END: rescan-swaps    
}
