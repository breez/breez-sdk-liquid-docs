using Breez.Sdk.Liquid;

public class ReceivePaymentSnippets
{
    public void PrepareReceiveLightning(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-receive-payment-lightning
        try
        {
            // Fetch the lightning Receive limits
            var currentLimits = sdk.FetchLightningLimits();
            Console.WriteLine($"Minimum amount allowed to deposit in sats: {currentLimits.receive.minSat}");
            Console.WriteLine($"Maximum amount allowed to deposit in sats: {currentLimits.receive.maxSat}");

            // Set the invoice amount you wish the payer to send, which should be within the above limits
            var prepareRequest = new PrepareReceiveRequest(5000, PaymentMethod.Lightning);
            var prepareResponse = sdk.PrepareReceivePayment(prepareRequest);

            // If the fees are acceptable, continue to create the Receive Payment
            var receiveFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {receiveFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-receive-payment-lightning
    }

    public void PrepareReceiveOnchain(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-receive-payment-onchain
        try
        {
            // Fetch the onchain Receive limits
            var currentLimits = sdk.FetchOnchainLimits();
            Console.WriteLine($"Minimum amount allowed to deposit in sats: {currentLimits.receive.minSat}");
            Console.WriteLine($"Maximum amount allowed to deposit in sats: {currentLimits.receive.maxSat}");

            // Set the onchain amount you wish the payer to send, which should be within the above limits
            var prepareRequest = new PrepareReceiveRequest(5000, PaymentMethod.BitcoinAddress);
            var prepareResponse = sdk.PrepareReceivePayment(prepareRequest);

            // If the fees are acceptable, continue to create the Receive Payment
            var receiveFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {receiveFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-receive-payment-onchain
    }

    public void PrepareReceiveLiquid(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-receive-payment-liquid
        try
        {
            // Create a Liquid BIP21 URI/address to receive a payment to.
            // There are no limits, but the payer amount should be greater than broadcast fees when specified
            // Note: Not setting the amount will generate a plain Liquid address
            var prepareRequest = new PrepareReceiveRequest(5000, PaymentMethod.LiquidAddress);
            var prepareResponse = sdk.PrepareReceivePayment(prepareRequest);

            // If the fees are acceptable, continue to create the Receive Payment
            var receiveFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {receiveFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-receive-payment-liquid
    }

    public void ReceivePayment(BindingLiquidSdk sdk, PrepareReceiveResponse prepareResponse)
    {
        // ANCHOR: receive-payment
        try
        {
            var optionalDescription = "<description>";
            var req = new ReceivePaymentRequest(prepareResponse, optionalDescription);
            var res = sdk.ReceivePayment(req);
            var destination = res.destination;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: receive-payment
    }
}
