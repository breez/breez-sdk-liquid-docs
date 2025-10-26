using Breez.Sdk.Liquid;

// ANCHOR: event-listener
public class MyNwcEventListener : NwcEventListener
{
    public void OnEvent(NwcEvent event)
    {
        switch (event.Details)
        {
            case NwcEventDetails.Connected:
                Console.WriteLine("NWC connected");
                break;
            case NwcEventDetails.Disconnected:
                Console.WriteLine("NWC disconnected");
                break;
            case NwcEventDetails.PayInvoice payInvoice:
                Console.WriteLine($"Payment {(payInvoice.Success ? "successful" : "failed")}");
                break;
            case NwcEventDetails.ListTransactions:
                Console.WriteLine("Transactions requested");
                break;
            case NwcEventDetails.GetBalance:
                Console.WriteLine("Balance requested");
                break;
        }
    }
}
// ANCHOR_END: event-listener

public class NostrWalletConnect
{
    public static void NostrWalletConnectMethod()
    {
        // ANCHOR: nwc-config
        var nwcConfig = new NwcConfig
        {
            RelayUrls = new[] { "<your-relay-url-1>" },       // Optional: Custom relay URLs (uses default if null)
            SecretKeyHex = "your-nostr-secret-key-hex"        // Optional: Custom Nostr secret key
        };
        
        var nwcService = new BindingNwcService(nwcConfig);
        
        // Add the plugin to your SDK
        var plugins = new Plugin[] { nwcService };
        // ANCHOR_END: nwc-config

        // ANCHOR: add-connection
        var connectionName = "my-app-connection";
        var connectionString = nwcService.AddConnectionString(connectionName);
        // ANCHOR_END: add-connection

        // ANCHOR: list-connections
        var connections = nwcService.ListConnectionStrings();
        // ANCHOR_END: list-connections

        // ANCHOR: remove-connection
        nwcService.RemoveConnectionString(connectionName);
        // ANCHOR_END: remove-connection

        // ANCHOR: event-management
        // Add event listener
        var listener = new MyNwcEventListener();
        var listenerId = nwcService.AddEventListener(listener);

        // Remove event listener when no longer needed
        nwcService.RemoveEventListener(listenerId);
        // ANCHOR_END: event-management

        // ANCHOR: error-handling
        try
        {
            var connectionString = nwcService.AddConnectionString("test");
            Console.WriteLine($"Connection created: {connectionString}");
        }
        catch (NwcErrorGeneric e)
        {
            Console.WriteLine($"Generic error: {e.Err}");
        }
        catch (NwcErrorPersist e)
        {
            Console.WriteLine($"Persistence error: {e.Err}");
        }
        // ANCHOR_END: error-handling
    }
}