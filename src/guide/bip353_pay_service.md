# BIP353 registration

Unlike LNURL-Pay, BOLT12 offers do not require a web service that serves requests. Instead when someone wants to pay a BOLT12 offer, they use the Lightning network to request a BOLT12 invoice. That BOLT12 offer can also be made available via a DNS TXT lookup using [BIP353](https://github.com/bitcoin/bips/blob/master/bip-0353.mediawiki). You can do this in the workflow below by registering both a `username` and an `offer`.

### Registering with the service
Use a POST request to the service endpoint ```https://app.domain/bolt12offer/[pubkey]``` with the following payload to register:

```json
{
    "time": 1231006505, // Current UNIX timestamp
    "username": "[username]",
    "offer": "[BOLT12 offer]",
    "signature": "[signed message]"
}
```

The `signature` refers to the result of a message signed by the private key of the `pubkey`, where the message is comprised of the following text: 

```
[time]-[username]-[offer]
``` 
where `time`, `username` and `offer` are the payload fields. 

The service responds with following payload: 
```json
{
    "bip353_address": "username@app.domain"
}
```

<div class="warning">
<h4>Developer note</h4>

When a user changes their already registered username, this previous username becomes freely available to be registered by another user.

</div>
