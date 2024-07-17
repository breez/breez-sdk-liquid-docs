import {
  type PreparePayOnchainResponse,
  fetchOnchainLimits,
  preparePayOnchain,
  payOnchain
} from '@breeztech/react-native-breez-sdk-liquid'

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
      receiverAmountSat: 5_000
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareRes.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain
}

const examplePreparePayOnchainFeeRate = async () => {
  // ANCHOR: prepare-pay-onchain-fee-rate
  try {
    const optionalSatPerVbyte = 21

    const prepareRes = await preparePayOnchain({
      receiverAmountSat: 5_000,
      satPerVbyte: optionalSatPerVbyte
    })

    // Check if the fees are acceptable before proceeding
    const claimFeesSat = prepareRes.claimFeesSat
    const totalFeesSat = prepareRes.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain-fee-rate
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
