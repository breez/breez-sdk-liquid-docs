import {
  type BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid'

const exampleListCurrencies = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-fiat-currencies
  const fiatCurrencies = await sdk.listFiatCurrencies()
  // ANCHOR_END: list-fiat-currencies
}

const exampleFetchRates = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: fetch-fiat-rates
  const fiatRates = await sdk.fetchFiatRates()
  // ANCHOR_END: fetch-fiat-rates
}
