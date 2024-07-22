# **End-User Fees**

**The Breez SDK is free for developers. There are fees for *end-users* to send and receive payments.**

- [Sending Lightning Payments](https://github.com/breez/breez-sdk-liquid-docs/new/main/src/guide#sending-lightning-payments)
- [Receiving Lightning Payments](https://github.com/breez/breez-sdk-liquid-docs/new/main/src/guide#receiving-lightning-payments)
- [Sending to a BTC Address](https://github.com/breez/breez-sdk-liquid-docs/new/main/src/guide#sending-to-a-btc-address)
- [Receiving from a BTC Address](https://github.com/breez/breez-sdk-liquid-docs/new/main/src/guide#receiving-from-a-btc-address)

## **Sending Lightning Payments**

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1. User broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3. Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** the SDK uses a confidential transaction and the fee is ~26 sats (0.01 sat/vbyte).
2. **Claim Transaction Fee:** the Swapper uses a confidential transaction and the fee is ~14 sats (0.01 sat/vbyte).
3. **Swapper Service Fee:** the Swapper charges a 0.1% fee on the amount sent.

Note: The Swapper Service Fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 100k sats, the fee would be:
> - 26 sats [Lockup Transaction Fee] + 14 sats [Claim Transaction Fee] + 100 sats [Swapper Service Fee] = 140 sats

## **Receiving Lightning Payments**

Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions. The process is as follows:

1. Sender pays the Swapper invoice.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address and then exposes the preimage.
4. Swapper uses the preimage to claim the funds from the Liquid lockup address.

The fee a user pays to receive a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** the Swapper uses a confidential transaction and the fee is ~26 sats (0.01 sat/vbyte).
2. **Claim Transaction Fee:** the SDK uses a confidential transaction and the fee is ~14 sats (0.01 sat/vbyte).
3. **Swapper Service Fee:** the Swapper charges a 0.25% fee on the amount received.

Note: The Swapper Service Fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 100k sats, the fee for the end-user would be:
> - 26 sats [Lockup Transaction Fee] + 14 sats [Claim Transaction Fee] + 250 sats [Swapper Service Fee] = 290 sats

## **Sending to a BTC Address**

Sending to a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions. The process is as follows:

1. SDK broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper broadcasts a BTC transaction to a Bitcoin lockup address.
3. Recipient claims the funds from the Bitcoin lockup address.
4. Swapper claims the funds from the Liquid lockup address.

The fee to send to a BTC address is composed of four parts:

1. **L-BTC Lockup Transaction Fee**: the SDK uses a confidential transaction and the fee is ~26 sats (0.01 sat/vbyte).
2. **BTC Lockup Transaction Fee**: the Swapper charges a mining fee based on the current bitcoin mempool usage.
3. **Swapper Service Fee:** the Swapper charges a 0.1% fee on the amount sent.
4. **BTC Claim Transaction Fee:** the SDK fees to claim BTC funds to the destination address, based on the current Bitcoin mempool usage.

Note: The Swapper Service Fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 100k sats, the mining fees returned by the Swapper are 2000 sats, and the claim fees for the user are 1000 sats—the fee would be:
> - 26 sats [Lockup Transaction Fee] + 2000 sats [BTC Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 1000 sats [BTC Lockup Transaction Fee] = 3126 sats
 

## **Receiving from a BTC Address**

Receiving from a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions.

The process is as follows:

1. Sender broadcasts a BTC transaction to the Bitcoin lockup address.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address.
4. Swapper claims the funds from the Bitcoin lockup address.

The fee to receive from a BTC address is composed of three parts:

1. **L-BTC Claim Transaction Fee:** the SDK uses a confidential transaction and the fee is ~14 sats (0.01 sat/vbyte).
2. **BTC Claim Transaction Fee:** the Swapper charges a mining fee based on the Bitcoin mempool usage at the time of the swap.
3. **Swapper Service Fee:** the Swapper charges a 0.1% fee on the amount received.

Note: The Swapper Service Fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the sender sends 100k sats and the mining fees returned by the Swapper are 2000 sats—the fee for the end-user would be:
> - 14 sats [Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 2000 sats [BTC Claim Transaction Fee] = 2114 sats
