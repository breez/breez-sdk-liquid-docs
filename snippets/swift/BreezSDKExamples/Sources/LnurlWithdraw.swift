import BreezSDKLiquid
import Foundation

func withdraw(sdk: BindingLiquidSdk) -> LnUrlWithdrawResult? {
    // ANCHOR: lnurl-withdraw
    // Endpoint can also be of the form:
    // lnurlw://domain.com/lnurl-withdraw?key=val
    var response: LnUrlWithdrawResult?
    let lnurlWithdrawUrl = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk"

    if let inputType = try? sdk.parse(input: lnurlWithdrawUrl){
        if case.lnUrlWithdraw(let `data`) = inputType {
            let amountMsat = data.maxWithdrawable
            let description = "Test withdraw"
            response = try? sdk.lnurlWithdraw(req: LnUrlWithdrawRequest(
                data: data,
                amountMsat: amountMsat,
                description: description))
        }
    }
    // ANCHOR_END: lnurl-withdraw
    return response
}
