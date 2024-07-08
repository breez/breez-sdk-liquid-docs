package com.example.kotlinmpplib

import breez_liquid_sdk.*
class LnurlPay {
    fun lnurlPay(sdk: BindingLiquidSdk) {
        // ANCHOR: lnurl-pay
        // Endpoint can also be of the form:
        // lnurlp://domain.com/lnurl-pay?key=val
        // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
        val lnurlPayUrl = "lightning@address.com";
        try {
            val inputType = parse(lnurlPayUrl)
            if (inputType is InputType.LnUrlPay) {
                val requestData = inputType.data
                val amountMsat = requestData.minSendable
                val optionalComment = "<comment>";
                val optionalPaymentLabel = "<label>";
                val req = LnUrlPayRequest(requestData, amountMsat, optionalComment, optionalPaymentLabel)
                sdk.lnurlPay(req)
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: lnurl-pay
    }
}