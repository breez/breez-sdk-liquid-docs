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

    public void HandlePaymentsWaitingFeeAcceptance(BindingLiquidSdk sdk)
    {
        // ANCHOR: handle-payments-waiting-fee-acceptance
        // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
        var paymentsWaitingFeeAcceptance = sdk.ListPayments(
            new ListPaymentsRequest()
            {
                states = new List<PaymentState>() { PaymentState.WaitingFeeAcceptance }
            });

        foreach (var payment in paymentsWaitingFeeAcceptance)
        {
            if (payment.details is not PaymentDetails.Bitcoin bitcoinDetails)
            {
                // Only Bitcoin payments can be `WaitingFeeAcceptance`
                continue;
            }

            var fetchFeesResponse = sdk.FetchPaymentProposedFees(
                new FetchPaymentProposedFeesRequest(bitcoinDetails.swapId));

            Console.WriteLine(
                $"Payer sent {fetchFeesResponse.payerAmountSat} and currently proposed fees are {fetchFeesResponse.feesSat}");

            // If the user is ok with the fees, accept them, allowing the payment to proceed
            sdk.AcceptPaymentProposedFees(
                new AcceptPaymentProposedFeesRequest(fetchFeesResponse));
        }
        // ANCHOR_END: handle-payments-waiting-fee-acceptance
    }
}
