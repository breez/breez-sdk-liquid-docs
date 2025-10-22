import {
  fetchLightningLimits,
  prepareSendPayment,
  sendPayment,
  type PayAmount,
  PayAmountVariant,
  type PrepareSendResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGetCurrentLightningLimits = async () => {
  // ANCHOR: get-current-pay-lightning-limits
  try {
    const currentLimits = await fetchLightningLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: get-current-pay-lightning-limits
}

const examplePrepareSendPaymentLightningBolt11 = async () => {
  // ANCHOR: prepare-send-payment-lightning-bolt11
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = await prepareSendPayment({
    destination: '<bolt11 invoice>'
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-lightning-bolt11
}

const examplePrepareSendPaymentLightningBolt12 = async () => {
  // ANCHOR: prepare-send-payment-lightning-bolt12
  // Set the bolt12 offer you wish to pay
  const optionalAmount: PayAmount = {
    type: PayAmountVariant.BITCOIN,
    receiverAmountSat: 5_000
  }

  const prepareResponse = await prepareSendPayment({
    destination: '<bolt12 offer>',
    amount: optionalAmount
  })
  // ANCHOR_END: prepare-send-payment-lightning-bolt12
}

const examplePrepareSendPaymentLiquid = async () => {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount: PayAmount = {
    type: PayAmountVariant.BITCOIN,
    receiverAmountSat: 5_000
  }

  const prepareResponse = await prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid
}

const examplePrepareSendPaymentLiquidDrain = async () => {
  // ANCHOR: prepare-send-payment-liquid-drain
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount: PayAmount = {
    type: PayAmountVariant.DRAIN
  }

  const prepareResponse = await prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid-drain
}

const exampleSendPayment = async (prepareResponse: PrepareSendResponse) => {
  // ANCHOR: send-payment
  const optionalPayerNote = '<payer note>'
  const sendResponse = await sendPayment({
    prepareResponse,
    payerNote: optionalPayerNote
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
  console.log(payment)
}
