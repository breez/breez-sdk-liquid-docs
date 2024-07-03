import { receivePayment } from '@breeztech/react-native-breez-liquid-sdk'

const exampleReceiveLightningPayment = async () => {
  // ANCHOR: receive-payment
  const receivePaymentResponse = await receivePayment({
    amountMsat: 3_000_000,
    description: 'Invoice for 3000 sats'
  })

  const invoice = receivePaymentResponse.lnInvoice
  // ANCHOR_END: receive-payment
}
