import {
  listRefundables,
  rescanOnchainSwaps,
  type RefundableSwap,
  refund
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleListRefundables = async () => {
  // ANCHOR: list-refundables
  const refundables = await listRefundables()
  // ANCHOR_END: list-refundables
}

const exampleRefund = async (refundable: RefundableSwap, refundTxFeeRate: number) => {
  // ANCHOR: execute-refund
  const destinationAddress = '...'
  const satPerVbyte = refundTxFeeRate

  const refundResponse = await refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    satPerVbyte
  })
  // ANCHOR_END: execute-refund
}

const exampleRescanSwaps = async () => {
  // ANCHOR: rescan-swaps
  try {
    await rescanOnchainSwaps()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: rescan-swaps
}
