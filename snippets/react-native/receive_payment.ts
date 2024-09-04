import {
  InputTypeVariant,
  PaymentMethod,
  type PrepareReceiveResponse,
  fetchLightningLimits,
  fetchOnchainLimits,
  parse,
  prepareReceivePayment,
  receivePayment
} from '@breeztech/react-native-breez-sdk-liquid'

const examplePrepareLightningPayment = async () => {
  // ANCHOR: prepare-receive-payment-lightning
  // Fetch the Receive lightning limits
  const currentLimits = await fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  const prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000,
    paymentMethod: PaymentMethod.LIGHTNING
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  // ANCHOR_END: prepare-receive-payment-lightning

  console.log(receiveFeesSat)
}

const examplePrepareOnchainPayment = async () => {
  // ANCHOR: prepare-receive-payment-onchain
  // Fetch the Onchain lightning limits
  const currentLimits = await fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the onchain amount you wish the payer to send, which should be within the above limits
  const prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000,
    paymentMethod: PaymentMethod.BITCOIN_ADDRESS
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  // ANCHOR_END: prepare-receive-payment-onchain

  console.log(receiveFeesSat)
}

const examplePrepareLiquidPayment = async () => {
  // ANCHOR: prepare-receive-payment-liquid

  // Create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  const prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000, // Not specifying the amount will create a plain Liquid address instead
    paymentMethod: PaymentMethod.LIQUID_ADDRESS
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  // ANCHOR_END: prepare-receive-payment-liquid

  console.log(receiveFeesSat)
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
