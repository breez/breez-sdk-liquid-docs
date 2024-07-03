import {
  inProgressSwap,
  listRefundables,
  openChannelFee,
  receiveOnchain,
  refund
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleReceiveOnchain = async () => {
  // ANCHOR: generate-receive-onchain-address
  const swapInfo = await receiveOnchain({})

  // Send your funds to the below bitcoin address
  const address = swapInfo.bitcoinAddress
  console.log(`Minimum amount allowed to deposit in sats: ${swapInfo.minAllowedDeposit}`)
  console.log(`Maximum amount allowed to deposit in sats: ${swapInfo.maxAllowedDeposit}`)
  // ANCHOR_END: generate-receive-onchain-address
}

const exampleInProgressSwap = async () => {
  // ANCHOR: in-progress-swap
  const swapInfo = await inProgressSwap()
  // ANCHOR_END: in-progress-swap
}

const exampleListRefundables = async () => {
  // ANCHOR: list-refundables
  const refundables = await listRefundables()
  // ANCHOR_END: list-refundables
}

const exampleRefund = async () => {
  // ANCHOR: execute-refund
  const refundables = await listRefundables()
  const toAddress = '...'
  const satPerVbyte = 5

  const refundResponse = await refund({
    swapAddress: refundables[0].bitcoinAddress,
    toAddress,
    satPerVbyte
  })
  // ANCHOR_END: execute-refund
}

const exampleOpenChannelFee = async () => {
  // ANCHOR: get-channel-opening-fees
  const amountMsat = 10000

  const openChannelFeeResponse = await openChannelFee({
    amountMsat
  })
  // ANCHOR_END: get-channel-opening-fees
}
