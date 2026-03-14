import {
  type BindingLiquidSdk,
  type PreparePayOnchainResponse,
  PayAmount
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGetCurrentLimits = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: get-current-pay-onchain-limits
  try {
    const currentLimits = sdk.fetchOnchainLimits()

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
    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5000) }),
      feeRateSatPerVbyte: undefined
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
    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Drain(),
      feeRateSatPerVbyte: undefined
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

    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) }),
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

const examplePayOnchain = async (sdk: BindingLiquidSdk, prepareResponse: PreparePayOnchainResponse) => {
  // ANCHOR: start-reverse-swap
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = sdk.payOnchain({
      address: destinationAddress,
      prepareResponse
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: start-reverse-swap
}
