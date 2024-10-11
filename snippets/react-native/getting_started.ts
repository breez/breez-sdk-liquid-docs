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
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleGettingStarted = async () => {
  // ANCHOR: init-sdk
  const mnemonic = '<mnemonics words>'

  // Create the default config
  const config = await defaultConfig(
    LiquidNetwork.MAINNET
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
  const walletInfo = await getInfo()
  const balanceSat = walletInfo.balanceSat
  const pendingSendSat = walletInfo.pendingSendSat
  const pendingReceiveSat = walletInfo.pendingReceiveSat
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
