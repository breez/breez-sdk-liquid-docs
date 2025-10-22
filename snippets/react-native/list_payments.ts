import {
  getPayment,
  GetPaymentRequestVariant,
  ListPaymentDetailsVariant,
  listPayments,
  PaymentType
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleGetPayment = async () => {
  // ANCHOR: get-payment
  const paymentHash = '<payment hash>'
  const paymentByHash = await getPayment({
    type: GetPaymentRequestVariant.PAYMENT_HASH,
    paymentHash
  })

  const swapId = '<swap id>'
  const paymentBySwapId = await getPayment({
    type: GetPaymentRequestVariant.SWAP_ID,
    swapId
  })
  // ANCHOR_END: get-payment
}

const exampleListPayments = async () => {
  // ANCHOR: list-payments
  const payments = await listPayments({})
  // ANCHOR_END: list-payments
}

const exampleListPaymentsFiltered = async () => {
  // ANCHOR: list-payments-filtered
  try {
    const payments = await listPayments({
      filters: [PaymentType.SEND],
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

const exampleListPaymentsDetailsAddress = async () => {
  // ANCHOR: list-payments-details-address
  try {
    const payments = await listPayments({
      details: {
        type: ListPaymentDetailsVariant.BITCOIN,
        address: '<Bitcoin address>'
      }
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-address
}

const exampleListPaymentsDetailsDestination = async () => {
  // ANCHOR: list-payments-details-destination
  try {
    const payments = await listPayments({
      details: {
        type: ListPaymentDetailsVariant.LIQUID,
        destination: '<Liquid BIP21 or address>'
      }
    })
  } catch (err) {
    console.error(err)
  }
  // ANCHOR_END: list-payments-details-destination
}
