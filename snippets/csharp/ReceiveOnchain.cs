using Breez.Sdk.Liquid;

public class ReceiveOnchainSnippets
{
    public void ListRefundables(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-refundables
        try
        {
            valrrefundables = sdk.ListRefundables();
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
        var satPerVbyte = refundTxFeeRate;
        try
        {
            sdk.Refund(
                new RefundRequest(
                    refundable.swapAddress, 
                    destinationAddress, 
                    satPerVbyte));
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
}
