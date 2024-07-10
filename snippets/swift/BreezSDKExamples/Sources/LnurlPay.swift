import BreezSDKLiquid
import Foundation

func pay(sdk: BindingLiquidSdk) -> LnUrlPayResult? {
    // ANCHOR: lnurl-pay
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    var response: LnUrlPayResult?
    let lnurlPayUrl = "lightning@address.com"
    if let inputType = try? parse(input: lnurlPayUrl) {
        if case.lnUrlPay(let `data`) = inputType {
            let amountMSat = data.minSendable
            response = try? sdk.lnurlPay(req: LnUrlPayRequest(
                data: data,
                amountMsat: amountMSat,
                comment: "comment",
                paymentLabel: "label"))
        }
    }
    // ANCHOR_END: lnurl-pay
    return response
}