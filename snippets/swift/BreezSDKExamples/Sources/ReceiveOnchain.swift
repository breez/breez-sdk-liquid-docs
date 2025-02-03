import BreezSDKLiquid
import Foundation

func listRefundables(sdk: BindingLiquidSdk) -> [RefundableSwap]? {
    // ANCHOR: list-refundables
    let refundables = try? sdk.listRefundables()
    // ANCHOR_END: list-refundables
    return refundables
}

func executeRefund(sdk: BindingLiquidSdk, refundable: RefundableSwap, refundTxFeeRate: UInt32)
    -> RefundResponse?
{
    // ANCHOR: execute-refund
    let destinationAddress = "..."
    let feeRateSatPerVbyte = refundTxFeeRate
    let response = try? sdk.refund(
        req: RefundRequest(
            swapAddress: refundable.swapAddress,
            refundAddress: destinationAddress,
            feeRateSatPerVbyte: feeRateSatPerVbyte))
    // ANCHOR_END: execute-refund
    return response
}

func rescanSwaps(sdk: BindingLiquidSdk) {
    // ANCHOR: rescan-swaps
    try? sdk.rescanOnchainSwaps()
    // ANCHOR_END: rescan-swaps
}

func recommendedFees(sdk: BindingLiquidSdk) -> RecommendedFees? {
    // ANCHOR: recommended-fees
    let fees = try? sdk.recommendedFees()
    // ANCHOR_END: recommended-fees
    return fees
}

func handlePaymentsWaitingFeeAcceptance(sdk: BindingLiquidSdk) {
    // ANCHOR: handle-payments-waiting-fee-acceptance
    // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
    guard
        let paymentsWaitingFeeAcceptance = try? sdk.listPayments(
            req: ListPaymentsRequest(states: [.waitingFeeAcceptance]))
    else { return }

    for payment in paymentsWaitingFeeAcceptance {
        guard case .bitcoin(let swapId, _, _, _, _, _, _) = payment.details else { continue }

        // Only Bitcoin payments can be `WaitingFeeAcceptance`
        guard
            let fetchFeesResponse = try? sdk.fetchPaymentProposedFees(
                req: FetchPaymentProposedFeesRequest(
                    swapId: swapId))
        else { continue }

        print(
            "Payer sent \(fetchFeesResponse.payerAmountSat) and currently proposed fees are \(fetchFeesResponse.feesSat)"
        )

        // If the user is ok with the fees, accept them, allowing the payment to proceed
        try? sdk.acceptPaymentProposedFees(
            req: AcceptPaymentProposedFeesRequest(
                response: fetchFeesResponse))
    }
    // ANCHOR_END: handle-payments-waiting-fee-acceptance
}
