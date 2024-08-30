using Breez.Sdk;

public class BuyBtcSnippets
{
    public void FetchOnchainLimits(BindingLiquidSdk sdk)
    {
        // ANCHOR: onchain-limits
        try
        {
            var currentLimits = sdk.FetchOnchainLimits();
            Console.WriteLine($"Minimum amount, in sats: {currentLimits.receive.minSat}");
            Console.WriteLine($"Maximum amount, in sats: {currentLimits.receive.maxSat}");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: onchain-limits
    }

    public void PrepareBuyBtc(BindingLiquidSdk sdk, OnchainPaymentLimitsResponse currentLimits)
    {
        // ANCHOR: prepare-buy-btc
        try
        {
            var req = new PrepareBuyBitcoinRequest(BuyBitcoinProvider.MOONPAY, currentLimits.receive.minSat);
            var prepareResponse = sdk.PrepareBuyBitcoin(req);

            // Check the fees are acceptable before proceeding
            var receiveFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {receiveFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-buy-btc
    }

    public void BuyBtc(BindingLiquidSdk sdk, PrepareBuyBitcoinResponse prepareResponse)
    {
        // ANCHOR: buy-btc
        try
        {
            var req = new BuyBitcoinRequest(prepareResponse);
            var url = sdk.BuyBitcoin(req);
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: buy-btc
    }
}
