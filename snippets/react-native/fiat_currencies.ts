import {
  listFiatCurrencies,
  fetchFiatRates
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleListCurrencies = async () => {
  // ANCHOR: list-fiat-currencies
  const fiatCurrencies = await listFiatCurrencies()
  // ANCHOR_END: list-fiat-currencies
}

const exampleFetchRates = async () => {
  // ANCHOR: fetch-fiat-rates
  const fiatRates = await fetchFiatRates()
  // ANCHOR_END: fetch-fiat-rates
}
