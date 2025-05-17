# LNURL-Pay and BIP353 registration

#### LNURL-Pay

LNURL-Pay requires a web service that serves LNURL-Pay requests. This service needs to communicate with the SDK in order to fetch the necessary metadata data and the associated payment request.
To interact with the SDK, the service uses a simple protocol over push notifications:
* The service sends a push notification to the user's mobile app with the LNURL-Pay request and a reply URL.
* The app responds to reply URL with the required data.
* The service forwards the data to the payer.

#### BOLT12 offer

Unlike LNURL-Pay, BOLT12 offers do not require a web service that serves requests. Instead when someone wants to pay a BOLT12 offer, they use the Lightning network to request a BOLT12 invoice. That BOLT12 offer can also be made available via a DNS TXT lookup using [BIP353](https://github.com/bitcoin/bips/blob/master/bip-0353.mediawiki). You can do this in the workflow below by registering both a `username` and an `offer`.

## General workflow
The following workflow is application specific and the steps detailed below refer to the misty-breez wallet implementation which requires running <b>[breez-lnurl](https://github.com/breez/breez-lnurl) </b>service.

![pay](https://github.com/breez/breez-sdk-docs/assets/5394889/ef0a3111-3604-4789-89c6-23adbd7e5d52)

### Registering with the service
Use a POST request to the service endpoint ```https://app.domain/lnurlpay/[pubkey]``` with the following payload to register:

```json
{
    "time": 1231006505, // Current UNIX timestamp
    "webhook_url": "[notification service webhook URL]",
    "username": "[optional username]",
    "offer": "[optional BOLT12 offer]",
    "signature": "[signed message]"
}
```

The `signature` refers to the result of a message signed by the private key of the `pubkey`, where the message is comprised of the following text: 

```
[time]-[webhook_url]
``` 
or, when the optional `username` field is set:
```
[time]-[webhook_url]-[username]
``` 
where `time`, `webhook_url` and `username` are the payload fields. 
```
[time]-[webhook_url]-[username]-[offer]
``` 
where `time`, `webhook_url`, `username` and `offer` are the payload fields. 

The service responds with following payload: 
```json
{
    "lnurl": "[LNURL-pay encoded endpoint]", 
    "lightning_address": "username@app.domain", // Only set when username is included
    "bip353_address": "username@app.domain" // Only set when username and offer is included
}
```

After registering with both a `username` and an `offer`, the resulting `lightning_address` and `bip353_address` are the same internet identifier, meaning it is both BIP353 and LNURL-Pay compatible and can be paid to via both BOLT12 offer/invoice or LNURL-Pay, depending how the payer's client chooses to parse it.

<div class="warning">
<h4>Developer note</h4>

When a user changes their already registered username, this previous username is freely available to be registered by another user.

</div>

### Lifecycle of an LNURL-Pay payment

#### Processing an LNURL-Pay request
When an LNURL-Pay GET request is received at ```https://app.domain/lnurlp/[identifier]``` (or ```https://app.domain/.well-known/lnurlp/[identifier]``` for lightning addresses) the service then sends a push notification to the app with the LNURL-Pay request and a callback URL. The payload may look like the following:

```json
{
    "template": "lnurlpay_info",
    "data": {  
        "reply_url": "https://app.domain/respond/[request_id]",
        "callback_url": "https://app.domain/lnurlpay/[identifier]/invoice"
    }
}
```

The ```reply_url``` is used by the app to respond to the LNURL-Pay request.
The ```callback_url``` is the LNURL-Pay callback URL, used by the payer to fetch the invoice.

#### Responding to the callback URL
When the app receives the push notification, it parses the payload and then uses the ```reply_url``` to respond with the required data, for example:

```json
{
    "callback": "https://app.domain/lnurlpay/[identifier]/invoice",
    "maxSendable": 10000,
    "minSendable": 1000,
    "metadata": "[[\"text/plain\",\"Pay to Breez\"]]",
    "tag": "payRequest"
}
```

The service receives the response from the app and forwards it to the sender.

#### Fetching a BOLT11 invoice
The sender fetches a BOLT11 invoice by invoking a GET request to the ```callback``` URL when a specific amount is added as a query parameter. For example: 
```
https://app.domain/lnurlpay/[identifier]/invoice?amount=1000
```
An additional push notification is triggered to send the invoice request to the app. Then the app responds with the BOLT11 invoice data.

#### Paying the invoice
In the last step, the payer pays the received invoice. Follow the steps [here](/notifications/getting_started.md) to receive payments via push notifications.
