# Receiving payments using LNURL-Pay, Lightning and BIP353 addresses

Breez SDK - Nodeless *(Liquid Implementation)* users have the ability to receive Lightning payments using [LNURL-Pay](https://github.com/lnurl/luds/blob/luds/06.md) and [BOLT12 offers](receive_payment.html#bolt12-offer).

Whether or not you are able to use a webhook URL to receive payment events will determine if you want to register for LNURL-Pay. If you have no way to receive webhook events, you can still register a BOLT12 Offer as a BIP353 DNS record. In this case the SDK needs to remain online to receive the BOLT12 invoice requests.

- **[LNURL-Pay and BIP353 registration](lnurl_pay_service.md)** using a webhook URL and BOLT12 Offer
- **[BIP353 registration](bip353_pay_service.md)** using a BOLT12 Offer

## Reference implementation
For a complete reference implementation, see:
* [Breez's NotificationService](https://github.com/breez/misty-breez/blob/main/ios/NotificationService/NotificationService.swift)
* [Breez's LNURL-Pay service](https://github.com/breez/breez-lnurl)
