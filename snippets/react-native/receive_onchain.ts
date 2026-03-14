import {
  type BindingLiquidSdk,
  type RefundableSwap,
  PaymentState,
  PaymentDetails_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleListRefundables = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-refundables
  try {
    const refundables = sdk.listRefundables()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-refundables
}

const exampleRefund = async (sdk: BindingLiquidSdk, refundable: RefundableSwap, refundTxFeeRate: number) => {
  // ANCHOR: execute-refund
  const destinationAddress = '...'
  const feeRateSatPerVbyte = refundTxFeeRate

  const refundResponse = sdk.refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    feeRateSatPerVbyte
  })
  // ANCHOR_END: execute-refund
}

const exampleRescanSwaps = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: rescan-swaps
  try {
    sdk.rescanOnchainSwaps()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: rescan-swaps
}

const exampleRecommendedFees = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: recommended-fees
  try {
    const fees = sdk.recommendedFees()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: recommended-fees
}

const exampleHandlePaymentsWaitingFeeAcceptance = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: handle-payments-waiting-fee-acceptance
  // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
  const paymentsWaitingFeeAcceptance = sdk.listPayments({
    states: [PaymentState.WaitingFeeAcceptance],
    filters: undefined,
    fromTimestamp: undefined,
    toTimestamp: undefined,
    offset: undefined,
    limit: undefined,
    details: undefined,
    sortAscending: undefined
  })

  for (const payment of paymentsWaitingFeeAcceptance) {
    if (payment.details.tag !== PaymentDetails_Tags.Bitcoin) {
      // Only Bitcoin payments can be `WaitingFeeAcceptance`
      continue
    }

    const fetchFeesResponse = sdk.fetchPaymentProposedFees({
      swapId: payment.details.inner.swapId
    })

    console.info(
      `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
    )

    // If the user is ok with the fees, accept them, allowing the payment to proceed
    sdk.acceptPaymentProposedFees({
      response: fetchFeesResponse
    })
  }
  // ANCHOR_END: handle-payments-waiting-fee-acceptance
}
