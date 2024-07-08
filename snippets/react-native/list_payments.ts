import {
  listPayments
} from '@breeztech/react-native-breez-liquid-sdk'

const exampleListPayments = async () => {
  // ANCHOR: list-payments
  const payments = await listPayments()
  // ANCHOR_END: list-payments
}
