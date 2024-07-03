import {
  listPayments,
  PaymentTypeFilter
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleListPayments = async () => {
  // ANCHOR: list-payments
  const payments = listPayments({})
  // ANCHOR_END: list-payments
}
