func nostrWalletConnect() async {
    // ANCHOR: init-nwc
    var config = Config.default
    
    config.enableNwc = true

    // Optional: You can specify your own Relay URLs
    config.nwcRelayUrls = ["<your-relay-url-1>"]
    // ANCHOR_END: init-nwc
    
    // ANCHOR: create-connection-string
    let nwcConnectionUri = try await sdk.getNwcUri()
    // ANCHOR_END: create-connection-string
}