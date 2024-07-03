import BreezLiquidSDK
import Foundation

func generateReceiveOnchainAddress(sdk: BindingLiquidSdk) -> String? {
    // ANCHOR: generate-receive-onchain-address
    // Set the amount you wish the payer to send
    let prepareResponse = try? sdk
        .prepareReceiveOnchain(req: PrepareReceiveOnchainRequest {
            amountSat: 50_000,
        })

    let swapInfo = try? sdk.receiveOnchain(req: ReceiveOnchainRequest())

    // Send your funds to the bellow bitcoin address
    let address = swapInfo?.bitcoinAddress
    print("Minimum amount allowed to deposit in sats: \(swapInfo!.minAllowedDeposit)")
    print("Maximum amount allowed to deposit in sats: \(swapInfo!.maxAllowedDeposit)")
    // ANCHOR_END: generate-receive-onchain-address

    return address
}

func listRefundables(sdk: BindingLiquidSdk) -> [SwapInfo]? {
    // ANCHOR: list-refundables
    let refundables = try? sdk.listRefundables()
    // ANCHOR_END: list-refundables
    return refundables
}

func executeRefund(sdk: BindingLiquidSdk, refundables: SwapInfo, satPerVbyte: UInt32) -> RefundResponse? {
    // ANCHOR: execute-refund
    let destinationAddress = "..."
    let response = try? sdk.refund(req: RefundRequest(swapAddress: refundables.bitcoinAddress, toAddress: destinationAddress, satPerVbyte: satPerVbyte))
    // ANCHOR_END: execute-refund
    return response
}

func rescanSwaps(sdk: BindingLiquidSdk) -> Void {
    // ANCHOR: rescan-swaps
    try? sdk.rescanSwaps()
    // ANCHOR_END: rescan-swaps    
}