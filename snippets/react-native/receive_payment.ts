import {
  type BindingLiquidSdk,
  PaymentMethod,
  type PrepareReceiveResponse,
  ReceiveAmount
} from '@breeztech/breez-sdk-liquid-react-native'

const examplePrepareLightningPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-receive-payment-lightning
  // Fetch the Receive lightning limits
  const currentLimits = sdk.fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.Bolt11Invoice,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-lightning
}

const examplePrepareLightningBolt12Payment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-receive-payment-lightning-bolt12
  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.Bolt12Offer,
    amount: undefined
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const minReceiveFeesSat = prepareResponse.feesSat
  const swapperFeerate = prepareResponse.swapperFeerate
  console.log(`Fees: ${minReceiveFeesSat} sats + ${swapperFeerate}% of the sent amount`)
  // ANCHOR_END: prepare-receive-payment-lightning-bolt12
}

const examplePrepareOnchainPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-receive-payment-onchain
  // Fetch the Onchain lightning limits
  const currentLimits = sdk.fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the onchain amount you wish the payer to send, which should be within the above limits
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.BitcoinAddress,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-onchain
}

const examplePrepareLiquidPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-receive-payment-liquid

  // Create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  // Note: Not setting the amount will generate a plain Liquid address
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.LiquidAddress,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-liquid
}

const exampleReceivePayment = async (sdk: BindingLiquidSdk, prepareResponse: PrepareReceiveResponse) => {
  // ANCHOR: receive-payment
  const optionalDescription = '<description>'
  const res = sdk.receivePayment({
    prepareResponse,
    description: optionalDescription,
    descriptionHash: undefined,
    payerNote: undefined
  })

  const destination = res.destination
  // ANCHOR_END: receive-payment
  console.log(destination)
}
