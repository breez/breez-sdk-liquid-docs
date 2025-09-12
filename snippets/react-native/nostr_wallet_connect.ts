import {
  defaultConfig,
  LiquidNetwork
} from '@breeztech/react-native-breez-sdk-liquid'

const nostrWalletConnect = async () => {
  // ANCHOR: init-nwc
  const config = await defaultConfig(
    LiquidNetwork.MAINNET,
    '<your-Breez-API-key>'
  )

  config.enableNwc = true

  // Optional: You can specify your own Relay URLs
  config.nwcRelayUrls = ["<your-relay-url-1>"]
  // ANCHOR_END: init-nwc
  
  // ANCHOR: create-connection-string
  const nwcConnectionUri = await sdk.getNwcUri()
  // ANCHOR_END: create-connection-string
} 