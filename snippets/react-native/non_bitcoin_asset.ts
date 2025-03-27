import {
  defaultConfig,
  getInfo,
  LiquidNetwork,
  PaymentMethod,
  type PayAmount,
  PayAmountVariant,
  prepareSendPayment,
  prepareReceivePayment,
  type ReceiveAmount,
  ReceiveAmountVariant
} from '@breeztech/react-native-breez-sdk-liquid'

const examplePrepareAssetPayment = async () => {
  // ANCHOR: prepare-receive-payment-asset

  // Create a Liquid BIP21 URI/address to receive an asset payment to.
  // Note: Not setting the amount will generate an amountless BIP21 URI.
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount: ReceiveAmount = {
    type: ReceiveAmountVariant.ASSET,
    assetId: usdtAssetId,
    payerAmount: 1.50
  }

  const prepareResponse = await prepareReceivePayment({
    paymentMethod: PaymentMethod.LIQUID_ADDRESS,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-asset
}

const examplePrepareSendPaymentAsset = async () => {
  // ANCHOR: prepare-send-payment-asset
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const destination = '<Liquid BIP21 or address>'
  // If the destination is an address or an amountless BIP21 URI,
  // you must specify an asset amount

  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount: PayAmount = {
    type: PayAmountVariant.ASSET,
    assetId: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: false
  }

  const prepareResponse = await prepareSendPayment({
    destination,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-asset
}

const examplePrepareSendPaymentAssetFees = async () => {
  // ANCHOR: prepare-send-payment-asset-fees
  const destination = '<Liquid BIP21 or address>'
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  // Set the optional estimate asset fees param to true
  const optionalAmount: PayAmount = {
    type: PayAmountVariant.ASSET,
    assetId: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: true
  }

  const prepareResponse = await prepareSendPayment({
    destination,
    amount: optionalAmount
  })

  // If the asset fees are set, you can use these fees to pay to send the asset
  const sendAssetFees = prepareResponse.estimatedAssetFees
  console.log(`Estimated Fees: ~${sendAssetFees}`)

  // If the asset fess are not set, you can use the sats fees to pay to send the asset
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-asset-fees
}

const exampleSendPaymentFees = async (prepareResponse: PrepareSendResponse) => {
  // ANCHOR: send-payment-fees
  // Set the use asset fees param to true
  const sendResponse = await sendPayment({
    prepareResponse,
    useAssetFees: true
  })
  const payment = sendResponse.payment
  // ANCHOR_END: send-payment-fees
  console.log(payment)
}

const configureAssetMetadata = async () => {
  // ANCHOR: configure-asset-metadata
  // Create the default config
  const config = await defaultConfig(
    LiquidNetwork.MAINNET,
    '<your-Breez-API-key>'
  )

  // Configure asset metadata. Setting the optional fiat ID will enable
  // paying fees using the asset (if available).
  config.assetMetadata = [
    {
      assetId: '18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec',
      name: 'PEGx EUR',
      ticker: 'EURx',
      precision: 8,
      fiatId: 'EUR'
    }
  ]
  // ANCHOR_END: configure-asset-metadata
}

const exampleFetchAssetBalance = async () => {
  // ANCHOR: fetch-asset-balance
  const info = await getInfo()
  const assetBalances = info.walletInfo.assetBalances
  // ANCHOR_END: fetch-asset-balance
}
