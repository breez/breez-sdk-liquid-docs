using Breez.Sdk.Liquid;

public class LnurlPaySnippets
{
    public void PrepareLnurlPay(BindingLiquidSdk sdk)
    {
        // ANCHOR: prepare-lnurl-pay
        // Endpoint can also be of the form:
        // lnurlp://domain.com/lnurl-pay?key=val
        // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
        var lnurlPayUrl = "lightning@address.com";

        try
        {
            var input = sdk.Parse(lnurlPayUrl);
            if (input is InputType.LnUrlPay lnurlp)
            {
                var amount = new PayAmount.Bitcoin(5000);
                var optionalComment = "<comment>";
                var optionalValidateSuccessActionUrl = true;
                
                var req = new PrepareLnUrlPayRequest(
                    lnurlp.data, 
                    amount, 
                    optionalComment, 
                    optionalValidateSuccessActionUrl);
                var prepareResponse = sdk.PrepareLnurlPay(req);

                // If the fees are acceptable, continue to create the LNURL Pay
                var feesSat = prepareResponse.feesSat;
                Console.WriteLine($"Fees: {feesSat} sats");
            }
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-lnurl-pay
    }
    public void PrepareLnurlPayDrain(BindingLiquidSdk sdk, LnUrlPayRequestData data)
    {
        // ANCHOR: prepare-lnurl-pay-drain
        try
        {
            var amount = new PayAmount.Drain();
            var optionalComment = "<comment>";
            var optionalValidateSuccessActionUrl = true;
            
            var req = new PrepareLnUrlPayRequest(
                data, 
                amount, 
                optionalComment, 
                optionalValidateSuccessActionUrl);
            var prepareResponse = sdk.PrepareLnurlPay(req);
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: prepare-lnurl-pay-drain
    }

    public void LnurlPay(BindingLiquidSdk sdk, PrepareLnUrlPayResponse prepareResponse)
    {
        // ANCHOR: lnurl-pay
        try
        {
            var result = sdk.LnurlPay(new LnUrlPayRequest(prepareResponse));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: lnurl-pay
    }
}
