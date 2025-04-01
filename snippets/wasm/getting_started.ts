import {
  defaultConfig,
  connect,
  type SdkEvent,
  setLogger,
  type BindingLiquidSdk,
  LogEntry
} from '@breeztech/breez-sdk-liquid'

// Init stub
const init = async () => {}

const exampleGettingStarted = async () => {
  // ANCHOR: init-sdk
  const mnemonic = '<mnemonics words>'

  // Call init when using the SDK in a web environment before calling any other SDK
  // methods. This is not needed when using the SDK in a Node.js/Deno environment.
  //
  // import init, { defaultConfig, connect } from '@breeztech/breez-sdk-liquid'
  await init()

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  const sdk = await connect({ mnemonic, config })
  // ANCHOR_END: init-sdk
}

const exampleFetchNodeInfo = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: fetch-balance
  const info = await sdk.getInfo()
  const balanceSat = info.walletInfo.balanceSat
  const pendingSendSat = info.walletInfo.pendingSendSat
  const pendingReceiveSat = info.walletInfo.pendingReceiveSat
  // ANCHOR_END: fetch-balance
}

const exampleLogging = async () => {
  // ANCHOR: logging
  class JsLogger {
    log = (l: LogEntry) => {
      console.log(`[${l.level}]: ${l.line}`)
    }
  }

  const logger = new JsLogger()
  setLogger(logger)
  // ANCHOR_END: logging
}

const exampleAddEventListener = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: add-event-listener
  class JsEventListener {
    onEvent = (event: SdkEvent) => {
      console.log(`Received event: ${JSON.stringify(event)}`)
    }
  }

  const eventListener = new JsEventListener()

  const listenerId = await sdk.addEventListener(eventListener)
  // ANCHOR_END: add-event-listener
}

const exampleRemoveEventListener = async (sdk: BindingLiquidSdk, listenerId: string) => {
  // ANCHOR: remove-event-listener
  await sdk.removeEventListener(listenerId)
  // ANCHOR_END: remove-event-listener
}

const exampleDisconnect = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: disconnect
  await sdk.disconnect()
  // ANCHOR_END: disconnect
}
