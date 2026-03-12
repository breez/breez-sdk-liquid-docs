import {
  BindingLiquidSdk,
  defaultConfig,
  connect,
  LiquidNetwork,
  type LogEntry,
  type SdkEvent,
  setLogger
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGettingStarted = async () => {
  // ANCHOR: init-sdk
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = defaultConfig(
    LiquidNetwork.Mainnet,
    '<your-Breez-API-key>'
  )

  // By default in React Native the workingDir is set to:
  // `/<APPLICATION_SANDBOX_DIRECTORY>/breezSdkLiquid`
  // You can change this to another writable directory or a
  // subdirectory of the workingDir if managing multiple mnemonics.
  console.log(`Working directory: ${config.workingDir}`)
  // config.workingDir = "path to writable directory"

  connect({
    mnemonic, config,
    passphrase: undefined,
    seed: undefined
  })
  // ANCHOR_END: init-sdk
}

const exampleFetchNodeInfo = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: fetch-balance
  const info = sdk.getInfo()
  const balanceSat = info.walletInfo.balanceSat
  const pendingSendSat = info.walletInfo.pendingSendSat
  const pendingReceiveSat = info.walletInfo.pendingReceiveSat
  // ANCHOR_END: fetch-balance
}

const exampleLogging = async () => {
  // ANCHOR: logging
  const onLogEntry = (l: LogEntry) => {
    console.log(`Received log [${l.level}]: ${l.line}`)
  }

  const subscription = setLogger({ log: onLogEntry })
  // ANCHOR_END: logging
}

const exampleAddEventListener = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: add-event-listener
  const onEvent = (e: SdkEvent) => {
    console.log(`Received event: ${e.tag}`)
  }

  const listenerId = sdk.addEventListener({ onEvent })
  // ANCHOR_END: add-event-listener
}

const exampleRemoveEventListener = async (sdk: BindingLiquidSdk, listenerId: string) => {
  // ANCHOR: remove-event-listener
  sdk.removeEventListener(listenerId)
  // ANCHOR_END: remove-event-listener
}

const exampleDisconnect = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: disconnect
  sdk.disconnect()
  // ANCHOR_END: disconnect
}
