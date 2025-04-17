import { type BindingLiquidSdk, connectWithSigner, defaultConfig } from '@breeztech/breez-sdk-liquid'

const exmapleConnectWithSigner = async (): Promise<BindingLiquidSdk> => {
  // ANCHOR: self-signer
  // Fully implement the Signer interface
  class JsSigner {
    xpub = (): number[] => { return [] }
    deriveXpub = (derivationPath: string): number[] => { return [] }
    signEcdsa = (msg: number[], derivationPath: string): number[] => { return [] }
    signEcdsaRecoverable = (msg: number[]): number[] => { return [] }
    slip77MasterBlindingKey = (): number[] => { return [] }
    hmacSha256 = (msg: number[], derivationPath: string): number[] => { return [] }
    eciesEncrypt = (msg: number[]): number[] => { return [] }
    eciesDecrypt = (msg: number[]): number[] => { return [] }
  }

  const signer = new JsSigner()

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>')

  const sdk = await connectWithSigner({ config }, signer)

  return sdk
  // ANCHOR_END: self-signer
}
