import {
  InputTypeVariant,
  parse,
} from '@breeztech/react-native-breez-sdk-liquid'

const parseInputs = async () => {
  // ANCHOR: parse-inputs
  const input = 'an input to be parsed...'

  const parsed = await parse(input)
  
  switch (parsed.type) {
    case InputTypeVariant.BITCOIN_ADDRESS:
      console.log(`Input is Bitcoin address ${parsed.address.address}`)
      break
      
    case InputTypeVariant.BOLT11:
      console.log(
        `Input is BOLT11 invoice for ${
          parsed.invoice.amountMsat 
            ? parsed.invoice.amountMsat.toString() 
            : 'unknown'
        } msats`
      )
      break
      
    case InputTypeVariant.LN_URL_PAY:
      console.log(
        `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.data.minSendable}/${parsed.data.maxSendable} msats`
      )
      break
      
    case InputTypeVariant.LN_URL_WITHDRAW:
      console.log(
        `Input is LNURL-Withdraw for min/max ${parsed.data.minWithdrawable}/${parsed.data.maxWithdrawable} msats`
      )
      break
      
    default:
      // Other input types are available
      break
  }
  // ANCHOR_END: parse-inputs
}
