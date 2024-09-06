using Breez.Sdk.Liquid;

public class SendPaymentSnippets
{
    public void PrepareSendPaymentLightning(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-lightning
        // Set the bolt11 invoice you wish to pay
        var destination = "<bolt11 invoice>";
        try
        {
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination));

            // If the fees are acceptable, continue to create the Send Payment
            var sendFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {sendFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-lightning
    }

    public void PrepareSendPaymentLiquid(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-liquid
        // Set the Liquid BIP21 or address you wish to pay
        var destination = "<Liquid BIP21 or address>";
        try
        {
            ulong optionalAmountSat = 5000;
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmountSat));

            // If the fees are acceptable, continue to create the Send Payment
            var sendFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {sendFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-liquid
    }

    public void SendPayment(BindingLiquidSdk sdk, PrepareSendResponse prepareResponse)
    {
        // ANCHOR: send-payment
        try
        {
            var sendResponse = sdk.SendPayment(new SendPaymentRequest(prepareResponse));
            var payment = sendResponse.payment;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: send-payment
    }}
