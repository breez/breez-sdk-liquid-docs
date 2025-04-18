using System.Reflection;
using Breez.Sdk.Liquid;

public class NonBitcoinAssetSnippets
{
    public void PrepareReceiveAsset(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-receive-payment-asset
        try
        {
            // Create a Liquid BIP21 URI/address to receive an asset payment to.
            // Note: Not setting the amount will generate an amountless BIP21 URI.
            var usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
            var optionalAmount = new ReceiveAmount.Asset(usdtAssetId, 1.50);
            var prepareRequest = new PrepareReceiveRequest(PaymentMethod.LiquidAddress, optionalAmount);
            var prepareResponse = sdk.PrepareReceivePayment(prepareRequest);

            // If the fees are acceptable, continue to create the Receive Payment
            var receiveFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {receiveFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-receive-payment-asset
    }

    public void PrepareSendPaymentAsset(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-asset
        // Set the Liquid BIP21 or address you wish to pay
        var destination = "<Liquid BIP21 or address>";
        try
        {
            // If the destination is an address or an amountless BIP21 URI,
            // you must specify an asset amount
            var usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
            var optionalAmount = new PayAmount.Asset(usdtAssetId, 1.50, false);
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount));

            // If the fees are acceptable, continue to create the Send Payment
            var sendFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {sendFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-asset
    }
    
    public void PrepareSendPaymentAssetFees(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-send-payment-asset-fees
        var destination = "<Liquid BIP21 or address>";
        try
        {
            var usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
            // Set the optional estimate asset fees param to true
            var optionalAmount = new PayAmount.Asset(usdtAssetId, 1.50, true);
            var prepareResponse = sdk.PrepareSendPayment(new PrepareSendRequest(destination, optionalAmount));

            // If the asset fees are set, you can use these fees to pay to send the asset
            var sendAssetFees = prepareResponse.estimatedAssetFees;
            Console.WriteLine($"Estimated Fees: ~{sendAssetFees}");

            // If the asset fess are not set, you can use the sats fees to pay to send the asset
            var sendFeesSat = prepareResponse.feesSat;
            Console.WriteLine($"Fees: {sendFeesSat} sats");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-send-payment-asset-fees
    }

    public void SendPaymentFees(BindingLiquidSdk sdk, PrepareSendResponse prepareResponse)
    {
        // ANCHOR: send-payment-fees
        try
        {
            // Set the use asset fees param to true
            var sendRequest = new SendPaymentRequest(prepareResponse, true);
            var sendResponse = sdk.SendPayment(sendRequest);
            var payment = sendResponse.payment;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: send-payment-fees
    }
    
    public void ConfigureAssetMetadata()
    {
        // ANCHOR: configure-asset-metadata
        // Create the default config
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Mainnet,
            "<your-Breez-API-key>"
        ) with
        {
            // Configure asset metadata. Setting the optional fiat ID will enable
            // paying fees using the asset (if available).
            assetMetadata = new List<AssetMetadata>
            {
                new(
                    assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
                    name: "PEGx EUR",
                    ticker: "EURx",
                    precision: 8,
                    fiatId: "EUR"
                )
            }
        };
        // ANCHOR_END: configure-asset-metadata
    }

    public void FetchAssetBalance(BindingLiquidSdk sdk)
    {
        // ANCHOR: fetch-asset-balance
        try
        {
            var info = sdk.GetInfo();
            var assetBalances = info?.walletInfo?.assetBalances;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: fetch-asset-balance
    }
}
