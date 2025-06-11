import {
  defaultConfig,
  connect,
  LiquidNetwork,
} from '@breeztech/react-native-breez-sdk-liquid'
import { Platform } from "react-native"

// ANCHOR: init-sdk-app-group
import SecureStorage, { ACCESSIBLE } from "react-native-secure-storage"
import * as RNFS from "react-native-fs"

const APP_GROUP = 'group.com.example.application'
const MNEMONIC_KEY = 'BREEZ_SDK_LIQUID_SEED_MNEMONIC'

const initSdk = async () => {
  // Read the mnemonic from secure storage using the app group
  let mnemonic = await SecureStorage.getItem(MNEMONIC_KEY, {
    accessGroup: APP_GROUP,
    accessible: ACCESSIBLE.AFTER_FIRST_UNLOCK,
  })

  // Create the default config, providing your Breez API key
  let config = await defaultConfig(
    LiquidNetwork.MAINNET,
    '<your-Breez-API-key>'
  )

  // Set the working directory to the app group path
  if (Platform.OS === "ios") {
    const groupPath = await RNFS.pathForGroup(APP_GROUP)
    config.workingDir = `${groupPath}/breezSdkLiquid`
  }

  await connect({ mnemonic, config })
}
// ANCHOR_END: init-sdk-app-group

