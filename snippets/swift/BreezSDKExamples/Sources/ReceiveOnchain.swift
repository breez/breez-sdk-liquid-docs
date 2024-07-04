import BreezLiquidSDK
import Foundation

func generateReceiveOnchainAddress(sdk: BindingLiquidSdk) -> String? {
    // ANCHOR: generate-receive-onchain-address
    // Fetch the Onchain Receive limits
    let currentLimits = try? sdk.fetchOnchainLimits()
    print("Minimum amount allowed to deposit in sats: \(currentLimits?.receive.minSat)")
    print("Maximum amount allowed to deposit in sats: \(currentLimits?.receive.maxSat)")

    // Set the amount you wish the payer to send, which should be within the above limits
    let prepareResponse = try? sdk
        .prepareReceiveOnchain(req: PrepareReceiveOnchainRequest(
            payerAmountSat: 50_000
        ))

    // If the fees are acceptable, continue to create the Onchain Receive Payment
    let receiveFeesSat = prepareResponse!.feesSat;

    let receiveOnchainResponse = try? sdk.receiveOnchain(req: prepareResponse!)

    // Send your funds to the below bitcoin address
    let address : String = receiveOnchainResponse!.address
    let bip21 : String = receiveOnchainResponse!.bip21
    // ANCHOR_END: generate-receive-onchain-address

    return address
}

func listRefundables(sdk: BindingLiquidSdk) -> [RefundableSwap]? {
    // ANCHOR: list-refundables
    let refundables = try? sdk.listRefundables()
    // ANCHOR_END: list-refundables
    return refundables
}

func executeRefund(sdk: BindingLiquidSdk, refundable: RefundableSwap, satPerVbyte: UInt32) -> RefundResponse? {
    // ANCHOR: execute-refund
    let destinationAddress = "..."
    let response = try? sdk.refund(req: RefundRequest(
        swapAddress: refundable.swapAddress,
        refundAddress: destinationAddress,
        satPerVbyte: satPerVbyte))
    // ANCHOR_END: execute-refund
    return response
}

func rescanSwaps(sdk: BindingLiquidSdk) -> Void {
    // ANCHOR: rescan-swaps
    try? sdk.rescanOnchainSwaps()
    // ANCHOR_END: rescan-swaps    
}