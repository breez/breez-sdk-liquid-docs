using Breez.Sdk.Liquid;

public class LnurlPaySnippets
{
    public void LnurlPay(BindingLiquidSdk sdk)
    {
        // ANCHOR: lnurl-pay
        // Endpoint can also be of the form:
        // lnurlp://domain.com/lnurl-pay?key=val
        // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
        var lnurlPayUrl = "lightning@address.com";

        try
        {
            var input = BreezSdkMethods.Parse(lnurlPayUrl);
            if (input is InputType.LnUrlPay lnurlp)
            {
                var amountMsat = lnurlp.data.minSendable;
                var optionalComment = "<comment>";
                var optionalPaymentLabel = "<label>";
                var optionalValidateSuccessActionUrl = true;
                var req = new LnUrlPayRequest(
                    lnurlp.data, 
                    amountMsat, 
                    optionalComment, 
                    optionalPaymentLabel, 
                    optionalValidateSuccessActionUrl);
                var result = sdk.PayLnurl(req);
            }
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: lnurl-pay
    }
}
