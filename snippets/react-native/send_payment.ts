import {
  prepareSendPayment,
  sendPayment
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleSendLightningPayment = async () => {
  // ANCHOR: send-payment
  // Set the BOLT11 invoice you wish to pay
  const bolt11 = 'bolt11 invoice'

  const prepareSendResponse = await prepareSendPayment({
    invoice: bolt11
  })

  // If the fees are acceptable, continue to create the Send Payment
  const receiveFeesSat = prepareSendResponse.feesSat

  const sendResponse = await sendPayment(prepareSendResponse)
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
}
