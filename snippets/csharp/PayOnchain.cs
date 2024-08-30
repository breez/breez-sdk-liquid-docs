using Breez.Sdk.Liquid;

public class SendOnchainSnippets
{
    public void GetCurrentRevSwapLimits(BindingLiquidSdk sdk)
    {
        // ANCHOR: get-current-pay-onchain-limits
        try
        {
            var currentLimits = sdk.FetchOnchainLimits();
            Console.WriteLine($"Minimum amount, in sats: {currentLimits.send.minSat}");
            Console.WriteLine($"Maximum amount, in sats: {currentLimits.send.maxSat}");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: get-current-pay-onchain-limits
    }

    public void PreparePayOnchain(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-pay-onchain
        try
        {
            var prepareRequest = new PreparePayOnchainRequest(5000);
            var prepareResponse = sdk.PreparePayOnchain(prepareRequest);

            // Check if the fees are acceptable before proceeding
            vatrtotalFeesSat = prepareResponse.totalFeesSat;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-pay-onchain
    }

    public void PreparePayOnchainFeeRate(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-pay-onchain-fee-rate
        try
        {
            uint optionalSatPerVbyte = 21;

            var prepareRequest = new PreparePayOnchainRequest(5000, optionalSatPerVbyte);
            var prepareResponse = sdk.PreparePayOnchain(prepareRequest);

            // Check if the fees are acceptable before proceeding
            var claimFeesSat = prepareResponse.claimFeesSat;
            var totalFeesSat = prepareResponse.totalFeesSat;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-pay-onchain-fee-rate
    }

    public void StartReverseSwap(BindingLiquidSdk sdk, PreparePayOnchainResponse prepareResponse)
    {
        // ANCHOR: start-reverse-swap
        var address = "bc1..";
        try
        {
            var reverseSwapInfo = sdk.PayOnchain(
                new PayOnchainRequest(address, prepareResponse));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: start-reverse-swap
    }
}
