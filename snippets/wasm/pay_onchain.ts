import { type BindingLiquidSdk, type PreparePayOnchainResponse } from '@breeztech/breez-sdk-liquid'

const exampleGetCurrentLimits = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: get-current-pay-onchain-limits
  try {
    const currentLimits = await sdk.fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: get-current-pay-onchain-limits
}

const examplePreparePayOnchain = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-pay-onchain
  try {
    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'bitcoin',
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

const examplePreparePayOnchainDrain = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-pay-onchain-drain
  try {
    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'drain'
      }
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-pay-onchain-drain
}

const examplePreparePayOnchainFeeRate = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-pay-onchain-fee-rate
  try {
    const optionalSatPerVbyte = 21

    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'bitcoin',
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

const examplePayOnchain = async (
  sdk: BindingLiquidSdk,
  prepareResponse: PreparePayOnchainResponse
) => {
  // ANCHOR: start-reverse-swap
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = await sdk.payOnchain({
      address: destinationAddress,
      prepareResponse
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: start-reverse-swap
}
