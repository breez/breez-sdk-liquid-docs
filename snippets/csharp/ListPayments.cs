using Breez.Sdk.Liquid;

public class ListPaymentsSnippets
{
    public void ListPayments(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-payments
        try
        {
            var payments = sdk.ListPayments(new ListPaymentsRequest());
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-payments
    }

    public void ListPaymentsFiltered(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-payments-filtered
        try
        {
            var payments = sdk.ListPayments(
                new ListPaymentsRequest(
                    new() { PaymentType.Send },
                    fromTimestamp: 1696880000,
                    toTimestamp: 1696959200,
                    offset: 0,
                    limit: 50
                ));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-payments-filtered
    }
}
