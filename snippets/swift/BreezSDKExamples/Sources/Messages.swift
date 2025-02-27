import BreezSDKLiquid

func signMessage(sdk: BindingLiquidSdk) -> SignMessageResponse? {
    // ANCHOR: sign-message
    let signMessageRequest = try? sdk
        .signMessage(req: SignMessageRequest(
            message: "<message to sign>"
        ))

    // Get the wallet info for your pubkey
    let info = try? sdk.getInfo()

    let signature = signMessageRequest!.signature
    let pubkey = info!.walletInfo.pubkey

    print("Pubkey: {}", pubkey);
    print("Signature: {}", signature);
    // ANCHOR_END: sign-message
    return signMessageRequest
}

func checkMessage(sdk: BindingLiquidSdk) -> CheckMessageResponse? {
    // ANCHOR: check-message
    let checkMessageRequest = try? sdk
        .checkMessage(req: CheckMessageRequest(
            message: "<message>",
            pubkey: "<pubkey of signer>",
            signature: "<message signature>"
        ))

    let isValid = checkMessageRequest!.isValid

    print("Signature valid: {}", isValid);
    // ANCHOR_END: check-message
    return checkMessageRequest
}
