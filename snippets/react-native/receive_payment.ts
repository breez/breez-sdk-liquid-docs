import {
  fetchLightningLimits,
  prepareReceivePayment,
  receivePayment
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleReceiveLightningPayment = async () => {
  // ANCHOR: receive-payment
  // Fetch the Receive limits
  const currentLimits = await fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send, which should be within the above limits
  const prepareRes = await prepareReceivePayment({
    payerAmountSat: 5_000
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareRes.feesSat

  const optionalDescription = '<description>'
  const res = await receivePayment({
    prepareRes,
    description: optionalDescription
  })

  const invoice = res.invoice
  // ANCHOR_END: receive-payment
}
