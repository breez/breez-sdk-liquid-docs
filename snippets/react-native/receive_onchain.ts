import {
  listRefundables,
  rescanOnchainSwaps,
  type RefundableSwap,
  refund,
  recommendedFees
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleListRefundables = async () => {
  // ANCHOR: list-refundables
  try {
    const refundables = await listRefundables()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-refundables
}

const exampleRefund = async (refundable: RefundableSwap, refundTxFeeRate: number) => {
  // ANCHOR: execute-refund
  const destinationAddress = '...'
  const feeRateSatPerVbyte = refundTxFeeRate

  const refundResponse = await refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    feeRateSatPerVbyte
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

const exampleRecommendedFees = async () => {
  // ANCHOR: recommended-fees
  try {
    const fees = await recommendedFees()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: recommended-fees
}
