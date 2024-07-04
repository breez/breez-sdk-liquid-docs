import {
  type Limits,
  type PreparePayOnchainResponse,
  fetchOnchainLimits,
  preparePayOnchain,
  payOnchain
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleGetCurrentLimits = async () => {
  // ANCHOR: get-current-pay-onchain-limits
  try {
    const currentLimits = await fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: get-current-pay-onchain-limits
}

const examplePreparePayOnchain = async () => {
  // ANCHOR: prepare-pay-onchain
  try {
    const prepareRes = await preparePayOnchain({
      receiverAmountSat: 5000
    })

    // Check if the fees are acceptable before proceeding
    const feesSat = prepareRes.feesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain
}

const examplePayOnchain = async (prepareRes: PreparePayOnchainResponse) => {
  // ANCHOR: start-reverse-swap
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = await payOnchain({
      address: destinationAddress,
      prepareRes
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: start-reverse-swap
}
