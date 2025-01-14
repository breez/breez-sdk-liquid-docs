using Breez.Sdk.Liquid;

public class GettingStartedSnippets
{
    public void Start()
    {
        // ANCHOR: init-sdk
        var mnemonic = "<mnemonic words>";

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
            var connectRequest = new ConnectRequest(config, mnemonic);
            var sdk = BreezSdkLiquidMethods.Connect(connectRequest);
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: init-sdk
    }

    public void FetchBalance(BindingLiquidSdk sdk)
    {
        // ANCHOR: fetch-balance
        try
        {
            var info = sdk.GetInfo();
            var balanceSat = info?.walletInfo?.balanceSat;
            var pendingSendSat = info?.walletInfo?.pendingSendSat;
            var pendingReceiveSat = info?.walletInfo?.pendingReceiveSat;
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: fetch-balance
    }

    // ANCHOR: logging
    public class SdkLogger : Logger
    {
        public void Log(LogEntry l)
        {
            Console.WriteLine($"Received log [{l.level}]: {l.line}");
        }
    }

    public void SetLogger(SdkLogger logger)
    {
        try
        {
            BreezSdkLiquidMethods.SetLogger(logger);
        }
        catch (Exception)
        {
            // Handle error
        }
    }
    // ANCHOR_END: logging

    // ANCHOR: add-event-listener
    public class SdkListener : EventListener
    {
        public void OnEvent(SdkEvent e)
        {
            Console.WriteLine($"Received event {e}");
        }
    }

    public String? AddEventListener(BindingLiquidSdk sdk, SdkListener listener)
    {
        try
        {
            var listenerId = sdk.AddEventListener(listener);
            return listenerId;
        }
        catch (Exception)
        {
            // Handle error
            return null;
        }
    }
    // ANCHOR_END: add-event-listener

    // ANCHOR: remove-event-listener
    public void RemoveEventListener(BindingLiquidSdk sdk, String listenerId)
    {
        try
        {
            sdk.RemoveEventListener(listenerId);
        }
        catch (Exception)
        {
            // Handle error
        }
    }
    // ANCHOR_END: remove-event-listener

    // ANCHOR: disconnect
    public void Disconnect(BindingLiquidSdk sdk)
    {
        try
        {
            sdk.Disconnect();
        }
        catch (Exception)
        {
            // Handle error
        }
    }
    // ANCHOR_END: disconnect
}
