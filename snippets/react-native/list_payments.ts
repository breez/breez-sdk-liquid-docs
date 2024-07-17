import {
  listPayments,
  PaymentType
} from '@breeztech/react-native-breez-sdk-liquid'

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
