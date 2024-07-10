import BreezSDKLiquid
import Foundation

func listPayments(sdk: BindingLiquidSdk) -> [Payment]? {
    // ANCHOR: list-payments
    let payments = try? sdk.listPayments()
    // ANCHOR_END: list-payments
    return payments
}
