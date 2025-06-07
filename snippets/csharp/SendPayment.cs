using Breez.Sdk.Liquid;

public class SendPaymentSnippets
{
    public void PrepareSendPaymentLightningBolt11(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-lightning-bolt11
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
        // ANCHOR_END: prepare-send-payment-lightning-bolt11
    }

    public void PrepareSendPaymentLightningBolt12(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-lightning-bolt12
        // Set the bolt12 offer you wish to pay
        var destination = "<bolt12 offer>";
        try
        {
            var optionalAmount = new PayAmount.Bitcoin(5000);
            var optionalComment = "<comment>";
            var prepareRequest = new PrepareSendRequest(destination, optionalAmount, optionalComment);
            var prepareResponse = sdk.PrepareSendPayment(prepareRequest);
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-lightning-bolt12
    }

    public void PrepareSendPaymentLiquid(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-liquid
        // Set the Liquid BIP21 or address you wish to pay
        var destination = "<Liquid BIP21 or address>";
        try
        {
            var optionalAmount = new PayAmount.Bitcoin(5000);
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount));

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

    public void PrepareSendPaymentLiquidDrain(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-liquid-drain
        // Set the Liquid BIP21 or address you wish to pay
        var destination = "<Liquid BIP21 or address>";
        try
        {
            var optionalAmount = new PayAmount.Drain();
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount));

            // If the fees are acceptable, continue to create the Send Payment
            var sendFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {sendFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-liquid-drain
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
