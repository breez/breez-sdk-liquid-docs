import {
  BindingLiquidSdk,
  InputType_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const parseInputs = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: parse-inputs
  const input = 'an input to be parsed...'

  const parsed = sdk.parse(input)

  switch (parsed.tag) {
    case InputType_Tags.BitcoinAddress:
      console.log(`Input is Bitcoin address ${parsed.inner.address.address}`)
      break

    case InputType_Tags.Bolt11:
      console.log(
        `Input is BOLT11 invoice for ${parsed.inner.invoice.amountMsat != null
          ? JSON.stringify(parsed.inner.invoice.amountMsat)
          : 'unknown'
        } msats`
      )
      break

    case InputType_Tags.Bolt12Offer:
      console.log(
        `Input is BOLT12 offer for min ${JSON.stringify(parsed.inner.offer.minAmount)} msats - BIP353 was used: ${parsed.inner.bip353Address != null}`
      )
      break

    case InputType_Tags.LnUrlPay:
      console.log(
        `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.inner.data.minSendable}/${parsed.inner.data.maxSendable} msats - BIP353 was used: ${parsed.inner.bip353Address != null}`
      )
      break

    case InputType_Tags.LnUrlWithdraw:
      console.log(
        `Input is LNURL-Withdraw for min/max ${parsed.inner.data.minWithdrawable}/${parsed.inner.data.maxWithdrawable} msats`
      )
      break

    default:
      // Other input types are available
      break
  }
  // ANCHOR_END: parse-inputs
}
