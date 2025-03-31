import {
  defaultConfig,
  type PayAmount,
  type ReceiveAmount,
  type BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid'

const examplePrepareAssetPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-receive-payment-asset

  // Create a Liquid BIP21 URI/address to receive an asset payment to.
  // Note: Not setting the amount will generate an amountless BIP21 URI.
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount: ReceiveAmount = {
    type: 'asset',
    assetId: usdtAssetId,
    payerAmount: 1.5
  }

  const prepareResponse = await sdk.prepareReceivePayment({
    paymentMethod: 'liquidAddress',
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  // ANCHOR_END: prepare-receive-payment-asset
}

const examplePrepareSendPaymentAsset = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-send-payment-asset
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const destination = '<Liquid BIP21 or address>'
  // If the destination is an address or an amountless BIP21 URI,
  // you must specifiy an asset amount

  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount: PayAmount = {
    type: 'asset',
    assetId: usdtAssetId,
    receiverAmount: 1.5
  }

  const prepareResponse = await sdk.prepareSendPayment({
    destination,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  // ANCHOR_END: prepare-send-payment-asset
}

const configureAssetMetadata = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: configure-asset-metadata
  // Create the default config
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  // Configure asset metadata
  config.assetMetadata = [
    {
      assetId: '18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec',
      name: 'PEGx EUR',
      ticker: 'EURx',
      precision: 8
    }
  ]
  // ANCHOR_END: configure-asset-metadata
}

const exampleFetchAssetBalance = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: fetch-asset-balance
  const info = await sdk.getInfo()
  const assetBalances = info.walletInfo.assetBalances
  // ANCHOR_END: fetch-asset-balance
}
