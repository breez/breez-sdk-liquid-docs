import {
  addEventListner,
  defaultConfig,
  connect,
  LiquidNetwork,
  LogEntry,
  getInfo,
  removeEventListner,
  SdkEvent,
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
  // subdirectory of the workingDir if managing multiple nodes.
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
    console.log(`Received event: ${e}`)
  }

  const listenerId = await addEventListner(onEvent)
  // ANCHOR_END: add-event-listener
}

const exampleRemoveEventListener = async (listenerId: string) => {
  // ANCHOR: remove-event-listener
  await removeEventListner(listenerId)
  // ANCHOR_END: remove-event-listener
}
