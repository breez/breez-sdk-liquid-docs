import {
  type BindingLiquidSdk,
  type LnUrlPayRequestData,
  type PayAmount,
  type PrepareLnUrlPayResponse
} from '@breeztech/breez-sdk-liquid'

const examplePrepareLnurlPay = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: prepare-lnurl-pay
  // Endpoint can also be of the
  // lnurlp://domain.com/lnurl-pay?key=val
  // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
  const lnurlPayUrl = 'lightning@address.com'

  const input = await sdk.parse(lnurlPayUrl)
  if (input.type === 'lnUrlPay') {
    const amount: PayAmount = {
      type: 'bitcoin',
      receiverAmountSat: 5_000
    }
    const optionalComment = '<comment>'
    const optionalValidateSuccessActionUrl = true

    const prepareResponse = await sdk.prepareLnurlPay({
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

const examplePrepareLnurlPayDrain = async (sdk: BindingLiquidSdk, data: LnUrlPayRequestData) => {
  // ANCHOR: prepare-lnurl-pay-drain
  const amount: PayAmount = {
    type: 'drain'
  }
  const optionalComment = '<comment>'
  const optionalValidateSuccessActionUrl = true

  const prepareResponse = await sdk.prepareLnurlPay({
    data,
    amount,
    comment: optionalComment,
    validateSuccessActionUrl: optionalValidateSuccessActionUrl
  })
  // ANCHOR_END: prepare-lnurl-pay-drain
}

const exampleLnurlPay = async (sdk: BindingLiquidSdk, prepareResponse: PrepareLnUrlPayResponse) => {
  // ANCHOR: lnurl-pay
  const result = await sdk.lnurlPay({
    prepareResponse
  })
  // ANCHOR_END: lnurl-pay
  console.log(result)
}
