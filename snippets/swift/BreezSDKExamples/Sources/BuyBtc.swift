import BreezSDKLiquid
import Foundation

func fetchOnchainLimits(sdk: BindingLiquidSdk) {
    //  ANCHOR: onchain-limits
    if let currentLimits = try? sdk.fetchOnchainLimits() {
        print("Minimum amount, in sats: \(currentLimits.receive.minSat)")
        print("Maximum amount, in sats: \(currentLimits.receive.maxSat)")
    }
    // ANCHOR_END: onchain-limits
}

func prepareBuyBitcoin(sdk: BindingLiquidSdk, currentLimits: OnchainPaymentLimitsResponse) {
    // ANCHOR: prepare-buy-btc
    let req = PrepareBuyBitcoinRequest(
        provider: .moonpay,
        amountSat: currentLimits.receive.minSat)

    if let prepareRes = try? sdk.prepareBuyBitcoin(req: req) {
        // Check the fees are acceptable before proceeding
        let receiveFeesSat = prepareRes.feesSat;
        print("Fees: \(receiveFeesSat) sats")
    }
    // ANCHOR_END: prepare-buy-btc
}

func buyBitcoin(sdk: BindingLiquidSdk, prepareRes: PrepareBuyBitcoinResponse) -> String? {
    // ANCHOR: buy-btc
    let req = BuyBitcoinRequest(prepareRes: prepareRes)
    let url = try? sdk.buyBitcoin(req: req)
    // ANCHOR_END: buy-btc
    return url
}
