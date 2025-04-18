import { type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'

const _registerWebhook = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: register-webook
  try {
    await sdk.registerWebhook('https://your-nds-service.com/notify?platform=ios&token=<PUSH_TOKEN>')
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: register-webook
}

const _unregisterWebhook = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: unregister-webook
  try {
    await sdk.unregisterWebhook()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: unregister-webook
}
