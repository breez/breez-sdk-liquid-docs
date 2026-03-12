import { BindingLiquidSdk } from '@breeztech/breez-sdk-liquid-react-native'

const _registerWebhook = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: register-webook
  try {
    sdk.registerWebhook('https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>')
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: register-webook
}

const _unregisterWebhook = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: unregister-webook
  try {
    sdk.unregisterWebhook()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: unregister-webook
}
