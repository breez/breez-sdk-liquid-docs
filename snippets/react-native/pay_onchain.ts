import {
  type ReverseSwapPairInfo,
  fetchReverseSwapFees,
  inProgressReverseSwaps,
  sendOnchain,
  maxReverseSwapAmount
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleFetchReverseSwapFees = async () => {
  // ANCHOR: estimate-current-reverse-swap-total-fees
  const currentFees = await fetchReverseSwapFees({ sendAmountSat: 50000 })

  console.log(
    `Total estimated fees for reverse swap: ${currentFees.totalEstimatedFees}`
  )
  // ANCHOR_END: estimate-current-reverse-swap-total-fees
}

const exampleListCurrentFees = (currentFees: ReverseSwapPairInfo) => {
  // ANCHOR: get-current-reverse-swap-min-max
  console.log(`Minimum amount, in sats: ${currentFees.min}`)
  console.log(`Maximum amount, in sats: ${currentFees.max}`)
  // ANCHOR_END: get-current-reverse-swap-min-max
}

const maxAmount = async () => {
  // ANCHOR: max-reverse-swap-amount
  const maxAmount = await maxReverseSwapAmount()

  console.log(
    `Max reverse swap amount: ${maxAmount.totalSat}`
  )
  // ANCHOR_END: max-reverse-swap-amount
}

const exampleSendOnchain = async (currentFees: ReverseSwapPairInfo) => {
  // ANCHOR: start-reverse-swap
  const onchainRecipientAddress = 'bc1..'
  const amountSat = currentFees.min
  const satPerVbyte = 5

  const reverseSwapInfo = await sendOnchain({
    amountSat,
    onchainRecipientAddress,
    pairHash: currentFees.feesHash,
    satPerVbyte
  })
  // ANCHOR_END: start-reverse-swap
}

const exampleInProgressReverseSwaps = async () => {
  // ANCHOR: check-reverse-swaps-status
  const swaps = await inProgressReverseSwaps()
  for (const swap of swaps) {
    console.log(
      `Reverse swap ${swap.id} in progress, status is ${swap.status}`
    )
  }
  // ANCHOR_END: check-reverse-swaps-status
}
