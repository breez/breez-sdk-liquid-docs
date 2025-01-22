import {
  type PreparePayOnchainResponse,
  fetchOnchainLimits,
  preparePayOnchain,
  payOnchain,
  PayAmountVariant
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
    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: 5_000
      }
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain
}

const examplePreparePayOnchainDrain = async () => {
  // ANCHOR: prepare-pay-onchain-drain
  try {
    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.DRAIN
      }
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain-drain
}

const examplePreparePayOnchainFeeRate = async () => {
  // ANCHOR: prepare-pay-onchain-fee-rate
  try {
    const optionalSatPerVbyte = 21

    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: 5_000
      },
      feeRateSatPerVbyte: optionalSatPerVbyte
    })

    // Check if the fees are acceptable before proceeding
    const claimFeesSat = prepareResponse.claimFeesSat
    const totalFeesSat = prepareResponse.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain-fee-rate
}

const examplePayOnchain = async (prepareResponse: PreparePayOnchainResponse) => {
  // ANCHOR: start-reverse-swap
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = await payOnchain({
      address: destinationAddress,
      prepareResponse
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: start-reverse-swap
}
