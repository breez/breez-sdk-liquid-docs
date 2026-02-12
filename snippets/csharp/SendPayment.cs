using Breez.Sdk.Liquid;

public class SendPaymentSnippets
{
    public void GetCurrentLightningLimits(BindingLiquidSdk sdk)
    {
        // ANCHOR: get-current-pay-lightning-limits
        try
        {
            var currentLimits = sdk.FetchLightningLimits();
            Console.WriteLine($"Minimum amount, in sats: {currentLimits.send.minSat}");
            Console.WriteLine($"Maximum amount, in sats: {currentLimits.send.maxSat}");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: get-current-pay-lightning-limits
    }

    public void PrepareSendPaymentLightningBolt11(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-lightning-bolt11
        // Set the bolt11 invoice you wish to pay
        var destination = "<bolt11 invoice>";
        try
        {
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, null, null, null));

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
            var prepareRequest = new PrepareSendRequest(destination, optionalAmount, null, null);
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
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount, null, null));

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
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount, null, null));

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
            var optionalPayerNote = "<payer note>";
            var sendResponse = sdk.SendPayment(new SendPaymentRequest(prepareResponse, null, optionalPayerNote));
            var payment = sendResponse.payment;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: send-payment
    }}
