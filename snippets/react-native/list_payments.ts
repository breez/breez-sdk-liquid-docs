import {
  BindingLiquidSdk,
  GetPaymentRequest,
  ListPaymentDetails,
  PaymentType
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGetPayment = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: get-payment
  const paymentHash = '<payment hash>'
  const paymentByHash = sdk.getPayment(new GetPaymentRequest.PaymentHash({ paymentHash }))

  const swapId = '<swap id>'
  const paymentBySwapId = sdk.getPayment(new GetPaymentRequest.SwapId({ swapId }))
  // ANCHOR_END: get-payment
}

const exampleListPayments = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments
  const payments = sdk.listPayments({
    filters: undefined,
    states: undefined,
    fromTimestamp: undefined,
    toTimestamp: undefined,
    offset: undefined,
    limit: undefined,
    details: undefined,
    sortAscending: undefined
  })
  // ANCHOR_END: list-payments
}

const exampleListPaymentsFiltered = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-filtered
  try {
    const payments = sdk.listPayments({
      filters: [PaymentType.Send],
      fromTimestamp: BigInt(1696880000),
      toTimestamp: BigInt(1696959200),
      offset: 0,
      limit: 50,
      states: undefined,
      details: undefined,
      sortAscending: undefined
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-filtered
}

const exampleListPaymentsDetailsAddress = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-details-address
  try {
    const payments = sdk.listPayments({
      details: new ListPaymentDetails.Bitcoin({ address: '<Bitcoin address>' }),
      filters: undefined,
      states: undefined,
      fromTimestamp: undefined,
      toTimestamp: undefined,
      offset: undefined,
      limit: undefined,
      sortAscending: undefined
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-address
}

const exampleListPaymentsDetailsDestination = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: list-payments-details-destination
  try {
    const payments = sdk.listPayments({
      details: new ListPaymentDetails.Liquid({ assetId: undefined, destination: '<Liquid BIP21 or address>' }),
      filters: undefined,
      states: undefined,
      fromTimestamp: undefined,
      toTimestamp: undefined,
      offset: undefined,
      limit: undefined,
      sortAscending: undefined
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-destination
}
