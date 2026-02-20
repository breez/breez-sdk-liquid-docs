# About Breez SDK - Liquid

## **Overview**

The Breez SDK provides developers with an end-to-end solution for integrating instant, self-custodial bitcoin into their apps and services. It eliminates the need for third parties, simplifies the complexities of Bitcoin and Lightning, and enables seamless onboarding for billions of users to the future of value transfer.

To provide the best experience for their end-users, developers can choose between the following implementations:

- [Breez SDK - Spark](https://sdk-doc-spark.breez.technology/)
- [Breez SDK - Liquid](https://sdk-doc-liquid.breez.technology/)


## **What is the Breez SDK - Liquid?**

It’s a nodeless integration that offers a self-custodial, end-to-end solution for integrating bitcoin, utilizing the Liquid Network & Lightning, with on-chain interoperability and third-party fiat on-ramps. Using the SDK you'll be able to:

- **Send payments** via various protocols such as: Bolt11, Bolt12, BIP353, LNURL-Pay, Lightning address, BTC address
- **Receive payments** via various protocols such as: Bolt11, Bolt12, BIP353, LNURL-Withdraw, LNURL-Pay, Lightning address, BTC address
  
**Key Features**

- [x] Send and receive Lightning payments 
- [x] Send and receive on-chain transactions 
- [x] Complete LNURL & BOLT12 functionality
- [x] USDT and multi-asset support on Liquid
- [x] Lightning address & BIP353 support 
- [x] Multi-app support
- [x] Multi-device support
- [x] Real-time state backup
- [x] WebAssembly support 
- [x] Keys are only held by users
- [x] Built-in fiat on-ramp
- [x] Free open-source solution


## How does the Breez SDK - Liquid work?

The Breez SDK - Liquid uses submarine swaps and reverse submarine swaps to send and receive payments, enabling funds to move frictionlessly between the Lightning Network and the Liquid sidechain.

![Breez SDK - Liquid](../images/BreezSDK_Liquid.png)

When sending a payment the SDK performs a submarine swap, converting L-BTC from a user’s Liquid wallet into sats on the Lightning Network, and sends them to the recipient. 

When receiving a payment, the SDK performs a reverse submarine swap, converting incoming sats into L-BTC, and then deposits them in the user’s Liquid wallet.


## Pricing

The Breez SDK is **free** for developers. 
See [here](https://sdk-doc-liquid.breez.technology/guide/end-user_fees.html) for end-user fees.


## Support

Have a question for the team? Join us on [Telegram](https://t.me/breezsdk) or email us at <contact@breez.technology>.


## Repository

Head over to the [Breez SDK - Liquid repo](https://github.com/breez/breez-sdk-liquid).


## Next Steps
Follow our step-by-step guide to add the Breez SDK to your app.

**→ [Getting Started](https://sdk-doc-liquid.breez.technology/guide/getting_started.html)** 


