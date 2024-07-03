import BreezLiquidSDK
import Foundation

func ListPayments(sdk: BlockingBreezServices) -> [Payment]? {
    // ANCHOR: list-payments
    let payments = try? sdk.listPayments(req: ListPaymentsRequest())
    // ANCHOR_END: list-payments
    return payments
}
