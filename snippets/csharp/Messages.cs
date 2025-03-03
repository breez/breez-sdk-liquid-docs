using Breez.Sdk.Liquid;

public class MessagesSnippets
{
    public void SignMessage(BindingLiquidSdk sdk)
    {
        // ANCHOR: sign-message
        var message = "<message to sign>";
        try
        {
            var signMessageRequest = new SignMessageRequest(message);
            var signMessageResponse = sdk.SignMessage(signMessageRequest);

            // Get the wallet info for your pubkey
            var info = sdk.GetInfo();

            var signature = signMessageResponse?.signature;
            var pubkey = info?.walletInfo?.pubkey;

            Console.WriteLine($"Pubkey: {pubkey}");
            Console.WriteLine($"Signature: {signature}");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: sign-message
    }

    public void CheckMessage(BindingLiquidSdk sdk)
    {
        // ANCHOR: check-message
        var message = "<message>";
        var pubkey = "<pubkey of signer>";
        var signature = "<message signature>";
        try
        {
            var checkMessageRequest = new CheckMessageRequest(message, pubkey, signature);
            var checkMessageResponse = sdk.CheckMessage(checkMessageRequest);

            var isValid = checkMessageResponse?.isValid;

            Console.WriteLine($"Signature valid: {isValid}");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: check-message
    }
}
