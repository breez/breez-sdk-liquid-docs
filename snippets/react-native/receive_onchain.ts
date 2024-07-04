import {
  fetchOnchainLimits,
  prepareReceiveOnchain,
  listRefundables,
  receiveOnchain,
  type RefundableSwap,
  refund
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleReceiveOnchain = async () => {
  // ANCHOR: generate-receive-onchain-address
  // Fetch the Onchain Receive limits
  const currentLimits = await fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send, which should be within the above limits
  const prepareResponse = await prepareReceiveOnchain({
    payerAmountSat: 50_000
  })

  // If the fees are acceptable, continue to create the Onchain Receive Payment
  const receiveFeesSat = prepareResponse.feesSat

  const receiveOnchainResponse = await receiveOnchain(prepareResponse)

  // Send your funds to the below bitcoin address
  const address = receiveOnchainResponse.address
  const bip21 = receiveOnchainResponse.bip21
  // ANCHOR_END: generate-receive-onchain-address
}

const exampleListRefundables = async () => {
  // ANCHOR: list-refundables
  const refundables = await listRefundables()
  // ANCHOR_END: list-refundables
}

const exampleRefund = async (refundable: RefundableSwap, refundTxFeeRate: number) => {
  // ANCHOR: execute-refund
  const refundables = await listRefundables()
  const destinationAddress = '...'
  const satPerVbyte = refundTxFeeRate

  const refundResponse = await refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    satPerVbyte
  })
  // ANCHOR_END: execute-refund
}
