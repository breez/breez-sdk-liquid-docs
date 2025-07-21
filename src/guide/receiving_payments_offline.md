# Receiving payments offline

With Breez SDK - Nodeless *(Liquid Implementation)*, you can set up your application to receive payments even when it's not actively running. This is particularly useful for applications that need to accept payments in the background without requiring constant user interaction.

## Offline payment methods

There are two main technologies for receiving payments offline with Breez SDK:

- **LNURL-pay** - A static Lightning payment identifier that can be reused
- **BOLT12 offers** - A newer Lightning Network standard for reusable payment offers

Both methods require:
- Setting up a service to handle webhook requests
- Registering a webhook URL with the SDK

If you are serving a mobile application you will also require:
- Integrating the Notification Plugin

## Setting up for offline payments

### Setup a service to handle webhook requests

To receive payments offline, you need to set up a web service that can handle webhook requests when your application isn't actively running. This service acts as a bridge between the Lightning Network and your application, ensuring that payment requests are properly processed. 

It **must** be a publicly accessible endpoint that can receive HTTP POST requests. 

For mobile applications a Notification Delivery Service (NDS) can be used that acts as an intermediary between the webhook requests and your application. When a webhook request comes in, the NDS dispatches a push notification to wake your application and process the request.

For detailed instructions on setting up an NDS, see [Setting up an NDS](/notifications/setup_nds.md).

### Register a webhook

You need to register a webhook URL that will be called when someone tries to make a payment to your application while it's offline. This webhook should point to your service that handles webhook requests, for example, a Notification Delivery Service (NDS) if you serve mobile applications.

For more information about setting up webhooks, see [Using webhooks](/notifications/using_webhooks.md).

### Integrate the Notification Plugin

The Notification Plugin handles push notifications sent from the Notification Delivery Service (NDS) and automatically processes incoming requests. It is designed to be integrated into Android or iOS mobile applications with minimum effort. To integrate it:

- **For Android**: Follow the [Android setup guide](/notifications/android_setup.md)
- **For iOS**: Follow the [iOS setup guide](/notifications/ios_setup.md)

## Using LNURL-pay for offline payments

LNURL-pay provides a static Lightning payment identifier that can be shared as a QR code or Lightning address. To receive offline payments via LNURL-pay:

### Set up an LNURL-pay service

An LNURL-pay web service is needed if your application wants to support receiving payments using LNURL-pay. This service handles all LNURL-pay requests according to the [LNURL spec](https://github.com/lnurl/luds) and forwards them as webhook requests to the webhook service.

For detailed instructions on setting up this service, see the <a target="_blank" href="https://github.com/breez/breez-lnurl">LNURL service</a> repository.


### Register your LNURL-pay service

For the application to use an LNURL-pay service and to receive webhook requests, it needs to register its webhook and other details with the LNURL-pay service.

For detailed instructions on registering, see [LNURL-Pay registration](/notifications/lnurl_pay_registration.md).


#### Flow for LNURL-pay offline payments

1. A user initiates payment to your LNURL or Lightning address
2. The LNURL service receives the request and calls your registered webhook
3. The NDS sends a push notification to your application
4. The Notification Plugin processes the notification and handles the two-step flow:
   - First responds with payment information (min/max amounts)
   - Then generates an invoice when the user confirms the payment amount
5. The LNURL service delivers the invoice to the payer
6. When the payment is complete, another notification is sent to confirm receipt

## Using BOLT12 offers for offline payments

BOLT12 offers are static payment codes that can be paid to multiple times. The BOLT12 offer can be displayed as a QR code or combined with BIP353 to form a human readable address. When an invoice is requested through the Lightning Network the swap service sends a webhook request to fetch an invoice.

### Create a BOLT12 offer

After registering a webhook URL, use the SDK to create a BOLT12 offer.

For more details on creating the BOLT12 offer, see [BOLT12 offer](receive_payment.md#bolt12-offer).

### Register a BIP353 address

Once you have a BOLT12 offer it can be registered as a DNS record according to [BIP353](https://github.com/bitcoin/bips/blob/master/bip-0353.mediawiki), associating a selected username to the BOLT12 offer to form a human readable address.

For more details on registering this BIP353 address, see [LNURL-Pay and BIP353 registration](lnurl_pay_service.md). If you do not plan to use LNURL-pay, see [BIP353 registration](bip353_pay_service.md).

### Flow for BOLT12 offline payments

1. You share your BOLT12 offer with potential payers
2. When someone wants to pay, their wallet requests an invoice from the offer
3. The swap service receives this request and calls your registered webhook
4. The NDS forwards the request via push notification to your application
5. The Notification Plugin processes this notification and:
   - Starts the SDK
   - Creates a new invoice for the request
   - Returns it to the swap service
6. The swap service delivers the invoice to the payer
7. Once paid, another notification confirms receipt
