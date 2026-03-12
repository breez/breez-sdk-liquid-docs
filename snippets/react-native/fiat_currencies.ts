import { BindingLiquidSdk } from "@breeztech/breez-sdk-liquid-react-native"

const exampleListCurrencies = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-fiat-currencies
  const fiatCurrencies = sdk.listFiatCurrencies()
  // ANCHOR_END: list-fiat-currencies
}

const exampleFetchRates = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: fetch-fiat-rates
  const fiatRates = sdk.fetchFiatRates()
  // ANCHOR_END: fetch-fiat-rates
}
