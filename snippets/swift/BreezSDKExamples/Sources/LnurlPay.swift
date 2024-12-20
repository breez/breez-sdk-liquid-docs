import BreezSDKLiquid
import Foundation

func preparePay(sdk: BindingLiquidSdk) -> LnUrlPayResult? {
    // ANCHOR: prepare-lnurl-pay
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    var response: LnUrlPayResult?
    let lnurlPayUrl = "lightning@address.com"
    if let inputType = try? sdk.parse(input: lnurlPayUrl) {
        if case.lnUrlPay(let `data`) = inputType {
            let amountMsat = data.minSendable
            let optionalComment = "<comment>"
            let optionalValidateSuccessActionUrl = true

            let req = PrepareLnUrlPayRequest(
                data: data, 
                amountMsat: amountMsat, 
                comment: optionalComment, 
                validateSuccessActionUrl: optionalValidateSuccessActionUrl
            )
            let prepareResponse = try? sdk.prepareLnurlPay(req: req)
                
            // If the fees are acceptable, continue to create the LNURL Pay
            let feesSat = prepareResponse!.feesSat
            print("Fees: {} sats", feesSat);
        }
    }
    // ANCHOR_END: prepare-lnurl-pay
    return response
}

func pay(sdk: BindingLiquidSdk, prepareResponse: PrepareLnUrlPayResponse) -> LnUrlPayResult? {
    // ANCHOR: lnurl-pay
    let result = try? sdk.lnurlPay(req: LnUrlPayRequest (
        prepareResponse: prepareResponse
    ))
    // ANCHOR_END: lnurl-pay
    return result
}
