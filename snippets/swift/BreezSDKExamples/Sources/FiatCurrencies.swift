import BreezLiquidSDK
import Foundation

func listSupportedFiatCurrencies(sdk: BindingLiquidSdk) -> [FiatCurrency]? {
    // ANCHOR: list-fiat-currencies
    let supportedFiatCurrencies = try? sdk.listFiatCurrencies()
    // ANCHOR_END: list-fiat-currencies
    return supportedFiatCurrencies
}

func getCurrentRates(sdk: BindingLiquidSdk) -> [Rate]? {
    // ANCHOR: fetch-fiat-rates
    let fiatRates = try? sdk.fetchFiatRates()
    // ANCHOR_END: fetch-fiat-rates
    return fiatRates
}
