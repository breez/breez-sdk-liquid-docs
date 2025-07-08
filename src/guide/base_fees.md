# Base Fees

**The Breez SDK charges small base fees for end-users to send and receive payments.**

- [Sending Lightning Payments](#sending-lightning-payments)
- [Receiving Lightning Payments](#receiving-lightning-payments)
- [Sending to a BTC Address](#sending-to-a-btc-address)
- [Receiving from a BTC Address](#receiving-from-a-btc-address)

**Note:** The SDK uses Liquid confidential transactions. This means a discount v-size is used to calculate transaction fees. For more details, see [ELIP-200](https://github.com/ElementsProject/ELIPs/blob/main/elip-0200.mediawiki).

## Sending Lightning Payments

There are two fee structures when sending Lightning payments, depending on whether the Lightning invoice contains a <a target="_blank" href="https://docs.boltz.exchange/v/api/magic-routing-hints">Magic Routing Hint</a>. The Magic Routing Hint is a way to associate a Liquid address with the invoice, and when set, will be paid with a direct Liquid transaction instead of a swap.

### Submarine swap

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1. User broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3. Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~34 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
2. **Claim Transaction Fee:** ~19 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
3. **Swap Service Fee:** 0.1% fee on the amount sent.

**Note:** swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 10k sats, the fee would be:
>
> - 34 sats [Lockup Transaction Fee] + 19 sats [Claim Transaction Fee] + 10 sats [Swapper Service Fee] = 63 sats

### Direct Liquid transaction

Sending payments when the Magic Routing Hint is set involves one Liquid on-chain transaction. The process is as follows:

1. User broadcasts an L-BTC transaction to the Liquid address of the Magic Routing Hint.

The fee a user pays to send a payment is composed of one part:

1. **Transaction Fee:** ~26 sats (0.1&nbsp;sat/discount&nbsp;vbyte).

## Receiving Lightning Payments

There are two fee structures when receiving Lightning payments depending if the sender uses the <a target="_blank" href="https://docs.boltz.exchange/v/api/magic-routing-hints">Magic Routing Hint</a>. When the invoice contains a Magic Routing Hint, the associated Liquid address can be used to pay the invoice with a direct Liquid transaction instead of a swap.

### Reverse submarine swap

Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions. The process is as follows:

1. Sender pays the Swapper invoice.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address and then exposes the preimage.
4. Swapper uses the preimage to claim the funds from the Liquid lockup address.

The fee a user pays to receive a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~27 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
2. **Claim Transaction Fee:** ~20 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
3. **Swap Service Fee:** 0.25% fee on the amount received.

**Note:** swap service fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 10k sats, the fee for the end-user would be:
>
> - 27 sats [Lockup Transaction Fee] + 20 sats [Claim Transaction Fee] + 25 sats [Swapper Service Fee] = 72 sats

### Direct Liquid transaction

Receiving payments when the Magic Routing Hint is used involves one Liquid on-chain transaction. The process is as follows:

1. Sender broadcasts an L-BTC transaction to the Liquid address of the Magic Routing Hint.

The user receiving the payment doesn't pay any fees.

## Sending to a BTC Address

Sending to a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions. The process is as follows:

1. SDK broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper broadcasts a BTC transaction to a Bitcoin lockup address.
3. Recipient claims the funds from the Bitcoin lockup address.
4. Swapper claims the funds from the Liquid lockup address.

The fee to send to a BTC address is composed of four parts:

1. **L-BTC Lockup Transaction Fee**: ~34 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
2. **BTC Lockup Transaction Fee**: the swapper charges a mining fee based on the current bitcoin mempool usage.
3. **Swap Service Fee:** 0.1% fee on the amount sent.
4. **BTC Claim Transaction Fee:** the SDK fees to claim BTC funds to the destination address, based on the current Bitcoin mempool usage.

**Note:** swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 100k sats, the mining fees returned by the Swapper are 2000 sats, and the claim fees for the user are 1000 sats—the fee would be:
>
> - 34 sats [Lockup Transaction Fee] + 2000 sats [BTC Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 1000 sats [BTC Lockup Transaction Fee] = 3132 sats

## Receiving from a BTC Address

Receiving from a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions.

The process is as follows:

1. Sender broadcasts a BTC transaction to the Bitcoin lockup address.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address.
4. Swapper claims the funds from the Bitcoin lockup address.

The fee to receive from a BTC address is composed of three parts:

1. **L-BTC Claim Transaction Fee:** ~20 sats (0.1&nbsp;sat/discount&nbsp;vbyte).
2. **BTC Claim Transaction Fee:** the swapper charges a mining fee based on the Bitcoin mempool usage at the time of the swap.
3. **Swapper Service Fee:** the swapper charges a 0.1% fee on the amount received.

**Note:** swapper service see is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the sender sends 100k sats and the mining fees returned by the Swapper are 2000 sats—the fee for the end-user would be:
>
> - 20 sats [Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 2000 sats [BTC Claim Transaction Fee] = 2120 sats
