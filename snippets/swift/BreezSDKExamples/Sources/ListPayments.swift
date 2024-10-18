import BreezSDKLiquid
import Foundation

func getPayment(sdk: BindingLiquidSdk) -> Payment? {
    // ANCHOR: get-payment
    let paymentHash = "<payment hash>"
    let payment = try? sdk.getPayment(
        req: GetPaymentRequest.lightning(paymentHash: paymentHash)
    )
    // ANCHOR_END: get-payment
    return payment
}

func listPayments(sdk: BindingLiquidSdk) -> [Payment]? {
    // ANCHOR: list-payments
    let payments = try? sdk.listPayments(req: ListPaymentsRequest())
    // ANCHOR_END: list-payments
    return payments
}

func ListPaymentsFiltered(sdk: BindingLiquidSdk) -> [Payment]? {
    // ANCHOR: list-payments-filtered
    let payments = try? sdk.listPayments(
        req: ListPaymentsRequest(
            filters: [.send],
            fromTimestamp: 1696880000,
            toTimestamp: 1696959200,
            offset: 0,
            limit: 50
        ))
    // ANCHOR_END: list-payments-filtered
    return payments
}
