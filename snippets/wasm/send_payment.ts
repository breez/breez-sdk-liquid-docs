import {
  type PayAmount,
  type PrepareSendResponse,
  type BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid'

const examplePrepareSendPaymentLightningBolt11 = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-lightning-bolt11
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<bolt11 invoice>'
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-lightning-bolt11
}

const examplePrepareSendPaymentLightningBolt12 = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-lightning-bolt12
  // Set the bolt12 offer you wish to pay
  const optionalAmount: PayAmount = {
    type: 'bitcoin',
    receiverAmountSat: 5_000
  }

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<bolt12 offer>',
    amount: optionalAmount
  })
  // ANCHOR_END: prepare-send-payment-lightning-bolt12
}

const examplePrepareSendPaymentLiquid = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount: PayAmount = {
    type: 'bitcoin',
    receiverAmountSat: 5_000
  }

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid
}

const examplePrepareSendPaymentLiquidDrain = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-liquid-drain
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount: PayAmount = {
    type: 'drain'
  }

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid-drain
}

const exampleSendPayment = async (sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) => {
  // ANCHOR: send-payment
  const sendResponse = await sdk.sendPayment({
    prepareResponse
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
  console.log(payment)
}
