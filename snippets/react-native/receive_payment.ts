import {
  InputTypeVariant,
  PaymentMethod,
  fetchLightningLimits,
  fetchOnchainLimits,
  parse,
  prepareReceivePayment,
  receivePayment
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleReceiveLightningPayment = async () => {
  // ANCHOR: receive-payment
  // Fetch the Receive lightning limits
  let currentLimits = await fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  let prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000,
    paymentMethod: PaymentMethod.LIGHTNING
  })

  // Fetch the Receive bitcoin limits
  currentLimits = await fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000,
    paymentMethod: PaymentMethod.BITCOIN_ADDRESS
  })

  // Or simply create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  prepareResponse = await prepareReceivePayment({
    payerAmountSat: 5_000, // Not specifying the amount will create a plain Liquid address instead
    paymentMethod: PaymentMethod.LIQUID_ADDRESS
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat

  const optionalDescription = '<description>'
  const res = await receivePayment({
    prepareResponse,
    description: optionalDescription
  })

  // Parse the resulting destination for confirmation
  let output = await parse(res.destination);
  switch (output.type) {
    case InputTypeVariant.BOLT11:
      console.log(output.invoice)
      break;
    case InputTypeVariant.BITCOIN_ADDRESS:
      console.log(output.address)
      break;
    case InputTypeVariant.LIQUID_ADDRESS:
      console.log(output.address)
      break;
  }
  // ANCHOR_END: receive-payment
}
