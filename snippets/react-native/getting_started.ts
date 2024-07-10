import {
  defaultConfig,
  connect,
  LiquidNetwork,
  getInfo
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
  const nodeState = await getInfo()
  const balanceSat = nodeState.balanceSat
  const pendingSendSat = nodeState.pendingSendSat
  const pendingReceiveSat = nodeState.pendingReceiveSat
  // ANCHOR_END: fetch-balance
}
