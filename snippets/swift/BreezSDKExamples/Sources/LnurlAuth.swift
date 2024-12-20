import BreezSDKLiquid
import Foundation

func auth(sdk: BindingLiquidSdk) {
    // ANCHOR: lnurl-withdraw
    // Endpoint can also be of the form:
    // keyauth://domain.com/auth?key=val
    let lnurlAuthUrl = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu"

    if let inputType = try? sdk.parse(input: lnurlAuthUrl) {
        if case .lnUrlAuth(let `data`) = inputType {
            let result = try? sdk.lnurlAuth(reqData: data)
            switch result {
            case .ok:
                print("Successfully authenticated")
            case .errorStatus(let error):
                print("Failed to authenticate: \(error)")
            case .none:
                print("Failed to authenticate")
            }
        }
    }
    // ANCHOR_END: lnurl-withdraw
}
