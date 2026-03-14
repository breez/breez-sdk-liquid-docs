import {
  type BindingLiquidSdk,
  PayAmount,
  type PrepareSendResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGetCurrentLightningLimits = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: get-current-pay-lightning-limits
  try {
    const currentLimits = sdk.fetchLightningLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: get-current-pay-lightning-limits
}

const examplePrepareSendPaymentLightningBolt11 = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-lightning-bolt11
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = sdk.prepareSendPayment({
    destination: '<bolt11 invoice>',
    amount: undefined,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-lightning-bolt11
}

const examplePrepareSendPaymentLightningBolt12 = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-lightning-bolt12
  // Set the bolt12 offer you wish to pay
  const optionalAmount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<bolt12 offer>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })
  // ANCHOR_END: prepare-send-payment-lightning-bolt12
}

const examplePrepareSendPaymentLiquid = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-liquid
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid
}

const examplePrepareSendPaymentLiquidDrain = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-liquid-drain
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = new PayAmount.Drain()

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-liquid-drain
}

const exampleSendPayment = async (sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) => {
  // ANCHOR: send-payment
  const optionalPayerNote = '<payer note>'
  const sendResponse = sdk.sendPayment({
    prepareResponse,
    payerNote: optionalPayerNote,
    useAssetFees: undefined
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment
  console.log(payment)
}
