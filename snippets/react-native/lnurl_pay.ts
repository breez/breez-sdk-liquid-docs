import {
  InputTypeVariant,
  lnurlPay,
  type LnUrlPayRequestData,
  parse,
  type PayAmount,
  PayAmountVariant,
  prepareLnurlPay,
  type PrepareLnUrlPayResponse
} from '@breeztech/react-native-breez-sdk-liquid'

const examplePrepareLnurlPay = async () => {
  // ANCHOR: prepare-lnurl-pay
  // Endpoint can also be of the
  // lnurlp://domain.com/lnurl-pay?key=val
  // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
  const lnurlPayUrl = 'lightning@address.com'

  const input = await parse(lnurlPayUrl)
  if (input.type === InputTypeVariant.LN_URL_PAY) {
    const amount: PayAmount = {
      type: PayAmountVariant.BITCOIN,
      receiverAmountSat: 5_000
    }
    const optionalComment = '<comment>'
    const optionalValidateSuccessActionUrl = true

    const prepareResponse = await prepareLnurlPay({
      data: input.data,
      amount,
      bip353Address: input.bip353Address,
      comment: optionalComment,
      validateSuccessActionUrl: optionalValidateSuccessActionUrl
    })

    // If the fees are acceptable, continue to create the LNURL Pay
    const feesSat = prepareResponse.feesSat
    console.log(`Fees: ${feesSat} sats`)
  }
  // ANCHOR_END: prepare-lnurl-pay
}

const examplePrepareLnurlPayDrain = async (data: LnUrlPayRequestData) => {
  // ANCHOR: prepare-lnurl-pay-drain
  const amount: PayAmount = {
    type: PayAmountVariant.DRAIN
  }
  const optionalComment = '<comment>'
  const optionalValidateSuccessActionUrl = true

  const prepareResponse = await prepareLnurlPay({
    data,
    amount,
    comment: optionalComment,
    validateSuccessActionUrl: optionalValidateSuccessActionUrl
  })
  // ANCHOR_END: prepare-lnurl-pay-drain
}

const exampleLnurlPay = async (prepareResponse: PrepareLnUrlPayResponse) => {
  // ANCHOR: lnurl-pay
  const result = await lnurlPay({
    prepareResponse
  })
  // ANCHOR_END: lnurl-pay
  console.log(result)
}
