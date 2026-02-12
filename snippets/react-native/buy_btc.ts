import {
  buyBitcoin,
  BuyBitcoinProvider,
  fetchOnchainLimits,
  type OnchainPaymentLimitsResponse,
  type PrepareBuyBitcoinResponse,
  prepareBuyBitcoin
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleFetchOnchainLimits = async () => {
  // ANCHOR: onchain-limits
  try {
    const currentLimits = await fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END:onchain-limits
}

const examplePrepareBuyBtc = async (currentLimits: OnchainPaymentLimitsResponse) => {
  // ANCHOR: prepare-buy-btc
  try {
    const prepareRes = await prepareBuyBitcoin({
      provider: BuyBitcoinProvider.MOONPAY,
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

const exampleBuyBtc = async (prepareResponse: PrepareBuyBitcoinResponse) => {
  // ANCHOR: buy-btc
  try {
    const url = await buyBitcoin({
      prepareResponse
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: buy-btc
}
