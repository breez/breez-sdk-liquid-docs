import BreezSDKLiquid
import Foundation

func getPayment(sdk: BindingLiquidSdk) -> Payment? {
    // ANCHOR: get-payment
    let paymentHash = "<payment hash>"
    let paymentByHash = try? sdk.getPayment(
        req: GetPaymentRequest.paymentHash(paymentHash: paymentHash)
    )

    let swapId = "<swap id>"
    let paymentBySwapId = try? sdk.getPayment(
        req: GetPaymentRequest.swapId(swapId: swapId)
    )
    // ANCHOR_END: get-payment
    return paymentBySwapId
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

func ListPaymentsDetailsAddress(sdk: BindingLiquidSdk) -> [Payment]? {
    // ANCHOR: list-payments-details-address
    let address = "<Bitcoin address>"
    let payments = try? sdk.listPayments(
        req: ListPaymentsRequest(
            details: ListPaymentDetails.bitcoin(address: address)
        ))
    // ANCHOR_END: list-payments-details-address
    return payments
}

func ListPaymentsDetailsDestination(sdk: BindingLiquidSdk) -> [Payment]? {
    // ANCHOR: list-payments-details-destination
    let destination = "<Liquid BIP21 or address>"
    let payments = try? sdk.listPayments(
        req: ListPaymentsRequest(
            details: ListPaymentDetails.liquid(assetId: nil, destination: destination)
        ))
    // ANCHOR_END: list-payments-details-destination
    return payments
}
