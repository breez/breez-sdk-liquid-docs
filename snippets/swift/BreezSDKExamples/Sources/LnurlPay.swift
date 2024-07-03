import BindingLiquidSdk
import Foundation

func pay(sdk: BlockingBreezServices) -> LnUrlPayResult? {
    // ANCHOR: lnurl-pay
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    var response: LnUrlPayResult?
    let lnurlPayUrl = "lightning@address.com"
    if let inputType = try? parseInput(s: lnurlPayUrl) {
        if case let .lnUrlPay(data) = inputType {
            let amountMsat = data.minSendable
            let optionalComment = "<comment>"
            let optionalPaymentLabel = "<label>"
            let req = LnUrlPayRequest(data: data, amountMsat: amountMsat, comment: optionalComment, paymentLabel: optionalPaymentLabel)
            response = try? sdk.payLnurl(req: req)
        }
    }
    // ANCHOR_END: lnurl-pay
    return response
}
