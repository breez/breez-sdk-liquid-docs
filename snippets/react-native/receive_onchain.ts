import {
  listRefundables,
  rescanOnchainSwaps,
  type RefundableSwap,
  refund,
  recommendedFees,
  listPayments,
  fetchPaymentProposedFees,
  acceptPaymentProposedFees,
  PaymentState,
  PaymentDetailsVariant
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

const exampleHandlePaymentsWaitingFeeAcceptance = async () => {
  // ANCHOR: handle-payments-waiting-fee-acceptance
  // Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
  const paymentsWaitingFeeAcceptance = await listPayments({
    states: [PaymentState.WAITING_FEE_ACCEPTANCE]
  })

  for (const payment of paymentsWaitingFeeAcceptance) {
    if (payment.details.type !== PaymentDetailsVariant.BITCOIN) {
      // Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
      continue
    }

    const fetchFeesResponse = await fetchPaymentProposedFees({
      swapId: payment.details.swapId
    })

    console.info(
      `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
    )

    // If the user is ok with the fees, accept them, allowing the payment to proceed
    await acceptPaymentProposedFees({
      response: fetchFeesResponse
    })
  }
  // ANCHOR_END: handle-payments-waiting-fee-acceptance
}
