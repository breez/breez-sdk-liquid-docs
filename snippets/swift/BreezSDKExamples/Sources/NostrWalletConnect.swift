import BreezSDKLiquid
import Foundation

func nostrWalletConnect() async throws {
    // ANCHOR: nwc-config
    let nwcConfig = NwcConfig(
        relayUrls: ["<your-relay-url-1>"],               // Optional: Custom relay URLs (uses default if nil)
        secretKeyHex: "your-nostr-secret-key-hex"        // Optional: Custom Nostr secret key
    )
    
    let nwcService = SdkNwcService(config: nwcConfig)
    
    // Add the plugin to your SDK
    let plugins: [Plugin] = [nwcService]
    // ANCHOR_END: nwc-config

    // ANCHOR: add-connection
    let connectionName = "my-app-connection"
    let connectionString = try await nwcService.addConnectionString(name: connectionName)
    // ANCHOR_END: add-connection

    // ANCHOR: list-connections
    let connections = try await nwcService.listConnectionStrings()
    // ANCHOR_END: list-connections

    // ANCHOR: remove-connection
    try await nwcService.removeConnectionString(name: connectionName)
    // ANCHOR_END: remove-connection

    // ANCHOR: event-listener
    class MyNwcEventListener: NwcEventListener {
        func onEvent(event: NwcEvent) async {
            switch event.details {
            case .connected:
                print("NWC connected")
            case .disconnected:
                print("NWC disconnected")
            case .payInvoice(let success, _, _, _):
                print("Payment \(success ? "successful" : "failed")")
            case .listTransactions:
                print("Transactions requested")
            case .getBalance:
                print("Balance requested")
            }
        }
    }
    // ANCHOR_END: event-listener

    // ANCHOR: event-management
    // Add event listener
    let listener = MyNwcEventListener()
    let listenerId = await nwcService.addEventListener(listener: listener)

    // Remove event listener when no longer needed
    await nwcService.removeEventListener(id: listenerId)
    // ANCHOR_END: event-management

    // ANCHOR: error-handling
    do {
        let connectionString = try await nwcService.addConnectionString(name: "test")
        print("Connection created: \(connectionString)")
    } catch NwcError.generic(let msg) {
        print("Generic error: \(msg)")
    } catch NwcError.persist(let msg) {
        print("Persistence error: \(msg)")
    } catch {
        print("Unknown error: \(error)")
    }
    // ANCHOR_END: error-handling
}