import {
  fetchLightningLimits,
  prepareReceivePayment,
  receivePayment
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleReceiveLightningPayment = async () => {
  // ANCHOR: receive-payment
  // Fetch the Receive limits
  const currentLimits = await fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send, which should be within the above limits
  const prepareReceiveResponse = await prepareReceivePayment({
    payerAmountSat: 5000
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareReceiveResponse.feesSat

  const receivePaymentResponse = await receivePayment(prepareReceiveResponse)

  const invoice = receivePaymentResponse.invoice
  // ANCHOR_END: receive-payment
}
