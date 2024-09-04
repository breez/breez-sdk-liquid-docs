import {
  prepareSendPayment,
  sendPayment
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleSendLightningPayment = async () => {
  // ANCHOR: send-payment
  // Set the Lightning invoice, Liquid BIP21 or Liquid address you wish to pay
  const optionalAmountSat = 5_000
  const prepareResponse = await prepareSendPayment({
    destination: 'Invoice, liquid address or BIP21 URI',
    amountSat: optionalAmountSat
  })

  // If the fees are acceptable, continue to create the Send Payment
  const receiveFeesSat = prepareResponse.feesSat

  const sendResponse = await sendPayment({
    prepareResponse
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
}
