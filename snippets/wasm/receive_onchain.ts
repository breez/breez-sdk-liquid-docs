import { type RefundableSwap, type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'

const exampleListRefundables = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-refundables
  try {
    const refundables = await sdk.listRefundables()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-refundables
}

const exampleRefund = async (
  sdk: BindingLiquidSdk,
  refundable: RefundableSwap,
  refundTxFeeRate: number
) => {
  // ANCHOR: execute-refund
  const destinationAddress = '...'
  const feeRateSatPerVbyte = refundTxFeeRate

  const refundResponse = await sdk.refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    feeRateSatPerVbyte
  })
  // ANCHOR_END: execute-refund
}

const exampleRescanSwaps = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: rescan-swaps
  try {
    await sdk.rescanOnchainSwaps()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: rescan-swaps
}

const exampleRecommendedFees = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: recommended-fees
  try {
    const fees = await sdk.recommendedFees()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: recommended-fees
}

const exampleHandlePaymentsWaitingFeeAcceptance = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: handle-payments-waiting-fee-acceptance
  // Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
  const paymentsWaitingFeeAcceptance = await sdk.listPayments({
    states: ['waitingFeeAcceptance']
  })

  for (const payment of paymentsWaitingFeeAcceptance) {
    if (payment.details.type !== 'bitcoin') {
      // Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
      continue
    }

    const fetchFeesResponse = await sdk.fetchPaymentProposedFees({
      swapId: payment.details.swapId
    })

    console.info(
      `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
    )

    // If the user is ok with the fees, accept them, allowing the payment to proceed
    await sdk.acceptPaymentProposedFees({
      response: fetchFeesResponse
    })
  }
  // ANCHOR_END: handle-payments-waiting-fee-acceptance
}
