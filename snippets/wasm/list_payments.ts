import { type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'

const exampleGetPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: get-payment
  const paymentHash = '<payment hash>'
  const paymentByHash = await sdk.getPayment({
    type: 'paymentHash',
    paymentHash
  })

  const swapId = '<swap id>'
  const paymentBySwapId = await sdk.getPayment({
    type: 'swapId',
    swapId
  })
  // ANCHOR_END: get-payment
}

const exampleListPayments = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments
  const payments = await sdk.listPayments({})
  // ANCHOR_END: list-payments
}

const exampleListPaymentsFiltered = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-filtered
  try {
    const payments = await sdk.listPayments({
      filters: ['send'],
      fromTimestamp: 1696880000,
      toTimestamp: 1696959200,
      offset: 0,
      limit: 50
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-filtered
}

const exampleListPaymentsDetailsAddress = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-details-address
  try {
    const payments = await sdk.listPayments({
      details: {
        type: 'bitcoin',
        address: '<Bitcoin address>'
      }
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-address
}

const exampleListPaymentsDetailsDestination = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-details-destination
  try {
    const payments = await sdk.listPayments({
      details: {
        type: 'liquid',
        destination: '<Liquid BIP21 or address>'
      }
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-destination
}
