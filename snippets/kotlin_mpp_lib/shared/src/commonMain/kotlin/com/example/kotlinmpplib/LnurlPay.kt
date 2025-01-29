package com.example.kotlinmpplib

import breez_sdk_liquid.*
class LnurlPay {
    fun prepareLnurlPay(sdk: BindingLiquidSdk) {
        // ANCHOR: prepare-lnurl-pay
        // Endpoint can also be of the form:
        // lnurlp://domain.com/lnurl-pay?key=val
        // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
        val lnurlPayUrl = "lightning@address.com";
        try {
            val inputType = sdk.parse(lnurlPayUrl)
            if (inputType is InputType.LnUrlPay) {
                val amount = PayAmount.Bitcoin(5_000.toULong())
                val optionalComment = "<comment>";
                val optionalValidateSuccessActionUrl = true;
                val lnurlData = inputType.data

                val req = PrepareLnUrlPayRequest(
                    lnurlData, 
                    amount, 
                    optionalComment, 
                    optionalValidateSuccessActionUrl)
                val prepareResponse = sdk.prepareLnurlPay(req)

                // If the fees are acceptable, continue to create the LNURL Pay
                val feesSat = prepareResponse.feesSat;
                // Log.v("Breez", "Fees: ${feesSat} sats")
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-lnurl-pay
    }
    
    fun prepareLnurlPayDrain(sdk: BindingLiquidSdk, lnurlData LnUrlPayRequestData) {
        // ANCHOR: prepare-lnurl-pay-drain
        try {
            val amount = PayAmount.Drain
            val optionalComment = "<comment>";
            val optionalValidateSuccessActionUrl = true;
            val requestData = inputType.data

            val req = PrepareLnUrlPayRequest(
                lnurlData, 
                amount, 
                optionalComment, 
                optionalValidateSuccessActionUrl)
            val prepareResponse = sdk.prepareLnurlPay(req)
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: prepare-lnurl-pay-drain
    }
    
    fun lnurlPay(sdk: BindingLiquidSdk, prepareResponse: PrepareLnUrlPayResponse) {
        // ANCHOR: lnurl-pay
        try {
            val result = sdk.lnurlPay(LnUrlPayRequest(prepareResponse))
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: lnurl-pay
    }
}