import {
  BindingLiquidSdk,
  InputType_Tags,
  LnUrlCallbackStatus_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleLnurlAuth = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: lnurl-auth
  // Endpoint can also be of the form:
  // keyauth://domain.com/auth?key=val
  const lnurlAuthUrl =
    'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu'

  const input = sdk.parse(lnurlAuthUrl)
  if (input.tag === InputType_Tags.LnUrlAuth) {
    const result = sdk.lnurlAuth(input.inner.data)
    if (result.tag === LnUrlCallbackStatus_Tags.Ok) {
      console.log('Successfully authenticated')
    } else {
      console.log('Failed to authenticate')
    }
  }
  // ANCHOR_END: lnurl-auth
}
