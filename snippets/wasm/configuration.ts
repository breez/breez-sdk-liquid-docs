import {
  defaultConfig,
  type PayAmount,
  type PrepareSendResponse,
  type ReceiveAmount,
  type BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid'

const configureAssetMetadata = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: configure-asset-metadata
  // Create the default config
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  // Configure asset metadata
  config.assetMetadata = [
    {
      assetId: '18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec',
      name: 'PEGx EUR',
      ticker: 'EURx',
      precision: 8
    }
  ]
  // ANCHOR_END: configure-asset-metadata
}

const configureParsers = async () => {
  // ANCHOR: configure-external-parser
  // Create the default config
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
  // ANCHOR_END: configure-external-parser
}

const configureMagicRoutingHints = async () => {
  // ANCHOR: configure-magic-routing-hints
  // Create the default config
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  // Configure magic routing hints
  config.useMagicRoutingHints = false
  // ANCHOR_END: configure-magic-routing-hints
}
