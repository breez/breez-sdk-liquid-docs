using Breez.Sdk.Liquid;

public class ReceiveOnchainSnippets
{
    public void ListRefundables(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-refundables
        try
        {
            var refundables = sdk.ListRefundables();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-refundables
    }

    public void ExecuteRefund(BindingLiquidSdk sdk, uint refundTxFeeRate, RefundableSwap refundable)
    {
        // ANCHOR: execute-refund
        var destinationAddress = "...";
        var feeRateSatPerVbyte = refundTxFeeRate;
        try
        {
            sdk.Refund(
                new RefundRequest(
                    refundable.swapAddress, 
                    destinationAddress, 
                    feeRateSatPerVbyte));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: execute-refund
    }

    public void RescanSwaps(BindingLiquidSdk sdk)
    {
        // ANCHOR: rescan-swaps
        try
        {
            sdk.RescanOnchainSwaps();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: rescan-swaps
    }

    public void RecommendedFees(BindingLiquidSdk sdk)
    {
        // ANCHOR: recommended-fees
        try
        {
            var fees = sdk.RecommendedFees();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: recommended-fees
    }
}
