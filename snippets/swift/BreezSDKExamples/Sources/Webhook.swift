//
//  ServiceStatus.swift
//  
//
//

import Foundation
import BreezSDKLiquid

func registerWebhook(sdk: BindingLiquidSdk) throws {
    // ANCHOR: register-webook
    try sdk.registerWebhook(webhookUrl: "https://your-nds-service.com/notify?platform=ios&token=<PUSH_TOKEN>")  
    // ANCHOR_END: register-webook
}

func unregisterWebhook(sdk: BindingLiquidSdk) throws {
    // ANCHOR: unregister-webook
    try sdk.unregisterWebhook()  
    // ANCHOR_END: unregister-webook
}
