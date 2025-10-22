import {
  addEventListener,
  defaultConfig,
  connect,
  LiquidNetwork,
  type LogEntry,
  getInfo,
  removeEventListener,
  disconnect,
  type SdkEvent,
  setLogger
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGettingStarted = async () => {
  // ANCHOR: init-sdk
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = await defaultConfig(
    LiquidNetwork.MAINNET,
    '<your-Breez-API-key>'
  )

  // By default in React Native the workingDir is set to:
  // `/<APPLICATION_SANDBOX_DIRECTORY>/breezSdkLiquid`
  // You can change this to another writable directory or a
  // subdirectory of the workingDir if managing multiple mnemonics.
  console.log(`Working directory: ${config.workingDir}`)
  // config.workingDir = "path to writable directory"

  await connect({ mnemonic, config })
  // ANCHOR_END: init-sdk
}

const exampleFetchNodeInfo = async () => {
  // ANCHOR: fetch-balance
  const info = await getInfo()
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

  const subscription = await setLogger(onLogEntry)
  // ANCHOR_END: logging
}

const exampleAddEventListener = async () => {
  // ANCHOR: add-event-listener
  const onEvent = (e: SdkEvent) => {
    console.log(`Received event: ${e.type}`)
  }

  const listenerId = await addEventListener(onEvent)
  // ANCHOR_END: add-event-listener
}

const exampleRemoveEventListener = async (listenerId: string) => {
  // ANCHOR: remove-event-listener
  await removeEventListener(listenerId)
  // ANCHOR_END: remove-event-listener
}

const exampleDisconnect = async () => {
  // ANCHOR: disconnect
  await disconnect()
  // ANCHOR_END: disconnect
}
