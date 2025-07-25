using Breez.Sdk.Liquid;

public class NostrWalletConnectSnippets
{
  public void NostrWalletConnect()
  {
    // ANCHOR: init-nwc
    var config = BreezSdkLiquidMethods.DefaultConfig(
      LiquidNetwork.Mainnet,
      "<your-Breez-API-key>"
    );

    config = config with { enableNwc = true };

    // Optional: You can specify your own Relay URLs
    config = config with { nwcRelayUrls = new List<string> { "<your-relay-url-1>" } };
    // ANCHOR_END: init-nwc
    
    // ANCHOR: create-connection-string
    var nwcConnectionUri = await sdk.GetNwcUri();
    // ANCHOR_END: create-connection-string
  }
} 