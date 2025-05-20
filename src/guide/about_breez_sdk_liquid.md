# About Breez SDK - Nodeless *(Liquid Implementation)*

## **What Is the Breez SDK?**

The Breez SDK provides developers with an end-to-end solution for integrating self-custodial Lightning payments into their apps and services. It eliminates the need for third parties, simplifies the complexities of Bitcoin and Lightning, and enables seamless onboarding for billions of users to the future of peer-to-peer payments.

To provide the best experience for their end-users, developers can choose between the following implementations:

- [Breez SDK - Nodeless *(Liquid Implementation)*](https://sdk-doc-liquid.breez.technology/)
- [Breez SDK - Native *(Greenlight Implementation)*](https://sdk-doc.breez.technology/)


## **What Is the Breez SDK - Nodeless *(Liquid Implementation)*?**

It’s a nodeless integration that offers a self-custodial, end-to-end solution for integrating Lightning payments, utilizing the Liquid Network with on-chain interoperability and third-party fiat on-ramps. Using the SDK you will able to:
- **Send payments** via various protocols such as: Bolt11, Bolt12, BIP353, LNURL-Pay, Lightning address, BTC address
- **Receive payments** via various protocols such as: Bolt11, LNURL-Withdraw, LNURL-Pay, Lightning address, BTC address
  
**Key Features**

- [x] Send and receive Lightning payments 
- [x] On-chain interoperability
- [x] Complete LNURL & BOLT12 functionality
- [x] Multi-app support
- [x] Multi-device support
- [x] Real-time state backup
- [x] Keys are only held by users
- [x] USDT and multi-asset support on Liquid
- [x] Built-in fiat on-ramp
- [x] Free open-source solution


## How Does Nodeless *(Liquid Implementation)* Work?

The Breez SDK - Nodeless *(Liquid implementation)* uses submarine swaps and reverse submarine swaps to send and receive payments, enabling funds to move frictionlessly between the Lightning Network and the Liquid sidechain.

![Breez SDK - Liquid](../images/BreezSDK_Liquid.png)

When sending a payment the SDK performs a submarine swap, converting L-BTC from a user’s Liquid wallet into sats on the Lightning Network, and sends them to the recipient. 

When receiving a payment, the SDK performs a reverse submarine swap, converting incoming sats into L-BTC, and then deposits them in the user’s Liquid wallet.


## **Differences Between Implementations**

| Nodeless *(Liquid Implementation)* | Native *(Greenlight Implementation)* |
| --- | --- |
| Trust profile is with the Liquid sidechain | Pure Lightning Network implementation |
| No channel management or LSP required | Uses Lightning Service Providers (LSPs) for liquidity |
| No setup fees for end-users | Channel opening and closing fees |
| Minimum 100 sats to receive, 21 sats to send | No minimum limit for transactions (after channel opening) |
| Static low fees | Setup costs are correlated to Bitcoin mining fees |
| Bitcoin, USDT & multi-asset support | Bitcoin only |

## Pricing

The Breez SDK is **free** for developers. 
See [this](https://sdk-doc-liquid.breez.technology/guide/end-user_fees.html) for end-user fees.


## Support

Have a question for the team? Join us on [Telegram](https://t.me/breezsdk) or email us at <contact@breez.technology>.


## Repository

Head over to the [Breez SDK - Nodeless *(Liquid Implementation)* repo](https://github.com/breez/breez-sdk-liquid).


## Ready to Light Up Your App? 
**→ [Get Started](https://sdk-doc-liquid.breez.technology/guide/getting_started.html)** 


