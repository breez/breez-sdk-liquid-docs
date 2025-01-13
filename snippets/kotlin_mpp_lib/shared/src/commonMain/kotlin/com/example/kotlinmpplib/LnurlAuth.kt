package com.example.kotlinmpplib

import breez_sdk_liquid.*
class LnurlAuth {
    fun lnurlAuth(sdk: BindingLiquidSdk) {
        // ANCHOR: lnurl-auth
        // Endpoint can also be of the form:
        // keyauth://domain.com/auth?key=val
        val lnurlAuthUrl = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7..."
        try {
            val inputType = sdk.parse(lnurlAuthUrl)
            if (inputType is InputType.LnUrlAuth) {
                when (val result = sdk.lnurlAuth(inputType.data)) {
                    is LnUrlCallbackStatus.Ok -> {} // Log.v("Breez", "Successfully authenticated")
                    is LnUrlCallbackStatus.ErrorStatus -> {} // Log.v("Breez", "Failed to authenticate: ${result.data.reason}")
                }
            }
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: lnurl-auth
    }
}
