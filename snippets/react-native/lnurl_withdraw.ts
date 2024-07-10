import {
  InputTypeVariant,
  parse,
  lnurlWithdraw
} from '@breeztech/react-native-breez-sdk-liquid'

const exampleLnurlWithdraw = async () => {
  // ANCHOR: lnurl-withdraw
  // Endpoint can also be of the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  const lnurlWithdrawUrl =
        'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk'

  const input = await parse(lnurlWithdrawUrl)
  if (input.type === InputTypeVariant.LN_URL_WITHDRAW) {
    const amountMsat = input.data.minWithdrawable
    const lnUrlWithdrawResult = await lnurlWithdraw({
      data: input.data,
      amountMsat,
      description: 'comment'
    })
  }
  // ANCHOR_END: lnurl-withdraw
}
