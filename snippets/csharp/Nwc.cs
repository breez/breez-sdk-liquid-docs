using Breez.Sdk.Liquid;
using Breez.Sdk.Liquid.Nwc;

public class NwcSnippets
{
    public SdkNwcService NwcConnect(BindingLiquidSdk sdk)
    {
        // ANCHOR: connecting
        var nwcConfig = new NwcConfig(
            relayUrls: null,
            secretKeyHex: null,
            listenToEvents: null
        );
        SdkNwcService nwcService;
        try
        {
            nwcService = sdk.UseNwcPlugin(nwcConfig);
        }
        catch (Exception)
        {
            // Handle error
            return null!;
        }

        // ...

        // Automatically stops the plugin
        try { sdk.Disconnect(); } catch { }
        // Alternatively, you can stop the plugin manually, without disconnecting the SDK
        nwcService.Stop();
        // ANCHOR_END: connecting

        return nwcService;
    }

    public void NwcAddConnection(SdkNwcService nwcService)
    {
        // ANCHOR: add-connection
        // This connection will only allow spending at most 10,000 sats/hour
        var periodicBudgetReq = new PeriodicBudgetRequest(
            maxBudgetSat: 10000,
            renewalTimeMins: 60  // Renews every hour
        );
        try
        {
            nwcService.AddConnection(new AddConnectionRequest(
                name: "my new connection",
                expiryTimeMins: 60,  // Expires after one hour
                periodicBudgetReq: periodicBudgetReq,
                receiveOnly: null  // Defaults to false
            ));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: add-connection
    }

    public void NwcEditConnection(SdkNwcService nwcService)
    {
        // ANCHOR: edit-connection
        uint newExpiryTime = 60 * 24;
        try
        {
            nwcService.EditConnection(new EditConnectionRequest(
                name: "my new connection",
                expiryTimeMins: newExpiryTime,  // The connection will now expire after 1 day
                periodicBudgetReq: null,
                receiveOnly: null,
                removeExpiry: null,
                removePeriodicBudget: true  // The periodic budget has been removed
            ));
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: edit-connection
    }

    public void NwcListConnections(SdkNwcService nwcService)
    {
        // ANCHOR: list-connections
        try
        {
            var connections = nwcService.ListConnections();
            foreach (var (connectionName, connection) in connections)
            {
                Console.WriteLine(
                    $"Connection: {connectionName} - Expires at: {connection.expiresAt}, Periodic Budget: {connection.periodicBudget}"
                );
                // ...
            }
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: list-connections
    }

    public void NwcRemoveConnection(SdkNwcService nwcService)
    {
        // ANCHOR: remove-connection
        try
        {
            nwcService.RemoveConnection("my new connection");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: remove-connection
    }

    public void NwcGetInfo(SdkNwcService nwcService)
    {
        // ANCHOR: get-info
        var info = nwcService.GetInfo();
        // ANCHOR_END: get-info
    }

    // ANCHOR: events
    public class MyListener : NwcEventListener
    {
        public void OnEvent(NwcEvent e)
        {
            switch (e.details)
            {
                case NwcEventDetails.Connected:
                    // ...
                    break;
                case NwcEventDetails.Disconnected:
                    // ...
                    break;
                case NwcEventDetails.PayInvoice payInvoice:
                    // payInvoice.success, payInvoice.preimage, payInvoice.feesSat, payInvoice.error
                    // ...
                    break;
                case NwcEventDetails.ZapReceived zapReceived:
                    // zapReceived.invoice
                    // ...
                    break;
                default:
                    break;
            }
        }
    }

    public void NwcEvents(SdkNwcService nwcService)
    {
        var eventListener = new MyListener();
        try
        {
            var myListenerId = nwcService.AddEventListener(eventListener);
            // If you wish to remove the event_listener later on, you can call:
            nwcService.RemoveEventListener(myListenerId);
            // Otherwise, it will be automatically removed on service stop
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: events
    }

    public void NwcListPayments(SdkNwcService nwcService)
    {
        // ANCHOR: payments
        try
        {
            nwcService.ListConnectionPayments("my new connection");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: payments
    }
}
