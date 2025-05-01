# Breez SDK Nodeless (Liquid implementation) Documentation for WebAssembly

This comprehensive document provides all the context needed to build web applications with the WebAssembly bindings of Breez SDK Nodeless, a toolkit for integrating Bitcoin, Lightning Network, and Liquid Network functionality.

## Overview

Breez SDK Nodeless (Liquid implementation) allows developers to integrate Bitcoin, Lightning Network, and Liquid Network functionality into web applications. The SDK abstracts many complexities, providing a simple interface for common operations such as sending and receiving payments, managing wallets, and interacting with both Lightning and Liquid networks.

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
npm install @breeztech/breez-sdk-liquid
```

### Initializing the SDK

To get started with Breez SDK Nodeless (Liquid implementation) in the browser, you need to initialize the WASM module and connect with your configuration:

```typescript
import init, { defaultConfig, connect } from '@breeztech/breez-sdk-liquid/web';

const initWallet = async () => {
  // Initialize the WASM module first
  await init();

  // Your mnemonic seed phrase for wallet recovery
  const mnemonic = "<mnemonic words>";

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>');

  // Customize the config object according to your needs
  // The workingDir doesn't need to be set in web environments
  config.workingDir = 'path to writable directory';

  try {
    const sdk = await connect({ 
      config, 
      mnemonic 
    });
    return sdk;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

### Custom Signer Support

If you prefer to manage your own keys, you can use a custom signer:

```typescript
import { connectWithSigner, defaultConfig } from '@breeztech/breez-sdk-liquid/web';

const connectWithCustomSigner = async () => {
  // Fully implement the Signer interface
  class JsSigner {
    xpub = (): number[] => { return [] }
    deriveXpub = (derivationPath: string): number[] => { return [] }
    signEcdsa = (msg: number[], derivationPath: string): number[] => { return [] }
    signEcdsaRecoverable = (msg: number[]): number[] => { return [] }
    slip77MasterBlindingKey = (): number[] => { return [] }
    hmacSha256 = (msg: number[], derivationPath: string): number[] => { return [] }
    eciesEncrypt = (msg: number[]): number[] => { return [] }
    eciesDecrypt = (msg: number[]): number[] => { return [] }
  }

  const signer = new JsSigner();

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>');

  const sdk = await connectWithSigner({ config }, signer);

  return sdk;
};
```

### Guidelines
- **Always make sure the sdk instance is synced before performing any actions**
- **Add logging**: Add sufficient logging to diagnose any issues users have
- **Display pending payments**: Payments always contain a status field to determine completion. Show the correct status to users.
- **Enable swap refunds**: Swaps resulting from On-Chain Transactions may not complete and change to `Refundable` state. Handle this by allowing the user to retry the refund with different fees until confirmed.
- **Expose swap fees**: When sending or receiving on-chain, clearly show the expected fees and amounts.

### Basic Operations

#### Setting Up Logging

```typescript
import { setLogger } from '@breeztech/breez-sdk-liquid/web';

const setupLogging = () => {
  class JsLogger {
    log = (l) => {
      console.log(`[${l.level}]: ${l.line}`);
    }
  }

  const logger = new JsLogger();
  setLogger(logger);
};
```

#### Event Handling

```typescript
import { SdkEvent } from '@breeztech/breez-sdk-liquid/web';

const setupEventListener = async (sdk) => {
  class JsEventListener {
    onEvent = (event: SdkEvent) => {
      console.log(`Received event: ${JSON.stringify(event)}`);
    }
  }

  const eventListener = new JsEventListener();
  const listenerId = await sdk.addEventListener(eventListener);
  
  // Save the listenerId to remove the listener later
  return listenerId;
};

const removeEventListener = async (sdk, listenerId) => {
  await sdk.removeEventListener(listenerId);
};
```

#### Fetch Balance

```typescript
const fetchBalance = async (sdk) => {
  try {
    const info = await sdk.getInfo();
    const balanceSat = info.walletInfo.balanceSat;
    const pendingSendSat = info.walletInfo.pendingSendSat;
    const pendingReceiveSat = info.walletInfo.pendingReceiveSat;
    console.log(`Balance: ${balanceSat} sats`);
  } catch (error) {
    console.error(error);
  }
};
```

## Core Features

### Buying Bitcoin

```typescript
const fetchOnchainLimits = async (sdk) => {
  try {
    const currentLimits = await sdk.fetchOnchainLimits();
    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`);
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`);
    return currentLimits;
  } catch (err) {
    console.error(err);
  }
};

const prepareBuyBtc = async (sdk, currentLimits) => {
  try {
    const prepareRes = await sdk.prepareBuyBitcoin({
      provider: 'moonpay',
      amountSat: currentLimits.receive.minSat
    });

    // Check the fees are acceptable before proceeding
    const receiveFeesSat = prepareRes.feesSat;
    console.log(`Fees: ${receiveFeesSat} sats`);
    return prepareRes;
  } catch (err) {
    console.error(err);
  }
};

const buyBtc = async (sdk, prepareResponse) => {
  try {
    const url = await sdk.buyBitcoin({
      prepareResponse
    });
    // Redirect user to url to complete purchase
  } catch (err) {
    console.error(err);
  }
};
```

### Fiat Currencies

```typescript
const listFiatCurrencies = async (sdk) => {
  const fiatCurrencies = await sdk.listFiatCurrencies();
  return fiatCurrencies;
};

const fetchFiatRates = async (sdk) => {
  const fiatRates = await sdk.fetchFiatRates();
  return fiatRates;
};
```

### Sending Payments

#### Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions. The process is:

1. User broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper pays the invoice, sending to the recipient, and gets a preimage.
3. Swapper broadcasts an L-BTC transaction to claim funds from the Liquid lockup address.

The fee components:
- Lockup Transaction Fee: ~34 sats (0.1 sat/discount vbyte)
- Claim Transaction Fee: ~19 sats (0.1 sat/discount vbyte)
- Swap Service Fee: 0.1% of the amount sent (dynamic)

```typescript
const prepareSendPaymentLightningBolt11 = async (sdk) => {
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<bolt11 invoice>'
  });

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat;
  console.log(`Fees: ${sendFeesSat} sats`);
  return prepareResponse;
};

const prepareSendPaymentLightningBolt12 = async (sdk) => {
  // Set the bolt12 offer you wish to pay
  const optionalAmount = {
    type: 'bitcoin',
    receiverAmountSat: 5_000
  };

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<bolt12 offer>',
    amount: optionalAmount
  });
  
  return prepareResponse;
};
```

#### Liquid Payments

```typescript
const prepareSendPaymentLiquid = async (sdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = {
    type: 'bitcoin',
    receiverAmountSat: 5_000
  };

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  });

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat;
  console.log(`Fees: ${sendFeesSat} sats`);
  return prepareResponse;
};

const prepareSendPaymentLiquidDrain = async (sdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = {
    type: 'drain'
  };

  const prepareResponse = await sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount
  });

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat;
  console.log(`Fees: ${sendFeesSat} sats`);
  return prepareResponse;
};
```

#### Execute Payment

```typescript
const sendPayment = async (sdk, prepareResponse) => {
  const sendResponse = await sdk.sendPayment({
    prepareResponse
  });
  const payment = sendResponse.payment;
  console.log(payment);
};
```

### Receiving Payments

#### Lightning Payments

Receiving Lightning payments involves a reverse submarine swap and requires two Liquid on-chain transactions:

1. Sender pays the Swapper invoice.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address and exposes the preimage.
4. Swapper uses the preimage to claim funds from the Liquid lockup address.

The fee components:
- Lockup Transaction Fee: ~27 sats (0.1 sat/discount vbyte)
- Claim Transaction Fee: ~20 sats (0.1 sat/discount vbyte)
- Swap Service Fee: 0.25% of the amount received (dynamic)

```typescript
const prepareReceiveLightning = async (sdk) => {
  try {
    // Fetch the lightning Receive limits
    const currentLimits = await sdk.fetchLightningLimits();
    console.log(`Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}`);
    console.log(`Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}`);

    // Set the invoice amount you wish the payer to send, which should be within the above limits
    const optionalAmount = {
      type: 'bitcoin',
      payerAmountSat: 5_000
    };

    const prepareResponse = await sdk.prepareReceivePayment({
      paymentMethod: 'lightning',
      amount: optionalAmount
    });

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat;
    console.log(`Fees: ${receiveFeesSat} sats`);
    return prepareResponse;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

#### Onchain Payments

```typescript
const prepareReceiveOnchain = async (sdk) => {
  try {
    // Fetch the Onchain Receive limits
    const currentLimits = await sdk.fetchOnchainLimits();
    console.log(`Minimum amount allowed to deposit in sats: ${currentLimits.receive.minSat}`);
    console.log(`Maximum amount allowed to deposit in sats: ${currentLimits.receive.maxSat}`);

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    const optionalAmount = {
      type: 'bitcoin',
      payerAmountSat: 5_000
    };

    const prepareResponse = await sdk.prepareReceivePayment({
      paymentMethod: 'bitcoinAddress',
      amount: optionalAmount
    });

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat;
    console.log(`Fees: ${receiveFeesSat} sats`);
    return prepareResponse;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

#### Liquid Payments

```typescript
const prepareReceiveLiquid = async (sdk) => {
  try {
    // Create a Liquid BIP21 URI/address to receive a payment to
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    // Note: Not setting the amount will generate a plain Liquid address
    const optionalAmount = {
      type: 'bitcoin',
      payerAmountSat: 5_000
    };

    const prepareResponse = await sdk.prepareReceivePayment({
      paymentMethod: 'liquidAddress',
      amount: optionalAmount
    });

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat;
    console.log(`Fees: ${receiveFeesSat} sats`);
    return prepareResponse;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

#### Execute Receive

```typescript
const receivePayment = async (sdk, prepareResponse) => {
  try {
    const optionalDescription = '<description>';
    const res = await sdk.receivePayment({
      prepareResponse,
      description: optionalDescription
    });

    const destination = res.destination;
    console.log(destination); // This is the invoice or address to share with the payer
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

### LNURL Operations

#### LNURL Authentication

```typescript
const lnurlAuth = async (sdk) => {
  // Endpoint can also be in the form:
  // keyauth://domain.com/auth?key=val
  const lnurlAuthUrl =
    'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu';

  const input = await sdk.parse(lnurlAuthUrl);
  if (input.type === 'lnUrlAuth') {
    const result = await sdk.lnurlAuth(input.data);
    if (result.type === 'ok') {
      console.log('Successfully authenticated');
    } else {
      console.log('Failed to authenticate');
    }
  }
};
```

#### LNURL Pay

```typescript
const prepareLnurlPay = async (sdk) => {
  // Endpoint can also be in the form:
  // lnurlp://domain.com/lnurl-pay?key=val
  const lnurlPayUrl = 'lightning@address.com';

  const input = await sdk.parse(lnurlPayUrl);
  if (input.type === 'lnUrlPay') {
    const amount = {
      type: 'bitcoin',
      receiverAmountSat: 5_000
    };
    const optionalComment = '<comment>';
    const optionalValidateSuccessActionUrl = true;

    const prepareResponse = await sdk.prepareLnurlPay({
      data: input.data,
      amount,
      bip353Address: input.bip353Address,
      comment: optionalComment,
      validateSuccessActionUrl: optionalValidateSuccessActionUrl
    });

    // If the fees are acceptable, continue with the LNURL Pay
    const feesSat = prepareResponse.feesSat;
    console.log(`Fees: ${feesSat} sats`);
    return prepareResponse;
  }
};

const lnurlPay = async (sdk, prepareResponse) => {
  const result = await sdk.lnurlPay({
    prepareResponse
  });
  console.log(result);
};
```

#### LNURL Withdraw

```typescript
const lnurlWithdraw = async (sdk) => {
  // Endpoint can also be in the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  const lnurlWithdrawUrl =
    'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk';

  const input = await sdk.parse(lnurlWithdrawUrl);
  if (input.type === 'lnUrlWithdraw') {
    const amountMsat = input.data.minWithdrawable;
    const lnUrlWithdrawResult = await sdk.lnurlWithdraw({
      data: input.data,
      amountMsat,
      description: 'comment'
    });
    return lnUrlWithdrawResult;
  }
};
```

### Onchain Operations

#### Pay Onchain

```typescript
const getOnchainLimits = async (sdk) => {
  try {
    const currentLimits = await sdk.fetchOnchainLimits();
    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`);
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`);
    return currentLimits;
  } catch (err) {
    console.error(err);
  }
};

const preparePayOnchain = async (sdk) => {
  try {
    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'bitcoin',
        receiverAmountSat: 5_000
      }
    });

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat;
    return prepareResponse;
  } catch (err) {
    console.error(err);
  }
};

const preparePayOnchainFeeRate = async (sdk) => {
  try {
    const optionalSatPerVbyte = 21;

    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'bitcoin',
        receiverAmountSat: 5_000
      },
      feeRateSatPerVbyte: optionalSatPerVbyte
    });

    // Check if the fees are acceptable before proceeding
    const claimFeesSat = prepareResponse.claimFeesSat;
    const totalFeesSat = prepareResponse.totalFeesSat;
    return prepareResponse;
  } catch (err) {
    console.error(err);
  }
};

const payOnchain = async (sdk, prepareResponse) => {
  try {
    const destinationAddress = 'bc1..';
    const payOnchainRes = await sdk.payOnchain({
      address: destinationAddress,
      prepareResponse
    });
    return payOnchainRes;
  } catch (err) {
    console.error(err);
  }
};
```

#### Drain Funds

```typescript
const preparePayOnchainDrain = async (sdk) => {
  try {
    const prepareResponse = await sdk.preparePayOnchain({
      amount: {
        type: 'drain'
      }
    });

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat;
    return prepareResponse;
  } catch (err) {
    console.error(err);
  }
};
```

#### Handle Refundable Swaps

```typescript
const listRefundables = async (sdk) => {
  try {
    const refundables = await sdk.listRefundables();
    return refundables;
  } catch (err) {
    console.error(err);
  }
};

const executeRefund = async (sdk, refundable, refundTxFeeRate) => {
  const destinationAddress = '...';
  const feeRateSatPerVbyte = refundTxFeeRate;

  const refundResponse = await sdk.refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    feeRateSatPerVbyte
  });
  return refundResponse;
};

const rescanSwaps = async (sdk) => {
  try {
    await sdk.rescanOnchainSwaps();
  } catch (err) {
    console.error(err);
  }
};
```

#### Handle Fee Acceptance

```typescript
const handlePaymentsWaitingFeeAcceptance = async (sdk) => {
  // Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
  const paymentsWaitingFeeAcceptance = await sdk.listPayments({
    states: ['waitingFeeAcceptance']
  });

  for (const payment of paymentsWaitingFeeAcceptance) {
    if (payment.details.type !== 'bitcoin') {
      // Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
      continue;
    }

    const fetchFeesResponse = await sdk.fetchPaymentProposedFees({
      swapId: payment.details.swapId
    });

    console.info(
      `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
    );

    // If the user is ok with the fees, accept them, allowing the payment to proceed
    await sdk.acceptPaymentProposedFees({
      response: fetchFeesResponse
    });
  }
};
```

### Non-Bitcoin Assets

```typescript
const prepareReceiveAsset = async (sdk) => {
  try {
    // Create a Liquid BIP21 URI/address to receive an asset payment to
    // Note: Not setting the amount will generate an amountless BIP21 URI
    const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2';
    const optionalAmount = {
      type: 'asset',
      assetId: usdtAssetId,
      payerAmount: 1.5
    };

    const prepareResponse = await sdk.prepareReceivePayment({
      paymentMethod: 'liquidAddress',
      amount: optionalAmount
    });

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat;
    console.log(`Fees: ${receiveFeesSat} sats`);
    return prepareResponse;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

const prepareSendPaymentAsset = async (sdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const destination = '<Liquid BIP21 or address>';
  // If the destination is an address or an amountless BIP21 URI,
  // you must specify an asset amount
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2';
  const optionalAmount = {
    type: 'asset',
    assetId: usdtAssetId,
    receiverAmount: 1.5,
    estimateAssetFees: false
  };

  const prepareResponse = await sdk.prepareSendPayment({
    destination,
    amount: optionalAmount
  });

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat;
  console.log(`Fees: ${sendFeesSat} sats`);
  return prepareResponse;
};

const sendPaymentWithAssetFees = async (sdk, prepareResponse) => {
  // Set the use asset fees param to true
  const sendResponse = await sdk.sendPayment({
    prepareResponse,
    useAssetFees: true
  });
  const payment = sendResponse.payment;
  console.log(payment);
};

const configureAssetMetadata = () => {
  // Create the default config
  const config = defaultConfig('mainnet', '<your-Breez-API-key>');

  // Configure asset metadata
  config.assetMetadata = [
    {
      assetId: '18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec',
      name: 'PEGx EUR',
      ticker: 'EURx',
      precision: 8
    }
  ];
};

const fetchAssetBalance = async (sdk) => {
  try {
    const info = await sdk.getInfo();
    const assetBalances = info.walletInfo.assetBalances;
    return assetBalances;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
```

### Messages and Signing

```typescript
const signMessage = async (sdk) => {
  const signMessageResponse = sdk.signMessage({
    message: '<message to sign>'
  });

  // Get the wallet info for your pubkey
  const info = await sdk.getInfo();

  const signature = signMessageResponse.signature;
  const pubkey = info.walletInfo.pubkey;

  console.log(`Pubkey: ${pubkey}`);
  console.log(`Signature: ${signature}`);
};

const checkMessage = (sdk) => {
  const checkMessageResponse = sdk.checkMessage({
    message: '<message>',
    pubkey: '<pubkey of signer>',
    signature: '<message signature>'
  });
  const isValid = checkMessageResponse.isValid;

  console.log(`Signature valid: ${isValid}`);
};
```

### List Payments

```typescript
const getPayment = async (sdk) => {
  const paymentHash = '<payment hash>';
  const paymentByHash = await sdk.getPayment({
    type: 'paymentHash',
    paymentHash
  });

  const swapId = '<swap id>';
  const paymentBySwapId = await sdk.getPayment({
    type: 'swapId',
    swapId
  });
};

const listAllPayments = async (sdk) => {
  const payments = await sdk.listPayments({});
  return payments;
};

const listPaymentsFiltered = async (sdk) => {
  try {
    const payments = await sdk.listPayments({
      filters: ['send'],
      fromTimestamp: 1696880000,
      toTimestamp: 1696959200,
      offset: 0,
      limit: 50
    });
    return payments;
  } catch (err) {
    console.error(err);
  }
};

const listPaymentsDetailsAddress = async (sdk) => {
  try {
    const payments = await sdk.listPayments({
      details: {
        type: 'bitcoin',
        address: '<Bitcoin address>'
      }
    });
    return payments;
  } catch (err) {
    console.error(err);
  }
};

const listPaymentsDetailsDestination = async (sdk) => {
  try {
    const payments = await sdk.listPayments({
      details: {
        type: 'liquid',
        destination: '<Liquid BIP21 or address>'
      }
    });
    return payments;
  } catch (err) {
    console.error(err);
  }
};
```

### Webhook Integration

```typescript
const registerWebhook = async (sdk) => {
  try {
    await sdk.registerWebhook('https://your-nds-service.com/notify?platform=web&token=<PUSH_TOKEN>');
  } catch (err) {
    console.error(err);
  }
};

const unregisterWebhook = async (sdk) => {
  try {
    await sdk.unregisterWebhook();
  } catch (err) {
    console.error(err);
  }
};
```

### Input Parsing

```typescript
const parseInput = async (sdk) => {
  const input = 'an input to be parsed...';

  const parsed = await sdk.parse(input);

  switch (parsed.type) {
    case 'bitcoinAddress':
      console.log(`Input is Bitcoin address ${parsed.address.address}`);
      break;

    case 'bolt11':
      console.log(
        `Input is BOLT11 invoice for ${
          parsed.invoice.amountMsat != null ? parsed.invoice.amountMsat.toString() : 'unknown'
        } msats`
      );
      break;

    case 'lnUrlPay':
      console.log(
        `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.data.minSendable}/${
          parsed.data.maxSendable
        } msats - BIP353 was used: ${parsed.bip353Address != null}`
      );
      break;

    case 'lnUrlWithdraw':
      console.log(
        `Input is LNURL-Withdraw for min/max ${parsed.data.minWithdrawable}/${parsed.data.maxWithdrawable} msats`
      );
      break;

    default:
      // Other input types are available
      break;
  }
};

const configureExternalParsers = async () => {
  const mnemonic = '<mnemonics words>';

  // Create the default config, providing your Breez API key
  const config = defaultConfig('mainnet', '<your-Breez-API-key>');

  // Configure external parsers
  config.externalInputParsers = [
    {
      providerId: 'provider_a',
      inputRegex: '^provider_a',
      parserUrl: 'https://parser-domain.com/parser?input=<input>'
    },
    {
      providerId: 'provider_b',
      inputRegex: '^provider_b',
      parserUrl: 'https://parser-domain.com/parser?input=<input>'
    }
  ];

  await connect({ mnemonic, config });
};
```

## Complete Web App Example

Here's a simplified React component that demonstrates how to use the SDK in a web app:

```jsx
import React, { useEffect, useState, useCallback } from 'react';
import init, { connect, defaultConfig } from '@breeztech/breez-sdk-liquid/web';

function WalletComponent() {
  const [sdk, setSdk] = useState(null);
  const [walletInfo, setWalletInfo] = useState(null);
  const [transactions, setTransactions] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  // Initialize SDK on component mount
  useEffect(() => {
    const initWallet = async () => {
      try {
        setIsLoading(true);
        
        // Initialize WASM module
        await init();
        
        // Get saved mnemonic or create new one
        const savedMnemonic = localStorage.getItem('walletMnemonic');
        const mnemonic = savedMnemonic || generateNewMnemonic();
        
        // Create config with API key
        const config = defaultConfig('mainnet');
        config.breezApiKey = process.env.REACT_APP_BREEZ_API_KEY;
        
        // Connect to Breez SDK
        const sdkInstance = await connect({
          config,
          mnemonic,
        });
        
        // Save mnemonic if new
        if (!savedMnemonic) {
          localStorage.setItem('walletMnemonic', mnemonic);
        }
        
        // Set up event listener
        const eventListener = {
          onEvent: (event) => {
            console.log('SDK event:', event);
            if (event.type === 'synced') {
              refreshWalletData();
            }
          }
        };
        
        const listenerId = await sdkInstance.addEventListener(eventListener);
        
        // Store SDK instance
        setSdk(sdkInstance);
        
        // Get initial wallet data
        const info = await sdkInstance.getInfo();
        const txs = await sdkInstance.listPayments({});
        
        setWalletInfo(info);
        setTransactions(txs);
      } catch (err) {
        console.error('Wallet initialization error:', err);
        setError(err.message);
      } finally {
        setIsLoading(false);
      }
    };
    
    initWallet();
    
    // Clean up on unmount
    return () => {
      if (sdk) {
        sdk.disconnect().catch(console.error);
      }
    };
  }, []);
  
  // Function to refresh wallet data
  const refreshWalletData = useCallback(async () => {
    if (!sdk) return;
    
    try {
      const info = await sdk.getInfo();
      const txs = await sdk.listPayments({});
      
      setWalletInfo(info);
      setTransactions(txs);
    } catch (err) {
      console.error('Error refreshing wallet data:', err);
    }
  }, [sdk]);
  
  // Handle receiving payment
  const handleReceive = async () => {
    if (!sdk) return;
    
    try {
      // Fetch lightning limits
      const limits = await sdk.fetchLightningLimits();
      
      // Prepare receive with amount of 5000 sats
      const prepareResponse = await sdk.prepareReceivePayment({
        paymentMethod: 'lightning',
        amount: {
          type: 'bitcoin',
          payerAmountSat: 5000
        }
      });
      
      // Create the invoice
      const response = await sdk.receivePayment({
        prepareResponse,
        description: 'Payment received via web app'
      });
      
      // Show the invoice to user
      alert(`Generated invoice: ${response.destination}`);
    } catch (err) {
      console.error('Error generating invoice:', err);
      setError(err.message);
    }
  };
  
  // Handle sending payment
  const handleSend = async (invoice) => {
    if (!sdk || !invoice) return;
    
    try {
      // Prepare send payment
      const prepareResponse = await sdk.prepareSendPayment({
        destination: invoice
      });
      
      // Check if fees are acceptable
      if (prepareResponse.feesSat > 100) {
        const confirmed = window.confirm(`Fee is ${prepareResponse.feesSat} sats. Continue?`);
        if (!confirmed) return;
      }
      
      // Send payment
      const sendResponse = await sdk.sendPayment({
        prepareResponse
      });
      
      alert('Payment sent successfully!');
      refreshWalletData();
    } catch (err) {
      console.error('Error sending payment:', err);
      setError(err.message);
    }
  };
  
  if (isLoading) {
    return <div>Loading wallet...</div>;
  }
  
  if (error) {
    return <div>Error: {error}</div>;
  }
  
  return (
    <div>
      <h1>Breez SDK Wallet</h1>
      
      {walletInfo && (
        <div>
          <h2>Balance: {walletInfo.walletInfo.balanceSat.toLocaleString()} sats</h2>
          <button onClick={handleReceive}>Receive</button>
          <button onClick={() => {
            const invoice = prompt('Enter invoice to pay:');
            if (invoice) handleSend(invoice);
          }}>Send</button>
          
          <h3>Transaction History</h3>
          <ul>
            {transactions.map((tx, index) => (
              <li key={index}>
                {tx.paymentType === 'receive' ? 'Received: ' : 'Sent: '}
                {tx.amountSat.toLocaleString()} sats
                {tx.status !== 'complete' && ` (${tx.status})`}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

export default WalletComponent;
```

## End-User Fees

### Sending Lightning Payments

Sending Lightning payments involves a submarine swap and two Liquid on-chain transactions:

1. User broadcasts an L-BTC transaction to a Liquid lockup address
2. Swapper pays the invoice and gets a preimage
3. Swapper broadcasts an L-BTC transaction to claim funds

Fee components:
- Lockup Transaction Fee: ~34 sats (0.1 sat/discount vbyte)
- Claim Transaction Fee: ~19 sats (0.1 sat/discount vbyte)
- Swap Service Fee: 0.1% of the amount sent

Example: If sending 10k sats, total fee = 34 + 19 + 10 = 63 sats

### Receiving Lightning Payments

Receiving Lightning payments involves a reverse submarine swap and two Liquid on-chain transactions:

1. Sender pays the Swapper invoice
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address
3. SDK claims the funds and exposes the preimage
4. Swapper uses the preimage to claim funds

Fee components:
- Lockup Transaction Fee: ~27 sats (0.1 sat/discount vbyte)
- Claim Transaction Fee: ~20 sats (0.1 sat/discount vbyte)
- Swap Service Fee: 0.25% of the amount received

Example: If receiving 10k sats, total fee = 27 + 20 + 25 = 72 sats

### Sending to a Bitcoin Address

Sending to a BTC address involves a trustless chain swap with 2 Liquid transactions and 2 BTC transactions:

1. SDK broadcasts an L-BTC transaction to a Liquid lockup address
2. Swapper broadcasts a BTC transaction to a Bitcoin lockup address
3. Recipient claims the funds from the Bitcoin lockup address
4. Swapper claims the funds from the Liquid lockup address

Fee components:
- L-BTC Lockup Transaction Fee: ~34 sats
- BTC Lockup Transaction Fee: based on current BTC mempool usage
- Swap Service Fee: 0.1% of the amount sent
- BTC Claim Transaction Fee: fees to claim BTC to destination address

Example: For 100k sats with 2000 sats BTC mining fees and 1000 sats claim fees, total = 34 + 2000 + 100 + 1000 = 3134 sats

### Receiving from a BTC Address

Receiving from a BTC address also involves a trustless chain swap:

1. Sender broadcasts a BTC transaction to the Bitcoin lockup address
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address
3. SDK claims the funds from the Liquid lockup address
4. Swapper claims the funds from the Bitcoin lockup address

Fee components:
- L-BTC Claim Transaction Fee: ~20 sats
- BTC Claim Transaction Fee: based on Bitcoin mempool usage
- Swapper Service Fee: 0.1% of the amount received

Example: For 100k sats with 2000 sats BTC mining fees, total = 20 + 100 + 2000 = 2120 sats

## Best Practices

### Syncing

Always ensure the SDK instance is synced before performing actions:

```typescript
const waitForSynced = async (sdk) => {
  const eventPromise = new Promise((resolve) => {
    const listener = {
      onEvent: (event) => {
        if (event.type === 'synced') {
          resolve();
        }
      }
    };
    sdk.addEventListener(listener);
  });
  
  // Wait for sync event or timeout after 30 seconds
  return Promise.race([
    eventPromise,
    new Promise((_, reject) => setTimeout(() => reject(new Error('Sync timeout')), 30000))
  ]);
};

const performAction = async (sdk) => {
  await waitForSynced(sdk);
  
  // Now it's safe to perform actions
  const info = await sdk.getInfo();
  console.log(info);
};
```

### Error Handling

Implement robust error handling:

```typescript
const safeOperation = async (operation) => {
  try {
    return await operation();
  } catch (error) {
    console.error(`Operation failed: ${error.message}`);
    // Handle specific error types appropriately
    if (error.message.includes('insufficient funds')) {
      // Handle insufficient funds error
    } else if (error.message.includes('connection')) {
      // Handle connection error
    }
    throw error; // Re-throw or handle at a higher level
  }
};

// Usage
const result = await safeOperation(() => sdk.sendPayment({
  prepareResponse
}));
```

### Connection Lifecycle

Manage the connection lifecycle properly:

```typescript
// Initialize only once per session
const sdk = await connect(connectRequest);

// Use SDK
// ...

// Disconnect when done
try {
  await sdk.disconnect();
} catch (error) {
  console.error(`Error disconnecting: ${error.message}`);
}
```

### Fee Handling

Always check fees before executing payments:

```typescript
const executeSafePayment = async (sdk, destination, maxAcceptableFee = 1000) => {
  // Get fee information
  const prepareResponse = await sdk.prepareSendPayment({
    destination
  });
  
  const feesSat = prepareResponse.feesSat || 0;
  
  // Check if fees are acceptable before proceeding
  if (feesSat <= maxAcceptableFee) {
    // Execute payment
    return await sdk.sendPayment({
      prepareResponse
    });
  } else {
    // Fees are too high
    throw new Error(`Fees too high: ${feesSat} sats (maximum: ${maxAcceptableFee} sats)`);
  }
};
```

### Browser Storage Considerations

When working with browser storage, consider:

```typescript
const secureMnemonicStorage = {
  // Save mnemonic - in production, consider more secure options than localStorage
  save: (mnemonic) => {
    // For demonstration only - not secure for production
    localStorage.setItem('encrypted_mnemonic', btoa(mnemonic));
  },
  
  // Retrieve mnemonic
  retrieve: () => {
    const storedMnemonic = localStorage.getItem('encrypted_mnemonic');
    return storedMnemonic ? atob(storedMnemonic) : null;
  },
  
  // Clear mnemonic
  clear: () => {
    localStorage.removeItem('encrypted_mnemonic');
  }
};
```

## Security Considerations

1. **Protecting Mnemonics**
   - Never hardcode mnemonics in your code
   - Store encrypted or in secure storage
   - Consider using a custom signer for production apps
   - For web apps, consider using hardware wallet integration

2. **API Key Security**
   - Store API keys in environment variables
   - Consider proxy server for production to avoid exposing keys in frontend code
   - Don't commit API keys to source control

3. **Validating Inputs**
   - Always validate payment destinations
   - Check amounts are within reasonable limits
   - Sanitize and validate all external inputs

4. **WASM-Specific Considerations**
   - Load WASM files from a trusted source
   - Be aware of cross-origin restrictions and CORS settings
   - Consider using CSP (Content Security Policy) to restrict where WASM can be loaded from

5. **Browser Environment**
   - Use HTTPS for all connections
   - Be aware of limited storage options in browsers
   - Consider the implications of users clearing browser storage and provide recovery options