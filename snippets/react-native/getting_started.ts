import {
  defaultConfig,
  connect,
  LiquidNetwork,
  getInfo
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleGettingStarted = async () => {
  // ANCHOR: init-sdk
  const mnemonic = '<mnemonics words>'

  // Create the default config
  const config = await defaultConfig(
    LiquidNetwork.MAINNET
  )

  // Customize the config object according to your needs
  config.workingDir = 'path to an existing directory'

  const sdk = await connect({ mnemonic, config })
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
