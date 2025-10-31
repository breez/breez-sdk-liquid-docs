import {
  BindingNwcService,
  Plugin,
  NwcConfig,
  NwcEventListener,
  NwcEvent,
  NwcEventDetails,
  NwcErrorGeneric,
  NwcErrorPersist
} from '@breeztech/breez-sdk-liquid';

async function nostrWalletConnect() {
    // ANCHOR: nwc-config
    const nwcConfig: NwcConfig = {
        relayUrls: ["<your-relay-url-1>"],               // Optional: Custom relay URLs (uses default if undefined)
        secretKeyHex: "your-nostr-secret-key-hex"        // Optional: Custom Nostr secret key
    };
    
    const nwcService = new BindingNwcService(nwcConfig);
    
    // Add the plugin to your SDK
    const plugins: Plugin[] = [nwcService];
    // ANCHOR_END: nwc-config

    // ANCHOR: add-connection
    const connectionName = "my-app-connection";
    const connectionString = await nwcService.addConnectionString(connectionName);
    // ANCHOR_END: add-connection

    // ANCHOR: list-connections
    const connections = await nwcService.listConnectionStrings();
    // ANCHOR_END: list-connections

    // ANCHOR: remove-connection
    await nwcService.removeConnectionString(connectionName);
    // ANCHOR_END: remove-connection

    // ANCHOR: event-listener
    class MyNwcEventListener implements NwcEventListener {
        async onEvent(event: NwcEvent) {
            switch (event.details.type) {
                case 'Connected':
                    console.log("NWC connected");
                    break;
                case 'Disconnected':
                    console.log("NWC disconnected");
                    break;
                case 'PayInvoice':
                    const success = event.details.success;
                    console.log(`Payment ${success ? "successful" : "failed"}`);
                    break;
                case 'ListTransactions':
                    console.log("Transactions requested");
                    break;
                case 'GetBalance':
                    console.log("Balance requested");
                    break;
            }
        }
    }
    // ANCHOR_END: event-listener

    // ANCHOR: event-management
    // Add event listener
    const listener = new MyNwcEventListener();
    const listenerId = await nwcService.addEventListener(listener);

    // Remove event listener when no longer needed
    await nwcService.removeEventListener(listenerId);
    // ANCHOR_END: event-management

    // ANCHOR: error-handling
    try {
        const connectionString = await nwcService.addConnectionString("test");
        console.log(`Connection created: ${connectionString}`);
    } catch (error: any) {
        if (error.type === 'Generic') {
            console.log(`Generic error: ${error.err}`);
        } else if (error.type === 'Persist') {
            console.log(`Persistence error: ${error.err}`);
        } else {
            console.log(`Unknown error: ${error}`);
        }
    }
    // ANCHOR_END: error-handling
}