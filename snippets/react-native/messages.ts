import {
  checkMessage,
  getInfo,
  signMessage
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleSignMessage = async () => {
  // ANCHOR: sign-message
  const signMessageResponse = await signMessage({
    message: '<message to sign>'
  })

  // Get the wallet info for your pubkey
  const info = await getInfo()

  const signature = signMessageResponse.signature
  const pubkey = info.walletInfo.pubkey

  console.log(`Pubkey: ${pubkey}`)
  console.log(`Signature: ${signature}`)
  // ANCHOR_END: sign-message
}

const exampleCheckMessage = async () => {
  // ANCHOR: check-message
  const checkMessageResponse = await checkMessage({
    message: '<message>',
    pubkey: '<pubkey of signer>',
    signature: '<message signature>'
  })
  const isValid = checkMessageResponse.isValid

  console.log(`Signature valid: ${isValid}`)
  // ANCHOR_END: check-message
}
