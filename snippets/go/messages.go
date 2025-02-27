package example

import (
	"log"

	"github.com/breez/breez-sdk-liquid-go/breez_sdk_liquid"
)

func SignMessage(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: sign-message
	message := "<message to sign>"

	signMessageRequest := breez_sdk_liquid.SignMessageRequest{
		Message: message,
	}

	signMessageResponse, err := sdk.SignMessage(signMessageRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	// Get the wallet info for your pubkey
	info, err := sdk.GetInfo()
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	signature := signMessageResponse.Signature
	pubkey := info.WalletInfo.Pubkey

	log.Printf("Pubkey: %v", pubkey)
	log.Printf("Signature: %v", signature)
	// ANCHOR_END: sign-message
}

func CheckMessage(sdk *breez_sdk_liquid.BindingLiquidSdk) {
	// ANCHOR: check-message
	message := "<message>"
	pubkey := "<pubkey of signer>"
	signature := "<message signature>"

	checkMessageRequest := breez_sdk_liquid.CheckMessageRequest{
		Message:   message,
		Pubkey:    pubkey,
		Signature: signature,
	}

	checkMessageResponse, err := sdk.CheckMessage(checkMessageRequest)
	if err != nil {
		log.Printf("Error: %#v", err)
		return
	}

	isValid := checkMessageResponse.IsValid

	log.Printf("Signature valid: %v", isValid)
	// ANCHOR_END: check-message
}
