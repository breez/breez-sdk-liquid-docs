import {
  listPayments
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleListPayments = async () => {
  // ANCHOR: list-payments
  const payments = await listPayments()
  // ANCHOR_END: list-payments
}
