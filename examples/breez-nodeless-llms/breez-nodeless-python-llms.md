# Breez SDK Nodeless (Liquid implementation) Documentation

This comprehensive document provides all the context needed to build applications with the Python bindings of Breez SDK Nodeless, a toolkit for integrating Bitcoin, Lightning Network, and Liquid Network functionality into your applications.

## Overview

Breez SDK Nodeless (Liquid implementation) is a powerful library that allows developers to integrate Bitcoin, Lightning Network, and Liquid Network functionality into their applications. The SDK abstracts many of the complexities of working with these technologies, providing a simple interface for common operations such as sending and receiving payments, managing wallets, and interacting with both Lightning and Liquid networks.

Key capabilities include:
- Wallet management and balance tracking
- Lightning Network payments
- Liquid Network transactions
- Onchain Bitcoin operations
- LNURL support (auth, pay, withdraw)
- Non-Bitcoin asset management
- Webhook integration
- Event handling with listeners

## Getting Started

### Installation

```bash
pip install breez-sdk-liquid
```

### Guidelines
- **always make sure the sdk instance is synced before performing any actions**
-  **Add logging**: Add sufficient logging into your application to diagnose any issues users are having. 
- **Display pending payments**: Payments always contain a status field that can be used to determine if the payment was completed or not. Make sure you handle the case where the payment is still pending by showing the correct status to the user.
    
- **Enable swap refunds**: Swaps that are the result of receiving an On-Chain Transaction may not be completed and change to `Refundable` state. Make sure you handle this case correctly by allowing the user to retry the refund with different fees as long as the refund is not confirmed.
- **Expose swap fees**: When sending or receiving on-chain, make sure to clearly show the expected fees involved, as well as the send / receive amounts.
### Initializing the SDK

To get started with Breez SDK Nodeless (Liquid implementation), you need to initialize the SDK with your configuration:

```python
import breez_sdk_liquid
from breez_sdk_liquid import connect, default_config, ConnectRequest, LiquidNetwork

def start():
    # Your mnemonic seed phrase for wallet recovery
    mnemonic = "<mnemonic words>"

    # Create the default config, providing your Breez API key
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Customize the config object according to your needs
    config.working_dir = "path to an existing directory"

    try:
        connect_request = ConnectRequest(
            config=config,
            mnemonic=mnemonic
        )
        sdk = connect(connect_request, None)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
```

### Custom Signer Support

If you prefer to manage your own keys, you can use a custom signer:

```python
import logging
import breez_sdk_liquid
from breez_sdk_liquid import connect_with_signer, default_config, LiquidNetwork, Signer, ConnectWithSignerRequest

def connect_with_self_signer(signer: Signer):
   
    # Create the default config, providing your Breez API key
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Customize the config object according to your needs
    config.working_dir = "path to an existing directory"

    try:
        connect_request = ConnectWithSignerRequest(config=config)
        sdk = connect_with_signer(connect_request, signer, None)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
```

### Basic Operations

#### Fetch Balance
- **always make sure the sdk instance is synced before performing any actions**

```python
def fetch_balance(sdk):
    try:
        info = sdk.get_info()
        balance_sat = info.wallet_info.balance_sat
        pending_send_sat = info.wallet_info.pending_send_sat
        pending_receive_sat = info.wallet_info.pending_receive_sat
    except Exception as error:
        logging.error(error)
        raise
```

#### Logging and Event Handling

```python
# Define a logger class
class SdkLogger(Logger):
    def log(self, log_entry: LogEntry):
        logging.debug(f"Received log [{log_entry.level}]: {log_entry.line}")

# Set up logging
def set_logger(logger: SdkLogger):
    try:
        breez_sdk_liquid.set_logger(logger)
    except Exception as error:
        logging.error(error)
        raise

# Define an event listener
class SdkListener(EventListener):
    def on_event(self, sdk_event: SdkEvent):
        logging.debug(f"Received event {sdk_event}")

# Add an event listener
def add_event_listener(sdk, listener: SdkListener):
    try:
        listener_id = sdk.add_event_listener(listener)
        return listener_id
    except Exception as error:
        logging.error(error)
        raise

# Remove an event listener
def remove_event_listener(sdk, listener_id):
    try:
        sdk.remove_event_listener(listener_id)
    except Exception as error:
        logging.error(error)
        raise
```

## Core Features

### Buying Bitcoin

```python
from breez_sdk_liquid import BindingLiquidSdk, OnchainPaymentLimitsResponse, BuyBitcoinProvider, PrepareBuyBitcoinRequest, PrepareBuyBitcoinResponse, BuyBitcoinRequest

def fetch_onchain_limits(sdk: BindingLiquidSdk):
    try:
        current_limits = sdk.fetch_onchain_limits()
        logging.debug(
            "Minimum amount, in sats ",
            current_limits.receive.min_sat
        )
        logging.debug(
            "Maximum amount, in sats ",
            current_limits.receive.max_sat
        )
        return current_limits
    except Exception as error:
        logging.error(error)
        raise

def prepare_buy_btc(sdk: BindingLiquidSdk, current_limits: OnchainPaymentLimitsResponse):
    try:
        req = PrepareBuyBitcoinRequest(
            provider=BuyBitcoinProvider.MOONPAY,
            amount_sat=current_limits.receive.min_sat
        )
        prepare_response = sdk.prepare_buy_bitcoin(req)

        # Check the fees are acceptable before proceeding
        receive_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", receive_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def buy_btc(sdk: BindingLiquidSdk, prepare_response: PrepareBuyBitcoinResponse):
    try:
        req = BuyBitcoinRequest(prepare_response=prepare_response)
        url = sdk.buy_bitcoin(req)
    except Exception as error:
        logging.error(error)
        raise
```

### Fiat Currencies

```python
def list_fiat_currencies(sdk):
   try:
      supported_fiat_currencies = sdk.list_fiat_currencies()
   except Exception as error:
      print(error)
      raise

def fetch_fiat_rates(sdk):
   try:
      fiat_rates = sdk.fetch_fiat_rates()
   except Exception as error:
      print(error)
      raise
```

### Sending Payments

#### Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1. User broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3. Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~34 sats (0.1 sat/discount vbyte).
2. **Claim Transaction Fee:** ~19 sats (0.1 sat/discount vbyte).
3. **Swap Service Fee:** 0.1% fee on the amount sent.

Note: swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 10k sats, the fee would be:
> 
> - 34 sats [Lockup Transaction Fee] + 19 sats [Claim Transaction Fee] + 10 sats [Swapper Service Fee] = 63 sats
```python
def get_lightning_limits(sdk: BindingLiquidSdk):
    try:
        current_limits = sdk.fetch_lightning_limits()
        logging.debug(
            "Minimum amount, in sats ",
            current_limits.send.min_sat
        )
        logging.debug(
            "Maximum amount, in sats ",
            current_limits.send.max_sat
        )
        return current_limits
    except Exception as error:
        logging.error(error)
        raise

def prepare_send_payment_lightning_bolt11(sdk: BindingLiquidSdk):
    # Set the bolt11 invoice you wish to pay
    destination = "<bolt11 invoice>"
    try:
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def prepare_send_payment_lightning_bolt12(sdk: BindingLiquidSdk):
    # Set the bolt12 offer you wish to pay
    destination = "<bolt12 offer>"
    try:
        optional_amount = PayAmount.BITCOIN(5_000)

        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount
            )
        )

        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
```

#### Liquid Payments

```python
def prepare_send_payment_liquid(sdk: BindingLiquidSdk):
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        optional_amount = PayAmount.BITCOIN(5_000)
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def prepare_send_payment_liquid_drain(sdk: BindingLiquidSdk):
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        optional_amount = PayAmount.DRAIN
        prepare_response = sdk.prepare_send_payment(
            PrepareSendRequest(
                destination=destination,
                amount=optional_amount
            )
        )

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {send_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
```

#### Execute Payment

For BOLT12 payments you can also include an optional payer note, which will be included in the invoice.

- **always make sure the sdk instance is synced before performing any actions**

```python
def send_payment(sdk: BindingLiquidSdk, prepare_response: PrepareSendResponse):
    try:
        optional_payer_note = "<payer note>"
        send_response = sdk.send_payment(
            SendPaymentRequest(
                prepare_response=prepare_response,
                payer_note=optional_payer_note
            )
        )
        payment = send_response.payment
    except Exception as error:
        logging.error(error)
        raise
```

### Receiving Payments
**always make sure the sdk instance is synced before performing any actions**
#### Lightning Payments
Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions. The process is as follows:

1. Sender pays the Swapper invoice.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address and then exposes the preimage.
4. Swapper uses the preimage to claim the funds from the Liquid lockup address.

The fee a user pays to receive a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~27 sats (0.1 sat/discount vbyte).
2. **Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
3. **Swap Service Fee:** 0.25% fee on the amount received.

Note: swap service fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 10k sats, the fee for the end-user would be:
> 
> - 27 sats [Lockup Transaction Fee] + 20 sats [Claim Transaction Fee] + 25 sats [Swapper Service Fee] = 72 sats
```python
def prepare_receive_lightning(sdk: BindingLiquidSdk):
    try:
        # Fetch the lightning Receive limits
        current_limits = sdk.fetch_lightning_limits()
        logging.debug(f"Minimum amount allowed to deposit in sats {current_limits.receive.min_sat}")
        logging.debug(f"Maximum amount allowed to deposit in sats {current_limits.receive.max_sat}")

        # Set the invoice amount you wish the payer to send, which should be within the above limits
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.LIGHTNING,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
```

#### Onchain Payments

```python
def prepare_receive_onchain(sdk: BindingLiquidSdk):
    try:
        # Fetch the onchain Receive limits
        current_limits = sdk.fetch_onchain_limits()
        logging.debug(f"Minimum amount allowed to deposit in sats {current_limits.receive.min_sat}")
        logging.debug(f"Maximum amount allowed to deposit in sats {current_limits.receive.max_sat}")

        # Set the onchain amount you wish the payer to send, which should be within the above limits
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.BITCOIN_ADDRESS,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
```

#### Liquid Payments

```python
def prepare_receive_liquid(sdk: BindingLiquidSdk):
    try:
        # Create a Liquid BIP21 URI/address to receive a payment to.
        # There are no limits, but the payer amount should be greater than broadcast fees when specified
        # Note: Not setting the amount will generate a plain Liquid address
        optional_amount = ReceiveAmount.BITCOIN(5_000)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.LIQUID_ADDRESS,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug(f"Fees: {receive_fees_sat} sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise
```

#### Execute Receive

```python
def receive_payment(sdk: BindingLiquidSdk, prepare_response: PrepareReceiveResponse):
    try:
        optional_description = "<description>"
        req = ReceivePaymentRequest(
            prepare_response=prepare_response,
            description=optional_description
        )
        res = sdk.receive_payment(req)
        destination = res.destination
    except Exception as error:
        logging.error(error)
        raise
```

### LNURL Operations

#### LNURL Authentication

```python
def auth(sdk: BindingLiquidSdk):
    # Endpoint can also be of the form:
    # keyauth://domain.com/auth?key=val
    lnurl_auth_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu"

    try:
        parsed_input = sdk.parse(lnurl_auth_url)
        if isinstance(parsed_input, InputType.LN_URL_AUTH):
            result = sdk.lnurl_auth(parsed_input.data)
            if result.is_ok():
                logging.debug("Successfully authenticated")
            else:
                logging.debug("Failed to authenticate")
    except Exception as error:
        logging.error(error)
        raise
```

#### LNURL Pay

```python
def prepare_pay(sdk: BindingLiquidSdk):
    # Endpoint can also be of the form:
    # lnurlp://domain.com/lnurl-pay?key=val
    # lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    lnurl_pay_url = "lightning@address.com"
    try: 
        parsed_input = sdk.parse(lnurl_pay_url)
        if isinstance(parsed_input, InputType.LN_URL_PAY):
            amount = PayAmount.BITCOIN(5_000)
            optional_comment = "<comment>"
            optional_validate_success_action_url = True

            req = PrepareLnUrlPayRequest(
                data=parsed_input.data,
                amount=amount,
                bip353_address=parsed_input.bip353_address,
                comment=optional_comment,
                validate_success_action_url=optional_validate_success_action_url
            )
            prepare_response = sdk.prepare_lnurl_pay(req)

            # If the fees are acceptable, continue to create the LNURL Pay
            fees_sat = prepare_response.fees_sat
            logging.debug("Fees: ", fees_sat, " sats")
            return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def pay(sdk: BindingLiquidSdk, prepare_response: PrepareLnUrlPayResponse):
    try:
        result = sdk.lnurl_pay(LnUrlPayRequest(prepare_response))
    except Exception as error:
        logging.error(error)
        raise
```

#### LNURL Withdraw

```python
def withdraw(sdk: BindingLiquidSdk):
    # Endpoint can also be of the form:
    # lnurlw://domain.com/lnurl-withdraw?key=val
    lnurl_withdraw_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk"

    try:
        parsed_input = sdk.parse(lnurl_withdraw_url)
        if isinstance(parsed_input, InputType.LN_URL_WITHDRAW):
            amount_msat = parsed_input.data.min_withdrawable
            result = sdk.lnurl_withdraw(parsed_input.data, amount_msat, "comment")
            return result
    except Exception as error:
        logging.error(error)
        raise
```

### Onchain Operations

#### Pay Onchain

```python
def get_onchain_limits(sdk: BindingLiquidSdk):
    try:
        current_limits = sdk.fetch_onchain_limits()
        logging.debug(
            "Minimum amount, in sats ",
            current_limits.send.min_sat
        )
        logging.debug(
            "Maximum amount, in sats ",
            current_limits.send.max_sat
        )
        return current_limits
    except Exception as error:
        logging.error(error)
        raise

def prepare_pay_onchain(sdk: BindingLiquidSdk):
    try:
        amount = PayAmount.BITCOIN(5_000)
        prepare_request = PreparePayOnchainRequest(amount=amount)
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise

def prepare_pay_onchain_fee_rate(sdk: BindingLiquidSdk):
    try:
        amount = PayAmount.BITCOIN(5_000)
        optional_sat_per_vbyte = 21

        prepare_request = PreparePayOnchainRequest(
            amount=amount,
            fee_rate_sat_per_vbyte=optional_sat_per_vbyte
        )
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        claim_fees_sat = prepare_response.claim_fees_sat
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise

def start_pay_onchain(sdk: BindingLiquidSdk, prepare_response: PreparePayOnchainResponse):
    address = "bc1.."
    try:
        sdk.pay_onchain(PayOnchainRequest(
            address=address,
            prepare_response=prepare_response
        ))
    except Exception as error:
        logging.error(error)
        raise
```

#### Drain Funds

```python
def prepare_pay_onchain_drain(sdk: BindingLiquidSdk):
    try:
        amount = PayAmount.DRAIN
        prepare_request = PreparePayOnchainRequest(amount=amount)
        prepare_response = sdk.prepare_pay_onchain(prepare_request)

        # Check if the fees are acceptable before proceeding
        total_fees_sat = prepare_response.total_fees_sat
    except Exception as error:
        logging.error(error)
        raise
```

#### Receive Onchain

```python
def list_refundables(sdk: BindingLiquidSdk):
    try:
        refundables = sdk.list_refundables()
        return refundables
    except Exception as error:
        logging.error(error)
        raise

def execute_refund(sdk: BindingLiquidSdk, refund_tx_fee_rate: int, refundable: RefundableSwap):
    destination_address = "..."
    fee_rate_sat_per_vbyte = refund_tx_fee_rate
    try:
        sdk.refund(RefundRequest(
            swap_address=refundable.swap_address,
            refund_address=destination_address,
            fee_rate_sat_per_vbyte=fee_rate_sat_per_vbyte
        ))
    except Exception as error:
        logging.error(error)
        raise

def rescan_swaps(sdk: BindingLiquidSdk):
    try:
        sdk.rescan_onchain_swaps()
    except Exception as error:
        logging.error(error)
        raise

def recommended_fees(sdk: BindingLiquidSdk):
    try:
        fees = sdk.recommended_fees()
    except Exception as error:
        logging.error(error)
        raise
```

#### Handle Fee Acceptance

```python
def handle_payments_waiting_fee_acceptance(sdk: BindingLiquidSdk):
    try:
        # Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
        payments_waiting_fee_acceptance = sdk.list_payments(
            ListPaymentsRequest(
                states=[PaymentState.WAITING_FEE_ACCEPTANCE]
            )
        )

        for payment in payments_waiting_fee_acceptance:
            if not isinstance(payment.details, PaymentDetails.BITCOIN):
                # Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
                continue

            fetch_fees_response = sdk.fetch_payment_proposed_fees(
                FetchPaymentProposedFeesRequest(
                    swap_id=payment.details.swap_id
                )
            )

            logging.info(
                f"Payer sent {fetch_fees_response.payer_amount_sat} "
                f"and currently proposed fees are {fetch_fees_response.fees_sat}"
            )

            # If the user is ok with the fees, accept them, allowing the payment to proceed
            sdk.accept_payment_proposed_fees(
                AcceptPaymentProposedFeesRequest(
                    response=fetch_fees_response
                )
            )

    except Exception as error:
        logging.error(error)
        raise
```

### Non-Bitcoin Assets

```python
def prepare_receive_asset(sdk: BindingLiquidSdk):
    try:
        # Create a Liquid BIP21 URI/address to receive an asset payment to.
        # Note: Not setting the amount will generate an amountless BIP21 URI.
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        optional_amount = ReceiveAmount.ASSET(usdt_asset_id, 1.50)
        prepare_request = PrepareReceiveRequest(
            payment_method=PaymentMethod.LIQUID_ADDRESS,
            amount=optional_amount
        )
        prepare_response = sdk.prepare_receive_payment(prepare_request)

        # If the fees are acceptable, continue to create the Receive Payment
        receive_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", receive_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def prepare_send_payment_asset(sdk: BindingLiquidSdk):
    # Set the Liquid BIP21 or Liquid address you wish to pay
    destination = "<Liquid BIP21 or address>"
    try:
        # If the destination is an address or an amountless BIP21 URI,
        # you must specifiy an asset amount
        usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"
        optional_amount = PayAmount.ASSET(usdt_asset_id, 1.50)
        prepare_response = sdk.prepare_send_payment(PrepareSendRequest(destination, optional_amount))

        # If the fees are acceptable, continue to create the Send Payment
        send_fees_sat = prepare_response.fees_sat
        logging.debug("Fees: ", send_fees_sat, " sats")
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise

def configure_asset_metadata():
    # Create the default config
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure asset metadata
    config.asset_metadata = [
        AssetMetadata(
            asset_id="18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            name="PEGx EUR",
            ticker="EURx",
            precision=8
        )
    ]

def fetch_asset_balance(sdk: BindingLiquidSdk):
    try:
        info = sdk.get_info()
        asset_balances = info.wallet_info.asset_balances
    except Exception as error:
        logging.error(error)
        raise
```

### Messages and Signing

```python
def sign_message(sdk: BindingLiquidSdk):
    message = "<message to sign>"
    try:
        sign_message_request = SignMessageRequest(message=message)
        sign_message_response = sdk.sign_message(sign_message_request)

        # Get the wallet info for your pubkey
        info = sdk.get_info()

        signature = sign_message_response.signature
        pubkey = info.wallet_info.pubkey

        logging.debug(f"Pubkey: {pubkey}")
        logging.debug(f"Signature: {signature}")
    except Exception as error:
        logging.error(error)
        raise

def check_message(sdk: BindingLiquidSdk):
    message = "<message>"
    pubkey = "<pubkey of signer>"
    signature = "<message signature>"
    try:
        check_message_request = CheckMessageRequest(
            message=message,
            pubkey=pubkey,
            signature=signature
        )
        check_message_response = sdk.check_message(check_message_request)

        is_valid = check_message_response.is_valid

        logging.debug(f"Signature valid: {is_valid}")
    except Exception as error:
        logging.error(error)
        raise
```

### List Payments

```python
def get_payment(sdk: BindingLiquidSdk):
    try:
        payment_hash = "<payment hash>"
        sdk.get_payment(GetPaymentRequest.PAYMENT_HASH(payment_hash))

        swap_id = "<swap id>"
        sdk.get_payment(GetPaymentRequest.SWAP_ID(swap_id))
    except Exception as error:
        logging.error(error)
        raise

def list_payments(sdk: BindingLiquidSdk):
    try:
        sdk.list_payments(ListPaymentsRequest())
    except Exception as error:
        logging.error(error)
        raise

def list_payments_filtered(sdk: BindingLiquidSdk):
    try:
        req = ListPaymentsRequest(
            filters = [PaymentType.SEND],
            from_timestamp = 1696880000, 
            to_timestamp = 1696959200, 
            offset = 0,
            limit = 50)
        sdk.list_payments(req)
    except Exception as error:
        logging.error(error)
        raise

def list_payments_details_address(sdk: BindingLiquidSdk):
    try:
        address = "<Bitcoin address>"
        req = ListPaymentsRequest(
            details = ListPaymentDetails.BITCOIN(address))
        sdk.list_payments(req)
    except Exception as error:
        logging.error(error)
        raise

def list_payments_details_destination(sdk: BindingLiquidSdk):
    try:
        destination = "<Liquid BIP21 or address>"
        req = ListPaymentsRequest(
            details = ListPaymentDetails.LIQUID(destination=destination))
        sdk.list_payments(req)
    except Exception as error:
        logging.error(error)
        raise
```

### Webhook Integration

```python
def register_webhook(sdk: BindingLiquidSdk):
    try:
        sdk.register_webhook("https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>")
    except Exception as error:
        logging.error(error)
        raise

def unregister_webhook(sdk: BindingLiquidSdk):
    try:
        sdk.unregister_webhook()
    except Exception as error:
        logging.error(error)
        raise
```

### Input Parsing

```python
def parse_input(sdk: BindingLiquidSdk):
    input = "an input to be parsed..."

    try:
        parsed_input = sdk.parse(input)
        if isinstance(parsed_input, InputType.BITCOIN_ADDRESS):
            logging.debug(f"Input is Bitcoin address {parsed_input.address.address}")
        elif isinstance(parsed_input, InputType.BOLT11):
            amount = "unknown"
            if parsed_input.invoice.amount_msat:
                amount = str(parsed_input.invoice.amount_msat)
            logging.debug(f"Input is BOLT11 invoice for {amount} msats")
        elif isinstance(parsed_input, InputType.LN_URL_PAY):
            logging.debug(f"Input is LNURL-Pay/Lightning address accepting min/max {parsed_input.data.min_sendable}/{parsed_input.data.max_sendable} msats - BIP353 was used: {parsed_input.bip353_address is not None}")
        elif isinstance(parsed_input, InputType.LN_URL_WITHDRAW):
            logging.debug(f"Input is LNURL-Withdraw for min/max {parsed_input.data.min_withdrawable}/{parsed_input.data.max_withdrawable} msats")
        # Other input types are available
    except Exception as error:
        logging.error(error)
        raise

def configure_parsers():
    mnemonic = "<mnemonic words>"

    # Create the default config, providing your Breez API key
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure external parsers
    config.external_input_parsers = [
        ExternalInputParser(
            provider_id="provider_a",
            input_regex="^provider_a",
            parser_url="https://parser-domain.com/parser?input=<input>"
        ),
        ExternalInputParser(
            provider_id="provider_b",
            input_regex="^provider_b",
            parser_url="https://parser-domain.com/parser?input=<input>"
        )
    ]

    try:
        connect_request = ConnectRequest(
            config=config,
            mnemonic=mnemonic
        )
        sdk = connect(connect_request, None)
        return sdk
    except Exception as error:
        logging.error(error)
        raise
```

## Complete CLI Example

The SDK includes a complete CLI example that shows how to build a functional application:

```python
from typing import Optional
from colorama import init as colorama_init, Style
from mnemonic import Mnemonic
from os.path import exists
from qrcode.main import QRCode
from qrcode.constants import ERROR_CORRECT_L
from breez_sdk_liquid import LiquidNetwork, PayAmount, ReceiveAmount
import argparse
import breez_sdk_liquid
import sys
import time
import os
import json

colorama_init()

class Sdk:
    """
    A wrapper class for the Breez SDK.

    This class initializes the Breez SDK, manages the mnemonic phrase,
    and provides methods to interact with the SDK.

    Attributes:
        instance: The Breez SDK instance.
        listener: An instance of SdkListener to handle SDK events.
    """

    def __init__(self, network: Optional[LiquidNetwork] = None, debug: Optional[bool] = False):
        if debug:
            breez_sdk_liquid.set_logger(SdkLogListener())

        api_key = os.getenv('BREEZ_API_KEY')
        mnemonic = self.read_mnemonic()
        config = breez_sdk_liquid.default_config(network or LiquidNetwork.TESTNET, api_key)
        connect_request = breez_sdk_liquid.ConnectRequest(config=config, mnemonic=mnemonic)
        self.instance = breez_sdk_liquid.connect(connect_request, None)
        self.listener = SdkListener()
        self.instance.add_event_listener(self.listener)

    def is_paid(self, destination: str):
        return self.listener.is_paid(destination)

    def is_synced(self):
        return self.listener.is_synced()
    
    def read_mnemonic(self):
        if exists('phrase'):
            with open('phrase') as f:
                mnemonic = f.readline()
                f.close()
                return mnemonic
        else:
            with open('phrase', 'w') as f:
                mnemo = Mnemonic("english")
                words = mnemo.generate(strength=128)
                f.write(words)
                f.close()
                return words


class SdkLogListener(breez_sdk_liquid.Logger):
    def log(self, log_entry):
        if log_entry.level != "TRACE":
            print_dim("{}: {}".format(log_entry.level, log_entry.line))


class SdkListener(breez_sdk_liquid.EventListener):
    """
    A listener class for handling Breez SDK events.

    This class extends the EventListener from breez_sdk_liquid and implements
    custom event handling logic, particularly for tracking successful payments.

    Attributes:
        paid (list): A list to store destinations of successful payments.
    """

    def __init__(self):
        """
        Initialize the SdkListener.

        Sets up an empty list to track paid destinations.
        """
        self.synced = False
        self.paid = []

    def on_event(self, event):
        if isinstance(event, breez_sdk_liquid.SdkEvent.SYNCED):
            self.synced = True
        else:
            print_dim(event)
        if isinstance(event, breez_sdk_liquid.SdkEvent.PAYMENT_SUCCEEDED):
            if event.details.destination:
                self.paid.append(event.details.destination)
    
    def is_paid(self, destination: str):
        return destination in self.paid
    
    def is_synced(self):
        return self.synced

def parse_network(network_str: str) -> LiquidNetwork:
    if network_str == 'TESTNET':
        return LiquidNetwork.TESTNET
    elif network_str == 'MAINNET':
        return LiquidNetwork.MAINNET

    raise Exception("Invalid network specified")

def parse_pay_amount(params) -> Optional[PayAmount]:
    amount_sat = getattr(params, 'amount_sat', None)
    amount = getattr(params, 'amount', None)
    asset_id = getattr(params, 'asset_id', None)
    drain = getattr(params, 'drain', None)
    asset_params = (asset_id, amount)
    if drain is True:
        return PayAmount.DRAIN
    elif amount_sat is not None:
        return PayAmount.BITCOIN(amount_sat)
    elif any(asset_params):
        if not all(asset_params):
            raise ValueError('Sending an asset requires both `asset_id` and `amount`')
        return PayAmount.ASSET(asset_id, amount)
    return None

def parse_receive_amount(params) -> Optional[ReceiveAmount]:
    amount_sat = getattr(params, 'amount_sat', None)
    amount = getattr(params, 'amount', None)
    asset_id = getattr(params, 'asset_id', None)
    if amount_sat is not None:
        return ReceiveAmount.BITCOIN(amount_sat)
    elif asset_id is not None:
        return ReceiveAmount.ASSET(asset_id, amount)
    return None

def list_payments(params):
    """
    List payments using the Breez SDK.

    This function initializes the Breez SDK and retrieves a list of payments
    based on the provided parameters. It then prints the results.

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - from_timestamp (int, optional): The start timestamp for filtering payments.
            - to_timestamp (int, optional): The end timestamp for filtering payments.
            - offset (int, optional): The number of payments to skip before starting to return results.
            - limit (int, optional): The maximum number of payments to return.

    Raises:
        Exception: If any error occurs during the process of listing payments.
    """
    sdk = Sdk(params.network, params.debug)
    try:
        req = breez_sdk_liquid.ListPaymentsRequest(from_timestamp=params.from_timestamp, 
                                                   to_timestamp=params.to_timestamp, 
                                                   offset=params.offset, 
                                                   limit=params.limit)
        res = sdk.instance.list_payments(req)
        print(*res, sep='\n\n')
    except Exception as error:
        print(error)

def receive_payment(params):
    """
    Handles the process of receiving a payment using the Breez SDK.

    This function performs the following steps:
    1. Initializes the SDK
    2. Prepares a receive request to get fee information
    3. Prompts the user to accept the fees
    4. If accepted, initiates the receive payment process
    5. Displays a QR code for the payment destination
    6. Waits for the payment to be received

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - method (str): The payment method (e.g., 'LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS')
            - amount_sat (int): The amount to receive in satoshis
            - asset_id (str): The optional id of the asset to receive
            - amount (float): The optional amount to receive of the asset

    Raises:
        Exception: If any error occurs during the payment receiving process
    """
    sdk = Sdk(params.network, params.debug)
    try:
        # Prepare the receive request to get fees
        receive_amount = parse_receive_amount(params)
        prepare_req = breez_sdk_liquid.PrepareReceiveRequest(payment_method=getattr(breez_sdk_liquid.PaymentMethod, params.method), amount=receive_amount)
        prepare_res = sdk.instance.prepare_receive_payment(prepare_req)
        # Prompt to accept fees
        accepted = input(f"Fees: {prepare_res.fees_sat} sat. Are the fees acceptable? (y/N)? : ")
        if accepted in ["Y", "y"]:
            # Receive payment
            req = breez_sdk_liquid.ReceivePaymentRequest(prepare_response=prepare_res)
            res = sdk.instance.receive_payment(req)
            if res.destination:
                print_qr(res.destination)
                print('Waiting for payment:', res.destination)
                wait_for_payment(sdk, res.destination)
    except Exception as error:
        print(error)

def send_payment(params):
    """
    Handles the process of sending a payment using the Breez SDK.

    This function performs the following steps:
    1. Initializes the SDK
    2. Prepares a send request to get fee information
    3. Prompts the user to accept the fees
    4. If accepted, initiates the send payment process
    5. Waits for the payment to be completed

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - destination (str): The bolt11 or Liquid BIP21 URI/address
            - amount_sats (int): The amount to send in satoshis
            - asset_id (str): The optional id of the asset to send
            - amount (float): The optional amount to send of the asset
            - drain: Drain all funds when sending

    Raises:
        Exception: If any error occurs during the payment sending process
    """
    sdk = Sdk(params.network, params.debug)
    try:
        # Prepare the send request to get fees
        pay_amount = parse_pay_amount(params)
        prepare_req = breez_sdk_liquid.PrepareSendRequest(destination=params.destination, amount=pay_amount)
        prepare_res = sdk.instance.prepare_send_payment(prepare_req)
        # Prompt to accept fees
        accepted = input(f"Fees: {prepare_res.fees_sat} sat. Are the fees acceptable? (Y/n)? : ")
        if accepted == "Y":
            # Send payment
            req = breez_sdk_liquid.SendPaymentRequest(prepare_response=prepare_res)
            res = sdk.instance.send_payment(req)
            if res.payment.destination:
                print('Sending payment:', res.payment.destination)
                wait_for_payment(sdk, res.payment.destination)
    except Exception as error:
        print(error)

def print_dim(data):
    print(Style.DIM)
    print(data)
    print(Style.RESET_ALL)

def print_qr(text: str):
    qr = QRCode(
        version=1,
        error_correction=ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(text)
    qr.make(fit=True)
    qr.print_ascii()

def wait_for_payment(sdk: Sdk, destination: str):
    while True:
        if sdk.is_paid(destination):
            break
        time.sleep(1)

def wait_for_synced(sdk: Sdk):
    while True:
        if sdk.is_synced():
            break
        time.sleep(1)

def get_info(params):
    sdk = Sdk(params.network, params.debug)
    wait_for_synced(sdk)
    res = sdk.instance.get_info()
    print(json.dumps(res, default=lambda x: x.__dict__, indent=2))

def main():
    if len(sys.argv) <= 1:
        sys.argv.append('--help')

    parser = argparse.ArgumentParser('Pythod SDK Example', description='Simple CLI to receive/send payments')
    parser.add_argument('-d', '--debug',
                        default=False,
                        action='store_true',
                        help='Output SDK logs')
    parser.add_argument('-n', '--network',
                        help='The network the SDK runs on, either "MAINNET" or "TESTNET"',
                        type=parse_network)
    subparser = parser.add_subparsers(title='subcommands')
    # info
    info_parser = subparser.add_parser('info', help='Get wallet info')
    info_parser.set_defaults(run=get_info)
    # list
    list_parser = subparser.add_parser('list', help='List payments')
    list_parser.add_argument('-f', '--from_timestamp', 
                                type=int, 
                                help='The optional from unix timestamp')
    list_parser.add_argument('-t', '--to_timestamp', 
                                type=int, 
                                help='The optional to unix timestamp')
    list_parser.add_argument('-o', '--offset', 
                                type=int, 
                                help='The optional offset of payments')
    list_parser.add_argument('-l', '--limit', 
                                type=int, 
                                help='The optional limit of listed payments')
    list_parser.set_defaults(run=list_payments)
    # receive
    receive_parser = subparser.add_parser('receive', help='Receive a payment')
    receive_parser.add_argument('-m', '--method', 
                                choices=['LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS'], 
                                help='The payment method', 
                                required=True)
    receive_parser.add_argument('-a', '--amount_sat', 
                                type=int, 
                                help='The optional amount to receive in sats')
    receive_parser.add_argument('--asset_id', help='The optional id of the asset to receive')
    receive_parser.add_argument('--amount', type=float, help='The optional amount to receive of the asset')
    receive_parser.set_defaults(run=receive_payment)
    # send
    send_parser = subparser.add_parser('send', help='Send a payment')
    send_parser.add_argument('-d', '--destination', help='The bolt11 or Liquid BIP21 URI/address', required=True)
    send_parser.add_argument('-a', '--amount_sat', type=int, help='The optional amount to send in sats')
    send_parser.add_argument('--asset_id', help='The optional id of the asset to send')
    send_parser.add_argument('--amount', type=float, help='The optional amount to send of the asset')
    send_parser.add_argument('--drain', default=False, action='store_true', help='Drain all funds when sending')
    send_parser.set_defaults(run=send_payment)

    args = parser.parse_args()
    args.run(args)
```


### End-User fees
#### Sending Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1.  User broadcasts an L-BTC transaction to a Liquid lockup address.
2.  Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3.  Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1.  **Lockup Transaction Fee:** ~34 sats (0.1 sat/discount vbyte).
2.  **Claim Transaction Fee:** ~19 sats (0.1 sat/discount vbyte).
3.  **Swap Service Fee:** 0.1% fee on the amount sent.

Note: swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 10k sats, the fee would be:
> 
> -   34 sats \[Lockup Transaction Fee\] + 19 sats \[Claim Transaction Fee\] + 10 sats \[Swapper Service Fee\] = 63 sats

#### Receiving Lightning Payments

Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions. The process is as follows:

1.  Sender pays the Swapper invoice.
2.  Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3.  SDK claims the funds from the Liquid lockup address and then exposes the preimage.
4.  Swapper uses the preimage to claim the funds from the Liquid lockup address.

The fee a user pays to receive a Lightning payment is composed of three parts:

1.  **Lockup Transaction Fee:** ~27 sats (0.1 sat/discount vbyte).
2.  **Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
3.  **Swap Service Fee:** 0.25% fee on the amount received.

Note: swap service fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 10k sats, the fee for the end-user would be:
> 
> -   27 sats \[Lockup Transaction Fee\] + 20 sats \[Claim Transaction Fee\] + 25 sats \[Swapper Service Fee\] = 72 sats

#### Sending to a bitcoin address

Sending to a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions. The process is as follows:

1.  SDK broadcasts an L-BTC transaction to a Liquid lockup address.
2.  Swapper broadcasts a BTC transaction to a Bitcoin lockup address.
3.  Recipient claims the funds from the Bitcoin lockup address.
4.  Swapper claims the funds from the Liquid lockup address.

The fee to send to a BTC address is composed of four parts:

1.  **L-BTC Lockup Transaction Fee**: ~34 sats (0.1 sat/discount vbyte).
2.  **BTC Lockup Transaction Fee**: the swapper charges a mining fee based on the current bitcoin mempool usage.
3.  **Swap Service Fee:** 0.1% fee on the amount sent.
4.  **BTC Claim Transaction Fee:** the SDK fees to claim BTC funds to the destination address, based on the current Bitcoin mempool usage.

Note: swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 100k sats, the mining fees returned by the Swapper are 2000 sats, and the claim fees for the user are 1000 sats—the fee would be:
> 
> -   34 sats \[Lockup Transaction Fee\] + 2000 sats \[BTC Claim Transaction Fee\] + 100 sats \[Swapper Service Fee\] + 1000 sats \[BTC Lockup Transaction Fee\] = 3132 sats

### Receiving from a BTC Address

Receiving from a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions.

The process is as follows:

1.  Sender broadcasts a BTC transaction to the Bitcoin lockup address.
2.  Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3.  SDK claims the funds from the Liquid lockup address.
4.  Swapper claims the funds from the Bitcoin lockup address.

The fee to receive from a BTC address is composed of three parts:

1.  **L-BTC Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
2.  **BTC Claim Transaction Fee:** the swapper charges a mining fee based on the Bitcoin mempool usage at the time of the swap.
3.  **Swapper Service Fee:** the swapper charges a 0.1% fee on the amount received.

Note: swapper service see is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the sender sends 100k sats and the mining fees returned by the Swapper are 2000 sats—the fee for the end-user would be:
> 
> -   20 sats \[Claim Transaction Fee\] + 100 sats \[Swapper Service Fee\] + 2000 sats \[BTC Claim Transaction Fee\] = 2120 sats
## Best Practices

### Syncing
- **Always make sure the sdk instance is synced before performing any actions**

```python 
def wait_for_synced(sdk: Sdk):
    while True:
        if sdk.is_synced():
            break
        time.sleep(1)


def main():
    sdk = Sdk(params.network, params.debug)
    wait_for_synced(sdk)
    res = sdk.instance.get_info()
    print(json.dumps({
        "walletInfo": res.wallet_info.__dict__,
        "blockchainInfo": res.blockchain_info.__dict__,
    }, indent=2))

```

### Error Handling

Always wrap your SDK method calls in try-except blocks to properly handle errors:

```python
try:
    # Call SDK method
    result = sdk.some_method()
    # Process result
except Exception as error:
    logging.error(f"An error occurred: {error}")
    # Handle the error appropriately
```

### Connection Lifecycle

Manage the connection lifecycle properly:

1. Initialize only once per session
2. Properly handle events
3. Disconnect when done

```python
# Initialize
sdk = connect(connect_request, None)

# Use SDK
# ...

# Disconnect
try:
    sdk.disconnect()
except Exception as error:
    logging.error(f"Error disconnecting: {error}")
```

### Fee Handling

Always check fees before executing payments:

```python
# Get fee information
prepare_response = sdk.prepare_send_payment(prepare_request)
fees_sat = prepare_response.fees_sat

# Check if fees are acceptable before proceeding
if fees_sat <= max_acceptable_fee:
    # Execute payment
    sdk.send_payment(SendPaymentRequest(prepare_response=prepare_response))
else:
    # Fees are too high
    logging.warning(f"Fees too high: {fees_sat} sats")
```

### Event Handling

Implement a robust event listener to handle asynchronous events:

```python
class MyEventListener(EventListener):
    def on_event(self, event):
        if isinstance(event, SdkEvent.SYNCED):
            logging.info("SDK is synced")
        elif isinstance(event, SdkEvent.PAYMENT_SUCCEEDED):
            logging.info(f"Payment succeeded: {event.details.payment_hash}")
        elif isinstance(event, SdkEvent.PAYMENT_FAILED):
            logging.error(f"Payment failed: {event.details.error}")
        # Handle other event types
```

## Troubleshooting

### Common Issues

1. **Connection Problems**
   - Check your API key
   - Verify network selection (MAINNET vs TESTNET)
   - Confirm working directory permissions

2. **Payment Issues**
   - Verify amount is within allowed limits
   - Check fee settings
   - Ensure destination is valid
   - Verify sufficient balance

3. **Event Listener Not Triggering**
   - Confirm listener is registered with `add_event_listener`
   - Check event type matching in your handler
   - Add debug logging to trace events

### Debugging

Use the SDK's built-in logging system:

```python
class DetailedLogListener(Logger):
    def log(self, log_entry):
        print(f"[{log_entry.level}] {log_entry.line}")

# Set as logger
breez_sdk_liquid.set_logger(DetailedLogListener())
```

## Security Considerations

1. **Protecting Mnemonics**
   - Never hardcode mnemonics in your code
   - Store encrypted or in secure storage
   - Consider using a custom signer for production apps

2. **API Key Security**
   - Store API keys in environment variables
   - Don't commit API keys to source control
   - Use different keys for production and testing

3. **Validating Inputs**
   - Always validate payment destinations
   - Check amounts are within reasonable limits
   - Sanitize and validate all external inputs

