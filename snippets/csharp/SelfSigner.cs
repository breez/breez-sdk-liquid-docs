using Breez.Sdk.Liquid;

public class SelfSignerSnippets
{
    // ANCHOR: self-signer
    public void ConnectWithSelfSigner(Signer signer)
    {

        // Create the default config, providing your Breez API key
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Mainnet,
            "<your-Breez-API-key>"
        ) with
        {
            // Customize the config object according to your needs
            workingDir = "path to an existing directory"
        };

        try
        {
            var connectRequest = new ConnectWithSignerRequest(config);
            var sdk = BreezSdkLiquidMethods.ConnectWithSigner(connectRequest, signer, null);
        }
        catch (Exception)
        {
            // Handle error
        }        
    }
    // ANCHOR_END: self-signer
}