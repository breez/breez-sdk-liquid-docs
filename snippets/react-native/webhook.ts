import { registerWebhook, unregisterWebhook } from '@breeztech/react-native-breez-sdk-liquid'

const _registerWebhook = async () => {
  // ANCHOR: register-webook
  try {
    await registerWebhook('https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>')
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: register-webook
}

const _unregisterWebhook = async () => {
  // ANCHOR: unregister-webook
  try {
    await unregisterWebhook()
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: unregister-webook
}
