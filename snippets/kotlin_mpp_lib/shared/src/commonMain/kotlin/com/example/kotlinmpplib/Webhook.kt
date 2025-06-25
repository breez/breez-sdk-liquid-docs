package com.example.kotlinmpplib

import breez_sdk_liquid.*
class Webhooks {
    fun registerWebhook(sdk: BindingLiquidSdk) {
        // ANCHOR: register-webook
        try {
            sdk.registerWebhook("https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>")
        } catch (e: Exception) {
            // Handle error
        }
        // ANCHOR_END: register-webook
    }

    fun unregisterWebhook(sdk: BindingLiquidSdk) {
        // ANCHOR: unregister-webook
        try {
            sdk.unregisterWebhook()
        } catch (e: Exception) {
            // Handle error
        }
        // ANCHOR_END: unregister-webook
    }
}