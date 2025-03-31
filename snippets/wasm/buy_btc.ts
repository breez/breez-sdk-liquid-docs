import {
  type OnchainPaymentLimitsResponse,
  type PrepareBuyBitcoinResponse,
  type BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid'

const exampleFetchOnchainLimits = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: onchain-limits
  try {
    const currentLimits = await sdk.fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END:onchain-limits
}

const examplePrepareBuyBtc = async (
  sdk: BindingLiquidSdk,
  currentLimits: OnchainPaymentLimitsResponse
) => {
  // ANCHOR: prepare-buy-btc
  try {
    const prepareRes = await sdk.prepareBuyBitcoin({
      provider: 'moonpay',
      amountSat: currentLimits.receive.minSat
    })

    // Check the fees are acceptable before proceeding
    const receiveFeesSat = prepareRes.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: prepare-buy-btc
}

const exampleBuyBtc = async (sdk: BindingLiquidSdk, prepareResponse: PrepareBuyBitcoinResponse) => {
  // ANCHOR: buy-btc
  try {
    const url = await sdk.buyBitcoin({
      prepareResponse
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: buy-btc
}
