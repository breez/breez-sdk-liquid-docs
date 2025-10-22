import {
  getInfo,
  PaymentMethod,
  type PayAmount,
  PayAmountVariant,
  prepareReceivePayment,
  receivePayment,
  prepareSendPayment,
  type PrepareSendResponse,
  type ReceiveAmount,
  ReceiveAmountVariant,
  sendPayment
} from '@breeztech/breez-sdk-liquid-react-native'

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
    toAsset: usdtAssetId,
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
    toAsset: usdtAssetId,
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

const exampleFetchAssetBalance = async () => {
  // ANCHOR: fetch-asset-balance
  const info = await getInfo()
  const assetBalances = info.walletInfo.assetBalances
  // ANCHOR_END: fetch-asset-balance
}

const exampleSendSelfPaymentAsset = async () => {
  // ANCHOR: send-self-payment-asset
  // Create a Liquid address to receive to
  const prepareReceiveRes = await prepareReceivePayment({
    paymentMethod: PaymentMethod.LIQUID_ADDRESS,
    amount: undefined
  })
  const receiveRes = await receivePayment({
    prepareResponse: prepareReceiveRes,
    description: undefined,
    useDescriptionHash: undefined,
    payerNote: undefined
  })

  // Swap your funds to the address we've created
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const btcAssetId = '6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d'
  const prepareSendRes = await prepareSendPayment({
    destination: receiveRes.destination,
    amount: {
      type: PayAmountVariant.ASSET,
      toAsset: usdtAssetId,
      // We want to receive 1.5 USDt
      receiverAmount: 1.5,
      fromAsset: btcAssetId
    }
  })
  const sendRes = await sendPayment({
    prepareResponse: prepareSendRes,
    useAssetFees: undefined
  })
  const payment = sendRes.payment
  // ANCHOR_END: send-self-payment-asset
  console.log(payment)
}
