import {
  prepareSendPayment,
  sendPayment,
  type PrepareSendResponse
} from '@breeztech/react-native-breez-sdk-liquid'

const examplePrepareSendPaymentLightning = async () => {
  // ANCHOR: prepare-send-payment-lightning
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = await prepareSendPayment({
    destination: '<bolt11 invoice>'
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-lightning
}

const examplePrepareSendPaymentLiquid = async () => {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmountSat = 5_000
  const prepareResponse = await prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amountSat: optionalAmountSat
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid
}

const exampleSendPayment = async (prepareResponse: PrepareSendResponse) => {
  // ANCHOR: send-payment
  const sendResponse = await sendPayment({
    prepareResponse
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
  console.log(payment)
}
