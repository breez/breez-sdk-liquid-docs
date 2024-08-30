using Breez.Sdk.Liquid;

public class FiatCurrenciesSnippets
{
    public void ListFiatCurrencies(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-fiat-currencies
        try
        {
            var fiatCurrencies = sdk.ListFiatCurrencies();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-fiat-currencies
    }

    public void FetchFiatRates(BindingLiquidSdk sdk)
    {
        // ANCHOR: fetch-fiat-rates
        try
        {
            var fiatRates = sdk.FetchFiatRates();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: fetch-fiat-rates
    }
}
