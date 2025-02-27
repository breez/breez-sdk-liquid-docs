package com.example.kotlinmpplib

import breez_sdk_liquid.*

class Messages {
    fun signMessage(sdk: BindingLiquidSdk) {
        // ANCHOR: sign-message
        val message = "<message to sign>"
        try {
            val signMessageResponse = sdk.signMessage(SignMessageRequest(message))

            // Get the wallet info for your pubkey
            val info = sdk.getInfo()

            val signature = signMessageResponse?.signature
            val pubkey = info?.walletInfo?.pubkey

            // Log.v("Breez", "Pubkey: ${pubkey}")
            // Log.v("Breez", "Signature: ${signature}")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: sign-message
    }

    fun checkMessage(sdk: BindingLiquidSdk) {
        // ANCHOR: check-message
        val message = "<message>"
        val pubkey = "<pubkey of signer>"
        val signature = "<message signature>"
        try {
            val checkMessageRequest = CheckMessageRequest(message, pubkey, signature)
            val checkMessageResponse = sdk.checkMessage(checkMessageRequest)

            val isValid = checkMessageResponse?.isValid

            // Log.v("Breez", "Signature valid: ${isValid}")
        } catch (e: Exception) {
            // handle error
        }
        // ANCHOR_END: check-message
    }

}
