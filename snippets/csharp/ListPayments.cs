using Breez.Sdk.Liquid;

public class ListPaymentsSnippets
{
    public void GetPayment(BindingLiquidSdk sdk)
    {
        // ANCHOR: get-payment
        try
        {
            var paymentHash = "<payment hash>";
            var payment = sdk.GetPayment(
                new GetPaymentRequest.Lightning(paymentHash)
            );
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: get-payment
    }
    
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

    public void ListPaymentsDetailsAddress(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-payments-details-address
        try
        {
            var address = "<Bitcoin address>";
            var payments = sdk.ListPayments(
                new ListPaymentsRequest(
                    details: new ListPaymentDetails.Bitcoin(address)
                ));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-payments-details-address
    }

    public void ListPaymentsDetailsDestination(BindingLiquidSdk sdk)
    {
        // ANCHOR: list-payments-details-destination
        try
        {
            var destination = "<Liquid BIP21 or address>";
            var payments = sdk.ListPayments(
                new ListPaymentsRequest(
                    details: new ListPaymentDetails.Liquid(destination)
                ));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-payments-details-destination
    }
}
