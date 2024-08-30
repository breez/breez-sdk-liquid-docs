using Breez.Sdk.Liquid;

public class LnurlAuthSnippets
{
    public void LnurlAuth(BindingLiquidSdk sdk)
    {
        // ANCHOR: lnurl-auth
        // Endpoint can also be of the form:
        // keyauth://domain.com/auth?key=val
        var lnurlAuthUrl = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";

        try
        {
            var input = BreezSdkMethods.Parse(lnurlAuthUrl);
            if (input is InputType.LnUrlAuth lnurla)
            {
                var result = sdk.LnurlAuth(lnurla.data);
                if (result is LnUrlCallbackStatus.Ok)
                {
                    Console.WriteLine("Successfully authenticated");
                }
                else
                {
                    Console.WriteLine("Failed to authenticate");
                }
            }
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: lnurl-auth
    }
}
