import { type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid-react-native'

const exampleSignMessage = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: sign-message
  const signMessageResponse = sdk.signMessage({
    message: '<message to sign>'
  })

  // Get the wallet info for your pubkey
  const info = sdk.getInfo()

  const signature = signMessageResponse.signature
  const pubkey = info.walletInfo.pubkey

  console.log(`Pubkey: ${pubkey}`)
  console.log(`Signature: ${signature}`)
  // ANCHOR_END: sign-message
}

const exampleCheckMessage = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: check-message
  const checkMessageResponse = sdk.checkMessage({
    message: '<message>',
    pubkey: '<pubkey of signer>',
    signature: '<message signature>'
  })
  const isValid = checkMessageResponse.isValid

  console.log(`Signature valid: ${isValid}`)
  // ANCHOR_END: check-message
}
