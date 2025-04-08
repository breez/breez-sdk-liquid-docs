import { type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'

const exampleLnurlAuth = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: lnurl-auth
  // Endpoint can also be of the form:
  // keyauth://domain.com/auth?key=val
  const lnurlAuthUrl =
    'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu'

  const input = await sdk.parse(lnurlAuthUrl)
  if (input.type === 'lnUrlAuth') {
    const result = await sdk.lnurlAuth(input.data)
    if (result.type === 'ok') {
      console.log('Successfully authenticated')
    } else {
      console.log('Failed to authenticate')
    }
  }
  // ANCHOR_END: lnurl-auth
}
