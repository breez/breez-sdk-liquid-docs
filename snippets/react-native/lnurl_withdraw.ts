import {
  type BindingLiquidSdk,
  InputType_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const exampleLnurlWithdraw = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: lnurl-withdraw
  // Endpoint can also be of the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  const lnurlWithdrawUrl =
    'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk'

  const input = sdk.parse(lnurlWithdrawUrl)
  if (input.tag === InputType_Tags.LnUrlWithdraw) {
    const amountMsat = input.inner.data.minWithdrawable
    const lnUrlWithdrawResult = sdk.lnurlWithdraw({
      data: input.inner.data,
      amountMsat,
      description: 'comment'
    })
  }
  // ANCHOR_END: lnurl-withdraw
}
