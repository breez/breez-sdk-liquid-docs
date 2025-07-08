# Breez SDK Nodeless  Documentation

This comprehensive document provides all the context needed to build applications with the Rust bindings of Breez SDK Nodeless, a toolkit for integrating Bitcoin, Lightning Network, and Liquid Network functionality into your applications.

## Overview

Breez SDK Nodeless is a powerful library that allows developers to integrate Bitcoin, Lightning Network, and Liquid Network functionality into their applications. The SDK abstracts many of the complexities of working with these technologies, providing a simple interface for common operations such as sending and receiving payments, managing wallets, and interacting with both Lightning and Liquid networks.

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

```toml
# Add to your Cargo.toml
[dependencies]
breez-sdk-liquid = { git = "https://github.com/breez/breez-sdk-liquid", tag = "0.7.2" }
```

### Guidelines
- **Always make sure the SDK instance is synced before performing any actions**
- **Add logging**: Add sufficient logging into your application to diagnose any issues users are having.
- **Display pending payments**: Payments always contain a status field that can be used to determine if the payment was completed or not. Make sure you handle the case where the payment is still pending by showing the correct status to the user.
- **Enable swap refunds**: Swaps that are the result of receiving an On-Chain Transaction may not be completed and change to `Refundable` state. Make sure you handle this case correctly by allowing the user to retry the refund with different fees as long as the refund is not confirmed.
- **Expose swap fees**: When sending or receiving on-chain, make sure to clearly show the expected fees involved, as well as the send/receive amounts.

### Initializing the SDK

To get started with Breez SDK Nodeless (Liquid implementation), you need to initialize the SDK with your configuration:

```rust
use std::sync::Arc;
use anyhow::Result;
use bip39::{Language, Mnemonic};
use breez_sdk_liquid::prelude::*;
use log::info;

async fn getting_started() -> Result<Arc<LiquidSdk>> {
    let mnemonic = Mnemonic::generate_in(Language::English, 12)?;

    // Create the default config, providing your Breez API key
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Customize the config object according to your needs
    config.working_dir = "path to an existing directory".into();

    let connect_request = ConnectRequest {
        config,
        mnemonic: Some(mnemonic.to_string()),
        passphrase: None,
        seed: None,
    };
    let sdk = LiquidSdk::connect(connect_request).await?;
    
    Ok(sdk)
}
```

### Custom Signer Support

If you prefer to manage your own keys, you can use a custom signer:

```rust
use std::sync::Arc;
use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn connect_with_self_signer(signer: Signer) -> Result<Arc<LiquidSdk>> {  
    // Create the default config, providing your Breez API key
    let mut config = LiquidSdk::default_config(LiquidNetwork::Mainnet, Some("<your-Breez-API-key>".to_string()))?;

    // Customize the config object according to your needs
    config.working_dir = "path to an existing directory".into();

    let connect_request = ConnectWithSignerRequest {      
        config,
    };
    let sdk = LiquidSdk::connect_with_signer(connect_request, signer).await?;

    Ok(sdk)
}
```

### Basic Operations

#### Fetch Balance
- **Always make sure the SDK instance is synced before performing any actions**

```rust
async fn fetch_balance(sdk: Arc<LiquidSdk>) -> Result<()> {
    let info = sdk.get_info().await?;
    let balance_sat = info.wallet_info.balance_sat;
    let pending_send_sat = info.wallet_info.pending_send_sat;
    let pending_receive_sat = info.wallet_info.pending_receive_sat;
    
    Ok(())
}
```

#### Logging and Event Handling

```rust
// Define an event listener
struct CliEventListener {}
impl EventListener for CliEventListener {
    fn on_event(&self, e: SdkEvent) {
        info!("Received event: {:?}", e);
    }
}

async fn add_event_listener(
    sdk: Arc<LiquidSdk>,
    listener: Box<CliEventListener>,
) -> Result<String> {
    let listener_id = sdk.add_event_listener(listener).await?;
    Ok(listener_id)
}

// Remove an event listener
async fn remove_event_listener(sdk: Arc<LiquidSdk>, listener_id: String) -> Result<()> {
    sdk.remove_event_listener(listener_id).await?;
    Ok(())
}

// Disconnect from the SDK
async fn disconnect(sdk: Arc<LiquidSdk>) -> Result<()> {
    sdk.disconnect().await?;
    Ok(())
}
```

## Core Features

### Buying Bitcoin

```rust
async fn fetch_onchain_limits(sdk: Arc<LiquidSdk>) -> Result<OnchainPaymentLimitsResponse> {
    let current_limits = sdk.fetch_onchain_limits().await?;

    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);
    
    Ok(current_limits)
}

async fn prepare_buy_bitcoin(
    sdk: Arc<LiquidSdk>,
    current_limits: OnchainPaymentLimitsResponse,
) -> Result<PrepareBuyBitcoinResponse> {
    let prepare_response = sdk
        .prepare_buy_bitcoin(PrepareBuyBitcoinRequest {
            provider: BuyBitcoinProvider::Moonpay,
            amount_sat: current_limits.receive.min_sat,
        })
        .await?;

    // Check the fees are acceptable before proceeding
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    
    Ok(prepare_response)
}

async fn buy_bitcoin(
    sdk: Arc<LiquidSdk>,
    prepare_response: PrepareBuyBitcoinResponse,
) -> Result<String> {
    let url = sdk.buy_bitcoin(BuyBitcoinRequest {
        prepare_response,
        redirect_url: None,
    })
    .await?;
    
    Ok(url)
}
```

### Fiat Currencies

```rust
async fn list_supported_fiat_currencies(sdk: Arc<LiquidSdk>) -> Result<()> {
    let supported_fiat_currencies = sdk.list_fiat_currencies().await?;
    Ok(())
}

async fn get_current_rates(sdk: Arc<LiquidSdk>) -> Result<()> {
    let fiat_rates = sdk.fetch_fiat_rates().await?;
    Ok(())
}
```

### Sending Payments

#### Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1. User broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3. Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~34 sats (0.1 sat/discount vbyte).
2. **Claim Transaction Fee:** ~19 sats (0.1 sat/discount vbyte).
3. **Swap Service Fee:** 0.1% fee on the amount sent.

Note: swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 10k sats, the fee would be:
> 
> - 34 sats [Lockup Transaction Fee] + 19 sats [Claim Transaction Fee] + 10 sats [Swapper Service Fee] = 63 sats

```rust
async fn prepare_send_payment_lightning_bolt11(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Set the bolt11 invoice you wish to pay
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<bolt11 invoice>".to_string(),
            amount: None,
            comment: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    
    Ok(())
}

async fn prepare_send_payment_lightning_bolt12(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Set the bolt12 offer you wish to pay to
    let optional_amount = Some(PayAmount::Bitcoin {
        receiver_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<bolt12 offer>".to_string(),
            amount: optional_amount,
        })
        .await?;
        
    Ok(())
}
```

#### Liquid Payments

```rust
async fn prepare_send_payment_liquid(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optional_amount = Some(PayAmount::Bitcoin {
        receiver_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount: optional_amount,
            comment: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    
    Ok(())
}

async fn prepare_send_payment_liquid_drain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Set the Liquid BIP21 or Liquid address you wish to pay
    let optional_amount = Some(PayAmount::Drain);
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount: optional_amount,
            comment: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    
    Ok(())
}
```

#### Execute Payment

For BOLT12 payments you can also include an optional payer note, which will be included in the invoice.

- **Always make sure the SDK instance is synced before performing any actions**

```rust
async fn send_payment(sdk: Arc<LiquidSdk>, prepare_response: PrepareSendResponse) -> Result<()> {
    let optional_payer_note = Some("<payer note>".to_string());
    let send_response = sdk
        .send_payment(&SendPaymentRequest {
            prepare_response,
            use_asset_fees: None,
            payer_note: optional_payer_note,
        })
        .await?;
    let payment = send_response.payment;
    
    Ok(())
}
```

### Receiving Payments
**Always make sure the SDK instance is synced before performing any actions**

#### Lightning Payments
Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions. The process is as follows:

1. Sender pays the Swapper invoice.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address and then exposes the preimage.
4. Swapper uses the preimage to claim the funds from the Liquid lockup address.

The fee a user pays to receive a Lightning payment is composed of three parts:

1. **Lockup Transaction Fee:** ~27 sats (0.1 sat/discount vbyte).
2. **Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
3. **Swap Service Fee:** 0.25% fee on the amount received.

Note: swap service fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 10k sats, the fee for the end-user would be:
> 
> - 27 sats [Lockup Transaction Fee] + 20 sats [Claim Transaction Fee] + 25 sats [Swapper Service Fee] = 72 sats

```rust
async fn prepare_receive_lightning(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Fetch the Receive lightning limits
    let current_limits = sdk.fetch_lightning_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::Lightning,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    
    Ok(())
}
```

#### Onchain Payments

```rust
async fn prepare_receive_onchain(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Fetch the Receive onchain limits
    let current_limits = sdk.fetch_onchain_limits().await?;
    info!("Minimum amount: {} sats", current_limits.receive.min_sat);
    info!("Maximum amount: {} sats", current_limits.receive.max_sat);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::BitcoinAddress,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    
    Ok(())
}
```

#### Liquid Payments

```rust
async fn prepare_receive_liquid(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    // Note: Not setting the amount will generate a plain Liquid address
    let optional_amount = Some(ReceiveAmount::Bitcoin {
        payer_amount_sat: 5_000,
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::LiquidAddress,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    
    Ok(())
}
```

#### Execute Receive

```rust
async fn receive_payment(sdk: Arc<LiquidSdk>, prepare_response: PrepareReceiveResponse) -> Result<()> {
    let optional_description = Some("<description>".to_string());
    let res = sdk
        .receive_payment(&ReceivePaymentRequest {
            prepare_response,
            description: optional_description,
            use_description_hash: None,
        })
        .await?;

    let destination = res.destination;
    
    Ok(())
}
```

### LNURL Operations

#### LNURL Authentication

```rust
async fn auth(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Endpoint can also be of the form:
    // keyauth://domain.com/auth?key=val
    let lnurl_auth_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";

    if let Ok(InputType::LnUrlAuth { data: ad }) = sdk.parse(lnurl_auth_url).await {
        match sdk.lnurl_auth(ad).await {
            Ok(LnUrlCallbackStatus::Ok) => {
                info!("Successfully authenticated")
            }
            Ok(LnUrlCallbackStatus::ErrorStatus { data }) => {
                error!("Failed to authenticate: {}", data.reason)
            }
            Err(e) => {
                error!("Failed to connect: {e}")
            }
        }
    }
    
    Ok(())
}
```

#### LNURL Pay

```rust
async fn prepare_pay(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    let lnurl_pay_url = "lightning@address.com";

    if let Ok(InputType::LnUrlPay { data, bip353_address }) = sdk.parse(lnurl_pay_url).await {
        let amount = PayAmount::Bitcoin {
            receiver_amount_sat: 5_000,
        };
        let optional_comment = Some("<comment>".to_string());
        let optional_validate_success_action_url = Some(true);

        let prepare_response = sdk
            .prepare_lnurl_pay(PrepareLnUrlPayRequest {
                data,
                amount,
                bip353_address,
                comment: optional_comment,
                validate_success_action_url: optional_validate_success_action_url,
            })
            .await?;

        // If the fees are acceptable, continue to create the LNURL Pay
        let fees_sat = prepare_response.fees_sat;
        info!("Fees: {} sats", fees_sat);
    }
    
    Ok(())
}

async fn pay(sdk: Arc<LiquidSdk>, prepare_response: PrepareLnUrlPayResponse) -> Result<()> {
    let result = sdk.lnurl_pay(LnUrlPayRequest { prepare_response }).await?;
    
    Ok(())
}
```

#### LNURL Withdraw

```rust
async fn withdraw(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Endpoint can also be of the form:
    // lnurlw://domain.com/lnurl-withdraw?key=val
    let lnurl_withdraw_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk";

    if let Ok(InputType::LnUrlWithdraw { data: wd }) = sdk.parse(lnurl_withdraw_url).await {
        let amount_msat = wd.min_withdrawable;
        let description = "Test withdraw".to_string();

        sdk.lnurl_withdraw(LnUrlWithdrawRequest {
            data: wd,
            amount_msat,
            description: Some(description),
        })
        .await?;
    }
    
    Ok(())
}
```

### Onchain Operations

#### Pay Onchain

```rust
async fn get_current_limits(sdk: Arc<LiquidSdk>) -> Result<()> {
    let current_limits = sdk.fetch_onchain_limits().await?;

    info!("Minimum amount: {} sats", current_limits.send.min_sat);
    info!("Maximum amount: {} sats", current_limits.send.max_sat);

    Ok(())
}

async fn prepare_pay_onchain(sdk: Arc<LiquidSdk>) -> Result<()> {
    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayAmount::Bitcoin {
                receiver_amount_sat: 5_000,
            },
            fee_rate_sat_per_vbyte: None,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let total_fees_sat = prepare_res.total_fees_sat;
    
    Ok(())
}

async fn prepare_pay_onchain_fee_rate(sdk: Arc<LiquidSdk>) -> Result<()> {
    let optional_sat_per_vbyte = Some(21);

    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayAmount::Bitcoin {
                receiver_amount_sat: 5_000,
            },
            fee_rate_sat_per_vbyte: optional_sat_per_vbyte,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let claim_fees_sat = prepare_res.claim_fees_sat;
    let total_fees_sat = prepare_res.total_fees_sat;
    
    Ok(())
}

async fn start_pay_onchain(
    sdk: Arc<LiquidSdk>,
    prepare_response: PreparePayOnchainResponse,
) -> Result<()> {
    let destination_address = String::from("bc1..");

    sdk.pay_onchain(&PayOnchainRequest {
        address: destination_address,
        prepare_response,
    })
    .await?;
    
    Ok(())
}
```

#### Drain Funds

```rust
async fn prepare_pay_onchain_drain(sdk: Arc<LiquidSdk>) -> Result<()> {
    let prepare_res = sdk
        .prepare_pay_onchain(&PreparePayOnchainRequest {
            amount: PayAmount::Drain,
            fee_rate_sat_per_vbyte: None,
        })
        .await?;

    // Check if the fees are acceptable before proceeding
    let total_fees_sat = prepare_res.total_fees_sat;
    
    Ok(())
}
```

#### Receive Onchain

```rust
async fn list_refundables(sdk: Arc<LiquidSdk>) -> Result<()> {
    let refundables = sdk.list_refundables().await?;
    
    Ok(())
}

async fn execute_refund(
    sdk: Arc<LiquidSdk>,
    refund_tx_fee_rate: u32,
    refundable: RefundableSwap,
) -> Result<()> {
    let destination_address = "...".into();
    let fee_rate_sat_per_vbyte = refund_tx_fee_rate;

    sdk.refund(&RefundRequest {
        swap_address: refundable.swap_address,
        refund_address: destination_address,
        fee_rate_sat_per_vbyte,
    })
    .await?;
    
    Ok(())
}

async fn rescan_swaps(sdk: Arc<LiquidSdk>) -> Result<()> {
    sdk.rescan_onchain_swaps().await?;
    
    Ok(())
}

async fn recommended_fees(sdk: Arc<LiquidSdk>) -> Result<()> {
    let fees = sdk.recommended_fees().await?;
    
    Ok(())
}
```

#### Handle Fee Acceptance

```rust
async fn handle_payments_waiting_fee_acceptance(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
    let payments_waiting_fee_acceptance = sdk
        .list_payments(&ListPaymentsRequest {
            states: Some(vec![PaymentState::WaitingFeeAcceptance]),
            ..Default::default()
        })
        .await?;

    for payment in payments_waiting_fee_acceptance {
        let PaymentDetails::Bitcoin { swap_id, .. } = payment.details else {
            // Only Bitcoin payments can be `WaitingFeeAcceptance`
            continue;
        };

        let fetch_fees_response = sdk
            .fetch_payment_proposed_fees(&FetchPaymentProposedFeesRequest { swap_id })
            .await?;

        info!(
            "Payer sent {} and currently proposed fees are {}",
            fetch_fees_response.payer_amount_sat, fetch_fees_response.fees_sat
        );

        // If the user is ok with the fees, accept them, allowing the payment to proceed
        sdk.accept_payment_proposed_fees(&AcceptPaymentProposedFeesRequest {
            response: fetch_fees_response,
        })
        .await?;
    }
    
    Ok(())
}
```

### Non-Bitcoin Assets

```rust
async fn prepare_receive_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Create a Liquid BIP21 URI/address to receive an asset payment to.
    // Note: Not setting the amount will generate an amountless BIP21 URI.
    let usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let optional_amount = Some(ReceiveAmount::Asset {
        asset_id: usdt_asset_id,
        payer_amount: Some(1.50),
    });
    let prepare_response = sdk
        .prepare_receive_payment(&PrepareReceiveRequest {
            payment_method: PaymentMethod::LiquidAddress,
            amount: optional_amount,
        })
        .await?;

    // If the fees are acceptable, continue to create the Receive Payment
    let receive_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", receive_fees_sat);
    
    Ok(())
}

async fn prepare_send_payment_asset(sdk: Arc<LiquidSdk>) -> Result<()> {
    // Set the Liquid BIP21 or Liquid address you wish to pay
    // If the destination is an address or an amountless BIP21 URI,
    // you must specifiy an asset amount
    let usdt_asset_id = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2".to_string();
    let optional_amount = Some(PayAmount::Asset {
        asset_id: usdt_asset_id,
        receiver_amount: Some(1.50),
        estimate_asset_fees: None,
    });
    let prepare_response = sdk
        .prepare_send_payment(&PrepareSendRequest {
            destination: "<Liquid BIP21 or address>".to_string(),
            amount: optional_amount,
            comment: None,
        })
        .await?;

    // If the fees are acceptable, continue to create the Send Payment
    let send_fees_sat = prepare_response.fees_sat;
    info!("Fees: {} sats", send_fees_sat);
    
    Ok(())
}

fn configure_asset_metadata() -> Result<LiquidNetwork, Config> {
    // Create the default config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure asset metadata
    config.asset_metadata = Some(vec![
        AssetMetadata {
            asset_id: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec".to_string(),
            name: "PEGx EUR".to_string(),
            ticker: "EURx".to_string(),
            precision: 8,
        },
    ]);
    
    Ok(config)
}

async fn fetch_asset_balance(sdk: Arc<LiquidSdk>) -> Result<()> {
    let info = sdk.get_info().await?;
    let asset_balances = info.wallet_info.asset_balances;
    
    Ok(())
}
```

### Messages and Signing

```rust
async fn sign_message(sdk: Arc<LiquidSdk>) -> Result<()> {
    let sign_message_request = SignMessageRequest {
        message: "<message to sign>".to_string(),
    };
    let sign_message_response = sdk
        .sign_message(&sign_message_request)?;

    // Get the wallet info for your pubkey
    let info = sdk.get_info().await?;

    let signature = sign_message_response.signature;
    let pubkey = info.wallet_info.pubkey;

    info!("Pubkey: {}", pubkey);
    info!("Signature: {}", signature);
    
    Ok(())
}

fn check_message(sdk: Arc<LiquidSdk>) -> Result<()> {
    let check_message_request = CheckMessageRequest {
        message: "<message>".to_string(),
        pubkey: "<pubkey of signer>".to_string(),
        signature: "<message signature>".to_string(),
    };
    let check_message_response = sdk
        .check_message(&check_message_request)?;

    let is_valid = check_message_response.is_valid;

    info!("Signature valid: {}", is_valid);
    
    Ok(())
}
```

### List Payments

```rust
async fn get_payment(sdk: Arc<LiquidSdk>) -> Result<Option<Payment>> {
    let payment_hash = "<payment hash>".to_string();
    let payment = sdk
        .get_payment(&GetPaymentRequest::PaymentHash { payment_hash })
        .await?;

    let swap_id = "<swap id>".to_string();
    let payment = sdk
        .get_payment(&GetPaymentRequest::SwapId { swap_id })
        .await?;
        
    Ok(payment)
}

async fn list_payments(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    let payments = sdk.list_payments(&ListPaymentsRequest::default()).await?;
    
    Ok(payments)
}

async fn list_payments_filtered(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: Some(vec![PaymentType::Send]),
            states: None,
            from_timestamp: Some(1696880000),
            to_timestamp: Some(1696959200),
            offset: Some(0),
            limit: Some(50),
            details: None,
            sort_ascending: None,
        })
        .await?;
        
    Ok(payments)
}

async fn list_payments_details_address(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    let address = Some("<Bitcoin address>".to_string());
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: None,
            states: None,
            from_timestamp: None,
            to_timestamp: None,
            offset: None,
            limit: None,
            details: Some(ListPaymentDetails::Bitcoin { address }),
            sort_ascending: None,
        })
        .await?;
        
    Ok(payments)
}

async fn list_payments_details_destination(sdk: Arc<LiquidSdk>) -> Result<Vec<Payment>> {
    let destination = Some("<Liquid BIP21 or address>".to_string());
    let payments = sdk
        .list_payments(&ListPaymentsRequest {
            filters: None,
            states: None,
            from_timestamp: None,
            to_timestamp: None,
            offset: None,
            limit: None,
            details: Some(ListPaymentDetails::Liquid {
                asset_id: None,
                destination,
            }),
            sort_ascending: None,
        })
        .await?;
        
    Ok(payments)
}
```

### Webhook Integration

```rust
async fn register_webhook(sdk: Arc<LiquidSdk>) -> Result<()> {
    sdk.register_webhook(
        "https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>".to_string(),
    )
    .await?;
    
    Ok(())
}

async fn unregister_webhook(sdk: Arc<LiquidSdk>) -> Result<()> {
    sdk.unregister_webhook().await?;
    
    Ok(())
}
```

### Input Parsing

```rust
async fn parse_input(sdk: Arc<LiquidSdk>) -> Result<()> {
    let input = "an input to be parsed...";

    match sdk.parse(input).await? {
        InputType::BitcoinAddress { address } => {
            println!("Input is Bitcoin address {}", address.address);
        }
        InputType::Bolt11 { invoice } => {
            println!(
                "Input is BOLT11 invoice for {} msats",
                invoice
                    .amount_msat
                    .map_or("unknown".to_string(), |a| a.to_string())
            );
        }
        InputType::LnUrlPay { data, bip353_address } => {
            println!(
                "Input is LNURL-Pay/Lightning address accepting min/max {}/{} msats - BIP353 was used: {}",
                data.min_sendable, data.max_sendable, bip353_address.is_some()
            );
        }
        InputType::LnUrlWithdraw { data } => {
            println!(
                "Input is LNURL-Withdraw for min/max {}/{} msats",
                data.min_withdrawable, data.max_withdrawable
            );
        }
        // Other input types are available
        _ => {}
    }
    
    Ok(())
}

async fn configure_parsers() -> Result<Arc<LiquidSdk>> {
    let mnemonic = Mnemonic::generate_in(Language::English, 12)?;

    // Create the default config, providing your Breez API key
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("<your-Breez-API-key>".to_string()),
    )?;

    // Configure external parsers
    config.external_input_parsers = Some(vec![
        ExternalInputParser {
            provider_id: "provider_a".to_string(),
            input_regex: "^provider_a".to_string(),
            parser_url: "https://parser-domain.com/parser?input=<input>".to_string(),
        },
        ExternalInputParser {
            provider_id: "provider_b".to_string(),
            input_regex: "^provider_b".to_string(),
            parser_url: "https://parser-domain.com/parser?input=<input>".to_string(),
        },
    ]);

    let connect_request = ConnectRequest {
        config,
        mnemonic: Some(mnemonic.to_string()),
        passphrase: None,
        seed: None,
    };
    let sdk = LiquidSdk::connect(connect_request).await?;
    
    Ok(sdk)
}
```

## Complete CLI Example

The SDK includes a complete CLI example that shows how to build a functional application. Here is a simplified version:

```rust
// main.rs
use std::sync::Arc;
use anyhow::Result;
use breez_sdk_liquid::prelude::*;
use tokio::time;
use clap::{Parser, Subcommand};

struct AppEventListener {
    synced: bool,
    paid_destinations: Vec<String>,
}

impl EventListener for AppEventListener {
    fn on_event(&self, e: SdkEvent) {
        match e {
            SdkEvent::Synced => println!("SDK is synced"),
            SdkEvent::PaymentSucceeded { details } => {
                println!("Payment succeeded: {:?}", details.payment_hash);
            },
            SdkEvent::PaymentFailed { details } => {
                println!("Payment failed: {:?}", details.payment_hash);
            },
            // Handle other events
            _ => println!("Received event: {:?}", e),
        }
    }
}

#[derive(Parser)]
#[command(name = "breez-sdk-cli")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Get wallet info
    Info,
    /// Send a payment
    Send {
        #[arg(short, long)]
        destination: String,
        #[arg(short, long)]
        amount_sat: Option<u64>,
    },
    /// Receive a payment
    Receive {
        #[arg(short, long)]
        method: String,
        #[arg(short, long)]
        amount_sat: Option<u64>,
    },
    /// List payments
    List,
}

async fn initialize_sdk() -> Result<Arc<LiquidSdk>> {
    // Load or generate mnemonic
    let mnemonic = "your mnemonic words here";
    
    // Create config
    let mut config = LiquidSdk::default_config(
        LiquidNetwork::Mainnet,
        Some("your-breez-api-key".to_string()),
    )?;
    config.working_dir = "./.breez_data".into();
    
    // Connect to SDK
    let sdk = LiquidSdk::connect(ConnectRequest {
        config,
        mnemonic: Some(mnemonic.to_string()),
        passphrase: None,
        seed: None,
    }).await?;
    
    // Add event listener
    let listener = Box::new(AppEventListener {
        synced: false,
        paid_destinations: vec![],
    });
    sdk.add_event_listener(listener).await?;
    
    // Wait for sync
    time::sleep(time::Duration::from_secs(2)).await;
    
    Ok(sdk)
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();
    let sdk = initialize_sdk().await?;
    
    match cli.command {
        Commands::Info => {
            let info = sdk.get_info().await?;
            println!("Balance: {} sats", info.wallet_info.balance_sat);
            println!("Pending send: {} sats", info.wallet_info.pending_send_sat);
            println!("Pending receive: {} sats", info.wallet_info.pending_receive_sat);
        },
        Commands::Send { destination, amount_sat } => {
            let amount = amount_sat.map(|amt| PayAmount::Bitcoin { receiver_amount_sat: amt });
            
            // Prepare payment
            let prepare_response = sdk.prepare_send_payment(&PrepareSendRequest {
                destination,
                amount,
                comment: None,
            }).await?;
            
            // Send payment
            let response = sdk.send_payment(&SendPaymentRequest {
                prepare_response,
                use_asset_fees: None,
            }).await?;
            
            println!("Payment sent: {:?}", response.payment);
        },
        Commands::Receive { method, amount_sat } => {
            let payment_method = match method.as_str() {
                "lightning" => PaymentMethod::Lightning,
                "bitcoin" => PaymentMethod::BitcoinAddress,
                "liquid" => PaymentMethod::LiquidAddress,
                _ => return Err(anyhow::anyhow!("Invalid payment method")),
            };
            
            let amount = amount_sat.map(|amt| ReceiveAmount::Bitcoin { payer_amount_sat: amt });
            
            // Prepare receive
            let prepare_response = sdk.prepare_receive_payment(&PrepareReceiveRequest {
                payment_method,
                amount,
            }).await?;
            
            // Receive payment
            let response = sdk.receive_payment(&ReceivePaymentRequest {
                prepare_response,
                description: Some("Payment received via CLI".to_string()),
                use_description_hash: None,
            }).await?;
            
            println!("Payment destination: {}", response.destination);
        },
        Commands::List => {
            let payments = sdk.list_payments(&ListPaymentsRequest::default()).await?;
            for payment in payments {
                println!("{}: {} sats, status: {:?}", 
                         payment.payment_type,
                         payment.amount_sat,
                         payment.status);
            }
        },
    }
    
    // Disconnect SDK when done
    sdk.disconnect().await?;
    
    Ok(())
}
```

### End-User fees
#### Sending Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is as follows:

1.  User broadcasts an L-BTC transaction to a Liquid lockup address.
2.  Swapper pays the invoice, sending to the recipient, and then gets a preimage.
3.  Swapper broadcasts an L-BTC transaction to claim the funds from the Liquid lockup address.

The fee a user pays to send a Lightning payment is composed of three parts:

1.  **Lockup Transaction Fee:** ~34 sats (0.1 sat/discount vbyte).
2.  **Claim Transaction Fee:** ~19 sats (0.1 sat/discount vbyte).
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

1.  **Lockup Transaction Fee:** ~27 sats (0.1 sat/discount vbyte).
2.  **Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
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

1.  **L-BTC Lockup Transaction Fee**: ~34 sats (0.1 sat/discount vbyte).
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

1.  **L-BTC Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
2.  **BTC Claim Transaction Fee:** the swapper charges a mining fee based on the Bitcoin mempool usage at the time of the swap.
3.  **Swapper Service Fee:** the swapper charges a 0.1% fee on the amount received.

Note: swapper service see is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the sender sends 100k sats and the mining fees returned by the Swapper are 2000 sats—the fee for the end-user would be:
> 
> -   20 sats \[Claim Transaction Fee\] + 100 sats \[Swapper Service Fee\] + 2000 sats \[BTC Claim Transaction Fee\] = 2120 sats

## Best Practices

### Syncing
- **Always make sure the SDK instance is synced before performing any actions**

```rust
async fn wait_for_synced(sdk: Arc<LiquidSdk>) {
    let mut events_stream = sdk.event_manager.subscribe();
    
    loop {
        match events_stream.recv().await {
            Ok(SdkEvent::Synced) => break,
            Ok(_) => continue,
            Err(_) => break,
        }
    }
}

async fn main() {
    let sdk = initialize_sdk().await.unwrap();
    wait_for_synced(sdk.clone()).await;
    
    // Now the SDK is synced and ready to use
    let info = sdk.get_info().await.unwrap();
    println!("Balance: {} sats", info.wallet_info.balance_sat);
}
```

### Error Handling

Always wrap your SDK method calls in proper error handling:

```rust
async fn safe_operation(sdk: Arc<LiquidSdk>) -> Result<()> {
    match sdk.get_info().await {
        Ok(info) => {
            println!("Successfully retrieved balance: {} sats", info.wallet_info.balance_sat);
            Ok(())
        },
        Err(e) => {
            log::error!("Failed to get wallet info: {}", e);
            Err(anyhow::anyhow!("Operation failed: {}", e))
        }
    }
}
```

### Connection Lifecycle

Manage the connection lifecycle properly:

1. Initialize only once per session
2. Properly handle events
3. Disconnect when done

```rust
async fn session() -> Result<()> {
    // Initialize SDK
    let sdk = initialize_sdk().await?;
    
    // Use SDK
    let info = sdk.get_info().await?;
    println!("Balance: {} sats", info.wallet_info.balance_sat);
    
    // Disconnect
    sdk.disconnect().await?;
    
    Ok(())
}
```

### Fee Handling

Always check fees before executing payments:

```rust
async fn safe_payment(sdk: Arc<LiquidSdk>, destination: String, amount_sat: u64, max_fee_sat: u64) -> Result<()> {
    let prepare_response = sdk.prepare_send_payment(&PrepareSendRequest {
        destination,
        amount: Some(PayAmount::Bitcoin { receiver_amount_sat: amount_sat }),
        comment: None,
    }).await?;
    
    // Check if fees are acceptable
    if let Some(fees_sat) = prepare_response.fees_sat {
        if fees_sat <= max_fee_sat {
            // Execute payment
            sdk.send_payment(&SendPaymentRequest { prepare_response }).await?;
            Ok(())
        } else {
            // Fees too high
            Err(anyhow::anyhow!("Fees too high: {} sats (max: {} sats)", fees_sat, max_fee_sat))
        }
    } else {
        Err(anyhow::anyhow!("Fees not available"))
    }
}
```

### Event Handling

Implement a robust event listener to handle asynchronous events:

```rust
struct AppEventListener {
    synced: bool,
    payments: Vec<String>,
}

impl EventListener for AppEventListener {
    fn on_event(&self, e: SdkEvent) {
        match e {
            SdkEvent::Synced => {
                println!("SDK is synced");
            },
            SdkEvent::PaymentSucceeded { details } => {
                println!("Payment succeeded: {}", details.payment_hash.unwrap_or_default());
            },
            SdkEvent::PaymentFailed { details } => {
                println!("Payment failed: {}", details.error.unwrap_or_default());
            },
            // Handle other events
            _ => println!("Received event: {:?}", e),
        }
    }
}
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

```rust
// Initialize SDK logging
LiquidSdk::init_logging(&data_dir_path, None)?;
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