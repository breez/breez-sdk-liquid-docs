package com.example.kotlinmpplib

import breez_liquid_sdk.*

class FiatCurrencies {
    fun listFiatCurrencies(sdk: BindingLiquidSdk) {
        // ANCHOR: list-fiat-currencies
        try {
            val fiatCurrencyList = sdk.listFiatCurrencies()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: list-fiat-currencies
    }

    fun fetchFiatRates(sdk: BindingLiquidSdk) {
        // ANCHOR: fetch-fiat-rates
        try {
            val fiatRatesMap = sdk.fetchFiatRates()
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: fetch-fiat-rates
    }
}