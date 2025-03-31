import { defaultConfig, connect, type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'

const parseInputs = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: parse-inputs
  const input = 'an input to be parsed...'

  const parsed = await sdk.parse(input)

  switch (parsed.type) {
    case 'bitcoinAddress':
      console.log(`Input is Bitcoin address ${parsed.address.address}`)
      break

    case 'bolt11':
      console.log(
        `Input is BOLT11 invoice for ${
          parsed.invoice.amountMsat != null ? parsed.invoice.amountMsat.toString() : 'unknown'
        } msats`
      )
      break

    case 'lnUrlPay':
      console.log(
        `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.data.minSendable}/${
          parsed.data.maxSendable
        } msats - BIP353 was used: ${parsed.bip353Address != null}`
      )
      break

    case 'lnUrlWithdraw':
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

const configureParsers = async () => {
  // ANCHOR: configure-external-parser
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  // Configure external parsers
  config.externalInputParsers = [
    {
      providerId: 'provider_a',
      inputRegex: '^provider_a',
      parserUrl: 'https://parser-domain.com/parser?input=<input>'
    },
    {
      providerId: 'provider_b',
      inputRegex: '^provider_b',
      parserUrl: 'https://parser-domain.com/parser?input=<input>'
    }
  ]

  await connect({ mnemonic, config })
  // ANCHOR_END: configure-external-parser
}
