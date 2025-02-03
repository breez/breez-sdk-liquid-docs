import {
  InputTypeVariant,
  PaymentMethod,
  type PrepareReceiveResponse,
  fetchLightningLimits,
  fetchOnchainLimits,
  parse,
  prepareReceivePayment,
  type ReceiveAmount,
  ReceiveAmountVariant,
  receivePayment
} from '@breeztech/react-native-breez-sdk-liquid'

const examplePrepareLightningPayment = async () => {
  // ANCHOR: prepare-receive-payment-lightning
  // Fetch the Receive lightning limits
  const currentLimits = await fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  const optionalAmount: ReceiveAmount = {
    type: ReceiveAmountVariant.BITCOIN,
    payerAmountSat: 5_000
  }

  const prepareResponse = await prepareReceivePayment({
    paymentMethod: PaymentMethod.LIGHTNING,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-lightning
}

const examplePrepareOnchainPayment = async () => {
  // ANCHOR: prepare-receive-payment-onchain
  // Fetch the Onchain lightning limits
  const currentLimits = await fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the onchain amount you wish the payer to send, which should be within the above limits
  const optionalAmount: ReceiveAmount = {
    type: ReceiveAmountVariant.BITCOIN,
    payerAmountSat: 5_000
  }

  const prepareResponse = await prepareReceivePayment({
    paymentMethod: PaymentMethod.BITCOIN_ADDRESS,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-onchain
}

const examplePrepareLiquidPayment = async () => {
  // ANCHOR: prepare-receive-payment-liquid

  // Create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  // Note: Not setting the amount will generate a plain Liquid address
  const optionalAmount: ReceiveAmount = {
    type: ReceiveAmountVariant.BITCOIN,
    payerAmountSat: 5_000
  }

  const prepareResponse = await prepareReceivePayment({
    paymentMethod: PaymentMethod.LIQUID_ADDRESS,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-liquid
}

const exampleReceivePayment = async (prepareResponse: PrepareReceiveResponse) => {
  // ANCHOR: receive-payment
  const optionalDescription = '<description>'
  const res = await receivePayment({
    prepareResponse,
    description: optionalDescription
  })

  const destination = res.destination
  // ANCHOR_END: receive-payment
  console.log(destination)
}
