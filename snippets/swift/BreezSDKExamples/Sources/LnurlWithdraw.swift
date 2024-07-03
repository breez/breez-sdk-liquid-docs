import BreezLiquidSDK
import Foundation

func withdraw(sdk: BlockingBreezServices) -> LnUrlWithdrawResult? {
    // ANCHOR: lnurl-withdraw
    // Endpoint can also be of the form:
    // lnurlw://domain.com/lnurl-withdraw?key=val
    var response: LnUrlWithdrawResult?
    let lnurlWithdrawUrl = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk"

    if let inputType = try? parseInput(s: lnurlWithdrawUrl) {
        if case let .lnUrlWithdraw(data) = inputType {
            let amountMsat = data.maxWithdrawable
            let description = "Test withdraw"
            response = try? sdk.withdrawLnurl(
                request: LnUrlWithdrawRequest(
                    data: data,
                    amountMsat: amountMsat,
                    description: description
                )
            )
        }
    }
    // ANCHOR_END: lnurl-withdraw
    return response
}
