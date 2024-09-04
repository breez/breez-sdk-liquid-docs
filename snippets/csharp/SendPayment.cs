using Breez.Sdk.Liquid;

public class SendPaymentSnippets
{
    public void SendPayment(BindingLiquidSdk sdk)
    {
        // ANCHOR: send-payment
        // Set the BOLT11 invoice you wish to pay
        var destination = "Invoice, Liquid BIP21 or address";
        try
        {
            ulong optionalAmountSat = 5000;
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmountSat));

            // If the fees are acceptable, continue to create the Send Payment
            var sendFeesSat = prepareResponse.feesSat;

            var sendResponse = sdk.SendPayment(new SendPaymentRequest(prepareResponse));
            var payment = sendResponse.payment;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: send-payment
    }
}
