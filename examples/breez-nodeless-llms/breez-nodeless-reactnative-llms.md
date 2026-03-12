# Breez SDK Nodeless (Liquid implementation) Documentation

This comprehensive document provides all the context needed to build applications with the React Native bindings of Breez SDK Nodeless, a toolkit for integrating Bitcoin, Lightning Network, and Liquid Network functionality into your applications.

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
yarn add @breeztech/breez-sdk-liquid-react-native
```

### Guidelines
- **Always make sure the SDK instance is synced before performing any actions**
- **Add logging**: Add sufficient logging into your application to diagnose any issues users are having.
- **Display pending payments**: Payments always contain a status field that can be used to determine if the payment was completed or not. Make sure you handle the case where the payment is still pending by showing the correct status to the user.
- **Enable swap refunds**: Swaps that are the result of receiving an On-Chain Transaction may not be completed and change to `Refundable` state. Make sure you handle this case correctly by allowing the user to retry the refund with different fees as long as the refund is not confirmed.
- **Expose swap fees**: When sending or receiving on-chain, make sure to clearly show the expected fees involved, as well as the send/receive amounts.

### Initializing the SDK

To get started with Breez SDK Nodeless (Liquid implementation), you need to initialize the SDK with your configuration:

```typescript
import {
  BindingLiquidSdk,
  defaultConfig,
  connect,
  LiquidNetwork,
  type LogEntry,
  type SdkEvent,
  setLogger
} from '@breeztech/breez-sdk-liquid-react-native'

const initializeSDK = async () => {
  // Your mnemonic seed phrase for wallet recovery
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = defaultConfig(
    LiquidNetwork.Mainnet,
    '<your-Breez-API-key>'
  )

  // By default in React Native the workingDir is set to:
  // `/<APPLICATION_SANDBOX_DIRECTORY>/breezSdkLiquid`
  // You can change this to another writable directory or a
  // subdirectory of the workingDir if managing multiple mnemonics.
  console.log(`Working directory: ${config.workingDir}`)
  // config.workingDir = "path to writable directory"

  connect({
    mnemonic, config,
    passphrase: undefined,
    seed: undefined
  })
}
```

### Basic Operations

#### Fetch Balance

```typescript
const fetchBalance = (sdk: BindingLiquidSdk) => {
  const info = sdk.getInfo()
  const balanceSat = info.walletInfo.balanceSat
  const pendingSendSat = info.walletInfo.pendingSendSat
  const pendingReceiveSat = info.walletInfo.pendingReceiveSat

  console.log(`Balance: ${balanceSat} sats`)
  console.log(`Pending Send: ${pendingSendSat} sats`)
  console.log(`Pending Receive: ${pendingReceiveSat} sats`)
}

const fetchAssetBalance = (sdk: BindingLiquidSdk) => {
  const info = sdk.getInfo()
  const assetBalances = info.walletInfo.assetBalances
  return assetBalances
}
```

### Messages and Signing

```typescript
import { BindingLiquidSdk } from '@breeztech/breez-sdk-liquid-react-native'

const signMessageExample = (sdk: BindingLiquidSdk) => {
  const signMessageResponse = sdk.signMessage({
    message: '<message to sign>'
  })

  // Get the wallet info for your pubkey
  const info = sdk.getInfo()

  const signature = signMessageResponse.signature
  const pubkey = info.walletInfo.pubkey

  console.log(`Pubkey: ${pubkey}`)
  console.log(`Signature: ${signature}`)
  return { signature, pubkey }
}

const checkMessageExample = (sdk: BindingLiquidSdk) => {
  const checkMessageResponse = sdk.checkMessage({
    message: '<message>',
    pubkey: '<pubkey of signer>',
    signature: '<message signature>'
  })
  const isValid = checkMessageResponse.isValid

  console.log(`Signature valid: ${isValid}`)
  return isValid
}
```

### List Payments

```typescript
import {
  BindingLiquidSdk,
  GetPaymentRequest,
  ListPaymentDetails,
  PaymentType
} from '@breeztech/breez-sdk-liquid-react-native'

const getPaymentExample = (sdk: BindingLiquidSdk) => {
  try {
    const paymentHash = '<payment hash>'
    const paymentByHash = sdk.getPayment(new GetPaymentRequest.PaymentHash({ paymentHash }))

    const swapId = '<swap id>'
    const paymentBySwapId = sdk.getPayment(new GetPaymentRequest.SwapId({ swapId }))

    return { paymentByHash, paymentBySwapId }
  } catch (err) {
    console.error(err)
  }
}

const listAllPayments = (sdk: BindingLiquidSdk) => {
  try {
    const payments = sdk.listPayments({
      filters: undefined,
      states: undefined,
      fromTimestamp: undefined,
      toTimestamp: undefined,
      offset: undefined,
      limit: undefined,
      details: undefined,
      sortAscending: undefined
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsFiltered = (sdk: BindingLiquidSdk) => {
  try {
    const payments = sdk.listPayments({
      filters: [PaymentType.Send],
      fromTimestamp: BigInt(1696880000),
      toTimestamp: BigInt(1696959200),
      offset: 0,
      limit: 50,
      states: undefined,
      details: undefined,
      sortAscending: undefined
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsDetailsAddress = (sdk: BindingLiquidSdk) => {
  try {
    const payments = sdk.listPayments({
      details: new ListPaymentDetails.Bitcoin({ address: '<Bitcoin address>' }),
      filters: undefined,
      states: undefined,
      fromTimestamp: undefined,
      toTimestamp: undefined,
      offset: undefined,
      limit: undefined,
      sortAscending: undefined
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsDetailsDestination = (sdk: BindingLiquidSdk) => {
  try {
    const payments = sdk.listPayments({
      details: new ListPaymentDetails.Liquid({ assetId: undefined, destination: '<Liquid BIP21 or address>' }),
      filters: undefined,
      states: undefined,
      fromTimestamp: undefined,
      toTimestamp: undefined,
      offset: undefined,
      limit: undefined,
      sortAscending: undefined
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}
```

### Webhook Integration

```typescript
import { BindingLiquidSdk } from '@breeztech/breez-sdk-liquid-react-native'

const registerWebhookExample = (sdk: BindingLiquidSdk) => {
  try {
    sdk.registerWebhook('https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>')
  } catch (err) {
    console.error(err)
  }
}

const unregisterWebhookExample = (sdk: BindingLiquidSdk) => {
  try {
    sdk.unregisterWebhook()
  } catch (err) {
    console.error(err)
  }
}
```

### Input Parsing

```typescript
import {
  BindingLiquidSdk,
  InputType_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const parseInputExample = (sdk: BindingLiquidSdk) => {
  const input = 'an input to be parsed...'

  const parsed = sdk.parse(input)

  switch (parsed.tag) {
    case InputType_Tags.BitcoinAddress:
      console.log(`Input is Bitcoin address ${parsed.inner.address.address}`)
      break

    case InputType_Tags.Bolt11:
      console.log(
        `Input is BOLT11 invoice for ${parsed.inner.invoice.amountMsat != null
          ? JSON.stringify(parsed.inner.invoice.amountMsat)
          : 'unknown'
        } msats`
      )
      break

    case InputType_Tags.Bolt12Offer:
      console.log(
        `Input is BOLT12 offer for min ${JSON.stringify(parsed.inner.offer.minAmount)} msats - BIP353 was used: ${parsed.inner.bip353Address != null}`
      )
      break

    case InputType_Tags.LnUrlPay:
      console.log(
        `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.inner.data.minSendable}/${parsed.inner.data.maxSendable} msats - BIP353 was used: ${parsed.inner.bip353Address != null}`
      )
      break

    case InputType_Tags.LnUrlWithdraw:
      console.log(
        `Input is LNURL-Withdraw for min/max ${parsed.inner.data.minWithdrawable}/${parsed.inner.data.maxWithdrawable} msats`
      )
      break

    default:
      // Other input types are available
      break
  }

  return parsed
}

const configureParsers = () => {
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = defaultConfig(
    LiquidNetwork.Mainnet,
    '<your-Breez-API-key>'
  )

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
  ]

  connect({
    mnemonic, config,
    passphrase: undefined,
    seed: undefined
  })
}
```

## React Native Component Example

Here's a complete React Native component example that implements basic wallet functionality:

```typescript
import React, { useState, useEffect } from 'react';
import { View, Text, ActivityIndicator, Button, StyleSheet, SafeAreaView, ScrollView, TextInput } from 'react-native';
import {
  BindingLiquidSdk,
  connect,
  defaultConfig,
  LiquidNetwork,
  PaymentMethod,
  PayAmount,
  ReceiveAmount,
  type PrepareReceiveResponse,
  type PrepareSendResponse,
  type SdkEvent
} from '@breeztech/breez-sdk-liquid-react-native';

const WalletApp = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [sdk, setSdk] = useState<BindingLiquidSdk | null>(null);
  const [walletInfo, setWalletInfo] = useState(null);
  const [listenerId, setListenerId] = useState<string | null>(null);
  const [receiveAddress, setReceiveAddress] = useState('');
  const [sendAddress, setSendAddress] = useState('');
  const [amountSats, setAmountSats] = useState('1000');
  const [error, setError] = useState('');

  useEffect(() => {
    initializeSDK();

    return () => {
      cleanupSDK();
    };
  }, []);

  const initializeSDK = async () => {
    try {
      setIsLoading(true);

      // Initialize the SDK
      const config = defaultConfig(
        LiquidNetwork.Mainnet,
        'your-api-key-here'
      );

      // Use a sample mnemonic for testing - in production you'd want to get this securely
      const mnemonic = 'sample mnemonic words here for testing only';

      const sdkInstance = connect({
        mnemonic, config,
        passphrase: undefined,
        seed: undefined
      });

      setSdk(sdkInstance);

      // Set up event listener
      const onEvent = (e: SdkEvent) => {
        console.log(`Event received: ${e.tag}`);
        // Refresh wallet info when we get a relevant event
        if (
          e.tag === 'paymentSucceeded' ||
          e.tag === 'paymentFailed' ||
          e.tag === 'synced'
        ) {
          refreshWalletInfo(sdkInstance);
        }
      };

      const id = sdkInstance.addEventListener({ onEvent });
      setListenerId(id);

      // Get initial wallet info
      refreshWalletInfo(sdkInstance);

      setIsLoading(false);
    } catch (err) {
      console.error('Initialization error:', err);
      setError(`Initialization error: ${err.message}`);
      setIsLoading(false);
    }
  };

  const cleanupSDK = () => {
    try {
      if (listenerId && sdk) {
        sdk.removeEventListener(listenerId);
      }
      if (sdk) {
        sdk.disconnect();
      }
    } catch (err) {
      console.error('Cleanup error:', err);
    }
  };

  const refreshWalletInfo = (sdkInstance: BindingLiquidSdk) => {
    try {
      const info = sdkInstance.getInfo();
      setWalletInfo(info.walletInfo);
    } catch (err) {
      console.error('Error getting wallet info:', err);
      setError(`Error fetching wallet info: ${err.message}`);
    }
  };

  const handleReceive = () => {
    try {
      if (!sdk) return;
      setIsLoading(true);
      setError('');

      // Prepare receive request
      const amount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(parseInt(amountSats, 10)) });

      const prepareResponse = sdk.prepareReceivePayment({
        paymentMethod: PaymentMethod.Bolt11Invoice,
        amount
      });

      // Check fees
      console.log(`Receive fees: ${prepareResponse.feesSat} sats`);

      // Create receive request
      const receiveResponse = sdk.receivePayment({
        prepareResponse,
        description: 'Payment request from React Native app',
        descriptionHash: undefined,
        payerNote: undefined
      });

      setReceiveAddress(receiveResponse.destination);
      setIsLoading(false);
    } catch (err) {
      console.error('Error creating receive request:', err);
      setError(`Error creating receive request: ${err.message}`);
      setIsLoading(false);
    }
  };

  const handleSend = () => {
    try {
      if (!sendAddress) {
        setError('Please enter a destination address');
        return;
      }
      if (!sdk) return;

      setIsLoading(true);
      setError('');

      // Prepare send payment
      const amount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(parseInt(amountSats, 10)) });

      const prepareResponse = sdk.prepareSendPayment({
        destination: sendAddress,
        amount,
        disableMrh: undefined,
        paymentTimeoutSec: undefined
      });

      // Check fees
      console.log(`Send fees: ${prepareResponse.feesSat} sats`);

      // Send payment
      const sendResponse = sdk.sendPayment({
        prepareResponse,
        payerNote: undefined,
        useAssetFees: undefined
      });

      console.log('Payment sent:', sendResponse.payment);

      // Clear form fields
      setSendAddress('');

      // Refresh wallet info
      refreshWalletInfo(sdk);

      setIsLoading(false);
    } catch (err) {
      console.error('Error sending payment:', err);
      setError(`Error sending payment: ${err.message}`);
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#0000ff" />
        <Text style={styles.loadingText}>Initializing wallet...</Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Text style={styles.title}>Breez SDK Wallet</Text>

        {error ? <Text style={styles.errorText}>{error}</Text> : null}

        <View style={styles.balanceContainer}>
          <Text style={styles.balanceLabel}>Balance:</Text>
          <Text style={styles.balanceValue}>
            {walletInfo ? `${walletInfo.balanceSat} sats` : 'Unknown'}
          </Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Receive Payment</Text>
          <TextInput
            style={styles.input}
            placeholder="Amount (sats)"
            keyboardType="numeric"
            value={amountSats}
            onChangeText={setAmountSats}
          />
          <Button
            title="Generate Invoice"
            onPress={handleReceive}
          />

          {receiveAddress ? (
            <View style={styles.addressContainer}>
              <Text style={styles.addressLabel}>Your invoice:</Text>
              <Text style={styles.address} selectable>{receiveAddress}</Text>
            </View>
          ) : null}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Send Payment</Text>
          <TextInput
            style={styles.input}
            placeholder="Destination/Invoice"
            value={sendAddress}
            onChangeText={setSendAddress}
          />
          <TextInput
            style={styles.input}
            placeholder="Amount (sats)"
            keyboardType="numeric"
            value={amountSats}
            onChangeText={setAmountSats}
          />
          <Button
            title="Send Payment"
            onPress={handleSend}
          />
        </View>

        <Button
          title="Refresh Wallet Info"
          onPress={() => sdk && refreshWalletInfo(sdk)}
        />
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5'
  },
  scrollContainer: {
    padding: 16
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    textAlign: 'center'
  },
  loadingText: {
    marginTop: 16,
    textAlign: 'center',
    color: '#666'
  },
  errorText: {
    color: 'red',
    marginBottom: 16
  },
  balanceContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 24,
    backgroundColor: '#fff',
    padding: 16,
    borderRadius: 8,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    shadowRadius: 1.41
  },
  balanceLabel: {
    fontSize: 18,
    marginRight: 8
  },
  balanceValue: {
    fontSize: 18,
    fontWeight: 'bold'
  },
  section: {
    backgroundColor: '#fff',
    padding: 16,
    borderRadius: 8,
    marginBottom: 16,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    shadowRadius: 1.41
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 12
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 4,
    padding: 8,
    marginBottom: 12
  },
  addressContainer: {
    marginTop: 12,
    padding: 12,
    backgroundColor: '#f9f9f9',
    borderRadius: 4
  },
  addressLabel: {
    fontWeight: 'bold',
    marginBottom: 4
  },
  address: {
    fontFamily: 'monospace'
  }
});

export default WalletApp;
```

### End-User Fees

#### Sending Lightning Payments

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

#### Receiving Lightning Payments

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

#### Sending to a Bitcoin Address

Sending to a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions. The process is as follows:

1. SDK broadcasts an L-BTC transaction to a Liquid lockup address.
2. Swapper broadcasts a BTC transaction to a Bitcoin lockup address.
3. Recipient claims the funds from the Bitcoin lockup address.
4. Swapper claims the funds from the Liquid lockup address.

The fee to send to a BTC address is composed of four parts:

1. **L-BTC Lockup Transaction Fee**: ~34 sats (0.1 sat/discount vbyte).
2. **BTC Lockup Transaction Fee**: the swapper charges a mining fee based on the current bitcoin mempool usage.
3. **Swap Service Fee:** 0.1% fee on the amount sent.
4. **BTC Claim Transaction Fee:** the SDK fees to claim BTC funds to the destination address, based on the current Bitcoin mempool usage.

Note: swap service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the user sends 100k sats, the mining fees returned by the Swapper are 2000 sats, and the claim fees for the user are 1000 sats—the fee would be:
>
> - 34 sats [Lockup Transaction Fee] + 2000 sats [BTC Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 1000 sats [BTC Lockup Transaction Fee] = 3132 sats

### Receiving from a BTC Address

Receiving from a BTC address involves a trustless chain swap, 2 Liquid on-chain transactions, and 2 BTC on-chain transactions.

The process is as follows:

1. Sender broadcasts a BTC transaction to the Bitcoin lockup address.
2. Swapper broadcasts an L-BTC transaction to a Liquid lockup address.
3. SDK claims the funds from the Liquid lockup address.
4. Swapper claims the funds from the Bitcoin lockup address.

The fee to receive from a BTC address is composed of three parts:

1. **L-BTC Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
2. **BTC Claim Transaction Fee:** the swapper charges a mining fee based on the Bitcoin mempool usage at the time of the swap.
3. **Swapper Service Fee:** the swapper charges a 0.1% fee on the amount received.

Note: swapper service fee is dynamic and can change. Currently, it is 0.1%.

> **Example**: If the sender sends 100k sats and the mining fees returned by the Swapper are 2000 sats—the fee for the end-user would be:
>
> - 20 sats [Claim Transaction Fee] + 100 sats [Swapper Service Fee] + 2000 sats [BTC Claim Transaction Fee] = 2120 sats

## Best Practices

### Syncing

**Always make sure the SDK instance is synced before performing any actions:**

```typescript
import { BindingLiquidSdk, type SdkEvent } from '@breeztech/breez-sdk-liquid-react-native';

// In a React component using the useEffect hook
useEffect(() => {
  let synced = false;
  let listenerId: string | undefined;

  const setupListener = (sdk: BindingLiquidSdk) => {
    const onEvent = (event: SdkEvent) => {
      if (event.tag === 'synced') {
        synced = true;
        // Now it's safe to perform actions
        fetchWalletData(sdk);
      }
    };

    listenerId = sdk.addEventListener({ onEvent });
  };

  setupListener(sdk);

  return () => {
    // Cleanup when component unmounts
    if (listenerId && sdk) {
      sdk.removeEventListener(listenerId);
    }
  };
}, []);
```

### Error Handling

Always wrap your SDK method calls in try-catch blocks to properly handle errors:

```typescript
const sendPaymentExample = (sdk: BindingLiquidSdk) => {
  try {
    // Call SDK method
    const result = sdk.someMethod();
    // Process result
  } catch (error) {
    console.error('An error occurred:', error);
    // Handle the error appropriately, e.g., show a user-friendly message
    setErrorMessage(`Payment failed: ${error.message}`);
  }
};
```

### Connection Lifecycle

Manage the connection lifecycle properly:

```typescript
import React, { useEffect } from 'react';
import {
  connect,
  defaultConfig,
  LiquidNetwork
} from '@breeztech/breez-sdk-liquid-react-native';

const WalletScreen = () => {
  useEffect(() => {
    let sdkInstance;

    const initializeSdk = () => {
      try {
        const config = defaultConfig(LiquidNetwork.Mainnet, 'your-api-key');
        // Initialize SDK
        sdkInstance = connect({
          mnemonic,
          config,
          passphrase: undefined,
          seed: undefined
        });

        // SDK is ready to use
      } catch (error) {
        console.error('Failed to initialize SDK:', error);
      }
    };

    initializeSdk();

    // Cleanup function
    return () => {
      try {
        if (sdkInstance) {
          sdkInstance.disconnect();
        }
      } catch (error) {
        console.error('Error disconnecting:', error);
      }
    };
  }, []);

  // Rest of the component
};
```

### Fee Handling

Always check fees before executing payments and get user confirmation:

```typescript
import { BindingLiquidSdk, PayAmount } from '@breeztech/breez-sdk-liquid-react-native';

const executePayment = (sdk: BindingLiquidSdk, destination: string, amountSat: bigint) => {
  try {
    // Get fee information
    const prepareResponse = sdk.prepareSendPayment({
      destination,
      amount: new PayAmount.Bitcoin({ receiverAmountSat: amountSat }),
      disableMrh: undefined,
      paymentTimeoutSec: undefined
    });

    const feesSat = prepareResponse.feesSat;

    // Ask user to confirm the fee (using an Alert or a custom modal)
    const userConfirmed = showFeeConfirmationDialog(feesSat);

    if (userConfirmed) {
      // Execute payment
      const paymentResponse = sdk.sendPayment({
        prepareResponse,
        payerNote: undefined,
        useAssetFees: undefined
      });
      // Handle successful payment
    } else {
      // User rejected the fee
      console.log('Payment canceled by user due to fees');
    }
  } catch (error) {
    console.error('Payment error:', error);
  }
};
```

### Event Handling

Implement a robust event listener system:

```typescript
import { useEffect, useState } from 'react';
import {
  BindingLiquidSdk,
  type SdkEvent
} from '@breeztech/breez-sdk-liquid-react-native';

function useSdkEvents(sdk: BindingLiquidSdk) {
  const [paymentEvents, setPaymentEvents] = useState<SdkEvent[]>([]);
  const [syncStatus, setSyncStatus] = useState(false);

  useEffect(() => {
    let listenerId: string;

    const handleEvent = (event: SdkEvent) => {
      console.log('SDK Event:', event);

      switch (event.tag) {
        case 'paymentSucceeded':
          setPaymentEvents(prev => [...prev, event]);
          break;
        case 'synced':
          setSyncStatus(true);
          break;
        case 'syncing':
          setSyncStatus(false);
          break;
        // Handle other event types
      }
    };

    listenerId = sdk.addEventListener({ onEvent: handleEvent });

    return () => {
      if (listenerId) {
        sdk.removeEventListener(listenerId);
      }
    };
  }, [sdk]);

  return { paymentEvents, syncStatus };
}
```

### Logging and Event Handling

```typescript
import {
  BindingLiquidSdk,
  type LogEntry,
  type SdkEvent,
  setLogger
} from '@breeztech/breez-sdk-liquid-react-native'

// Set up logging
const setupLogging = () => {
  // Define a log handler function
  const onLogEntry = (l: LogEntry) => {
    console.log(`Received log [${l.level}]: ${l.line}`)
  }

  const subscription = setLogger({ log: onLogEntry })
}

// Add an event listener
const setupEventListener = (sdk: BindingLiquidSdk) => {
  // Define an event handler function
  const onEvent = (e: SdkEvent) => {
    console.log(`Received event: ${e.tag}`)
  }

  const listenerId = sdk.addEventListener({ onEvent })
  return listenerId
}

// Remove an event listener
const removeListener = (sdk: BindingLiquidSdk, listenerId: string) => {
  sdk.removeEventListener(listenerId)
}

// Clean up and disconnect
const cleanupSdk = (sdk: BindingLiquidSdk) => {
  sdk.disconnect()
}
```

## Troubleshooting

### Common Issues

1. **Connection Problems**
   - Check your API key
   - Verify network selection (Mainnet vs Testnet)
   - Confirm working directory permissions

2. **Payment Issues**
   - Verify amount is within allowed limits
   - Check fee settings
   - Ensure destination is valid
   - Verify sufficient balance

3. **Event Listener Not Triggering**
   - Confirm listener is registered with `sdk.addEventListener`
   - Check event tag matching in your handler
   - Add debug logging to trace events

### Debugging

Use the SDK's built-in logging system:

```typescript
import { setLogger, type LogEntry } from '@breeztech/breez-sdk-liquid-react-native';

const setupLogging = () => {
  const onLogEntry = (l: LogEntry) => {
    if (l.level !== 'TRACE') {
      console.log(`[${l.level}] ${l.line}`);
    }
  };

  setLogger({ log: onLogEntry });
};
```

## Security Considerations

1. **Protecting Mnemonics**
   - Never hardcode mnemonics in your code
   - Store securely using React Native's secure storage solutions
   - Consider using a custom signer for production apps

2. **API Key Security**
   - Store API keys using environment variables or a secure configuration system
   - Don't commit API keys to source control
   - Use different keys for production and testing

3. **Validating Inputs**
   - Always validate payment destinations
   - Check amounts are within reasonable limits
   - Sanitize and validate all external inputs

## Core Features

### Buying Bitcoin

```typescript
import {
  BindingLiquidSdk,
  BuyBitcoinProvider,
  type OnchainPaymentLimitsResponse,
  type PrepareBuyBitcoinResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const fetchOnchainLimitsExample = (sdk: BindingLiquidSdk) => {
  try {
    const currentLimits = sdk.fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareBuyBtc = (sdk: BindingLiquidSdk, currentLimits: OnchainPaymentLimitsResponse) => {
  try {
    const prepareRes = sdk.prepareBuyBitcoin({
      provider: BuyBitcoinProvider.Moonpay,
      amountSat: currentLimits.receive.minSat
    })

    // Check the fees are acceptable before proceeding
    const receiveFeesSat = prepareRes.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
    return prepareRes
  } catch (err) {
    console.error(err)
  }
}

const buyBtc = (sdk: BindingLiquidSdk, prepareResponse: PrepareBuyBitcoinResponse) => {
  try {
    const url = sdk.buyBitcoin({
      prepareResponse,
      redirectUrl: undefined
    })
    // Open URL in a WebView or external browser
  } catch (err) {
    console.error(err)
  }
}
```

### Fiat Currencies

```typescript
import { BindingLiquidSdk } from '@breeztech/breez-sdk-liquid-react-native'

const getFiatCurrencies = (sdk: BindingLiquidSdk) => {
  try {
    const fiatCurrencies = sdk.listFiatCurrencies()
    return fiatCurrencies
  } catch (err) {
    console.error(err)
  }
}

const getFiatRates = (sdk: BindingLiquidSdk) => {
  try {
    const fiatRates = sdk.fetchFiatRates()
    return fiatRates
  } catch (err) {
    console.error(err)
  }
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

```typescript
import {
  BindingLiquidSdk,
  PayAmount,
  type PrepareSendResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const getLightningLimits = (sdk: BindingLiquidSdk) => {
  try {
    const currentLimits = sdk.fetchLightningLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareSendPaymentLightningBolt11 = (sdk: BindingLiquidSdk) => {
  // Set the bolt11 invoice you wish to pay
  const prepareResponse = sdk.prepareSendPayment({
    destination: '<bolt11 invoice>',
    amount: undefined,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  return prepareResponse
}

const prepareSendPaymentLightningBolt12 = (sdk: BindingLiquidSdk) => {
  // Set the bolt12 offer you wish to pay
  const optionalAmount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<bolt12 offer>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  return prepareResponse
}
```

#### Liquid Payments

```typescript
const prepareSendPaymentLiquid = (sdk: BindingLiquidSdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  return prepareResponse
}

const prepareSendPaymentLiquidDrain = (sdk: BindingLiquidSdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const optionalAmount = new PayAmount.Drain()

  const prepareResponse = sdk.prepareSendPayment({
    destination: '<Liquid BIP21 or address>',
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  return prepareResponse
}
```

#### Execute Payment

For BOLT12 payments you can also include an optional payer note, which will be included in the invoice.

```typescript
const sendPaymentExample = (sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) => {
  const optionalPayerNote = '<payer note>'
  const sendResponse = sdk.sendPayment({
    prepareResponse,
    payerNote: optionalPayerNote,
    useAssetFees: undefined
  })
  const payment = sendResponse.payment
  return payment
}
```

### Receiving Payments

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

```typescript
import {
  BindingLiquidSdk,
  PaymentMethod,
  type PrepareReceiveResponse,
  ReceiveAmount
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareReceiveLightning = (sdk: BindingLiquidSdk) => {
  // Fetch the Receive lightning limits
  const currentLimits = sdk.fetchLightningLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the amount you wish the payer to send via lightning, which should be within the above limits
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.Bolt11Invoice,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  return prepareResponse
}

const prepareReceiveLightningBolt12 = (sdk: BindingLiquidSdk) => {
  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.Bolt12Offer,
    amount: undefined
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const minReceiveFeesSat = prepareResponse.feesSat
  const swapperFeerate = prepareResponse.swapperFeerate
  console.log(`Fees: ${minReceiveFeesSat} sats + ${swapperFeerate}% of the sent amount`)
  return prepareResponse
}
```

#### Onchain Payments

```typescript
const prepareReceiveOnchain = (sdk: BindingLiquidSdk) => {
  // Fetch the Onchain lightning limits
  const currentLimits = sdk.fetchOnchainLimits()
  console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
  console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

  // Set the onchain amount you wish the payer to send, which should be within the above limits
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.BitcoinAddress,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  return prepareResponse
}
```

#### Liquid Payments

```typescript
const prepareReceiveLiquid = (sdk: BindingLiquidSdk) => {
  // Create a Liquid BIP21 URI/address to receive a payment to.
  // There are no limits, but the payer amount should be greater than broadcast fees when specified
  // Note: Not setting the amount will generate a plain Liquid address
  const optionalAmount = new ReceiveAmount.Bitcoin({ payerAmountSat: BigInt(5_000) })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.LiquidAddress,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  return prepareResponse
}
```

#### Execute Receive

```typescript
const receivePaymentFromPrepared = (sdk: BindingLiquidSdk, prepareResponse: PrepareReceiveResponse) => {
  const optionalDescription = '<description>'
  const res = sdk.receivePayment({
    prepareResponse,
    description: optionalDescription,
    descriptionHash: undefined,
    payerNote: undefined
  })

  const destination = res.destination
  return destination
}
```

### LNURL Operations

#### LNURL Authentication

```typescript
import {
  BindingLiquidSdk,
  InputType_Tags,
  LnUrlCallbackStatus_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const lnurlAuthenticate = (sdk: BindingLiquidSdk) => {
  // Endpoint can also be of the form:
  // keyauth://domain.com/auth?key=val
  const lnurlAuthUrl =
        'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu'

  const input = sdk.parse(lnurlAuthUrl)
  if (input.tag === InputType_Tags.LnUrlAuth) {
    const result = sdk.lnurlAuth(input.inner.data)
    if (result.tag === LnUrlCallbackStatus_Tags.Ok) {
      console.log('Successfully authenticated')
    } else {
      console.log('Failed to authenticate')
    }
  }
}
```

#### LNURL Pay

```typescript
import {
  BindingLiquidSdk,
  InputType_Tags,
  type LnUrlPayRequestData,
  PayAmount,
  type PrepareLnUrlPayResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareLnurlPayment = (sdk: BindingLiquidSdk) => {
  // Endpoint can also be of the
  // lnurlp://domain.com/lnurl-pay?key=val
  // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
  const lnurlPayUrl = 'lightning@address.com'

  const input = sdk.parse(lnurlPayUrl)
  if (input.tag === InputType_Tags.LnUrlPay) {
    const amount = new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) })
    const optionalComment = '<comment>'
    const optionalValidateSuccessActionUrl = true

    const prepareResponse = sdk.prepareLnurlPay({
      data: input.inner.data,
      amount,
      bip353Address: input.inner.bip353Address,
      comment: optionalComment,
      validateSuccessActionUrl: optionalValidateSuccessActionUrl
    })

    // If the fees are acceptable, continue to create the LNURL Pay
    const feesSat = prepareResponse.feesSat
    console.log(`Fees: ${feesSat} sats`)
    return prepareResponse
  }
}

const prepareLnurlPayDrain = (sdk: BindingLiquidSdk, data: LnUrlPayRequestData) => {
  const amount = new PayAmount.Drain()
  const optionalComment = '<comment>'
  const optionalValidateSuccessActionUrl = true

  const prepareResponse = sdk.prepareLnurlPay({
    data,
    amount,
    comment: optionalComment,
    validateSuccessActionUrl: optionalValidateSuccessActionUrl,
    bip353Address: undefined
  })
  return prepareResponse
}

const executeLnurlPay = (sdk: BindingLiquidSdk, prepareResponse: PrepareLnUrlPayResponse) => {
  const result = sdk.lnurlPay({
    prepareResponse
  })
  return result
}
```

#### LNURL Withdraw

```typescript
import {
  BindingLiquidSdk,
  InputType_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const executeLnurlWithdraw = (sdk: BindingLiquidSdk) => {
  // Endpoint can also be of the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  const lnurlWithdrawUrl =
        'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk'

  const input = sdk.parse(lnurlWithdrawUrl)
  if (input.tag === InputType_Tags.LnUrlWithdraw) {
    const amountMsat = input.inner.data.minWithdrawable
    const lnUrlWithdrawResult = sdk.lnurlWithdraw({
      data: input.inner.data,
      amountMsat,
      description: 'comment'
    })
    return lnUrlWithdrawResult
  }
}
```

### Onchain Operations

#### Pay Onchain

```typescript
import {
  BindingLiquidSdk,
  type PreparePayOnchainResponse,
  PayAmount
} from '@breeztech/breez-sdk-liquid-react-native'

const getOnchainLimits = (sdk: BindingLiquidSdk) => {
  try {
    const currentLimits = sdk.fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareOnchainPayment = (sdk: BindingLiquidSdk) => {
  try {
    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5000) }),
      feeRateSatPerVbyte: undefined
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
    console.log(`Total fees: ${totalFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const prepareOnchainPaymentWithFeeRate = (sdk: BindingLiquidSdk) => {
  try {
    const optionalSatPerVbyte = 21

    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Bitcoin({ receiverAmountSat: BigInt(5_000) }),
      feeRateSatPerVbyte: optionalSatPerVbyte
    })

    // Check if the fees are acceptable before proceeding
    const claimFeesSat = prepareResponse.claimFeesSat
    const totalFeesSat = prepareResponse.totalFeesSat
    console.log(`Claim fees: ${claimFeesSat} sats, Total fees: ${totalFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const executePayOnchain = (sdk: BindingLiquidSdk, prepareResponse: PreparePayOnchainResponse) => {
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = sdk.payOnchain({
      address: destinationAddress,
      prepareResponse
    })
    return payOnchainRes
  } catch (err) {
    console.error(err)
  }
}
```

#### Drain Funds

```typescript
const preparePayOnchainDrain = (sdk: BindingLiquidSdk) => {
  try {
    const prepareResponse = sdk.preparePayOnchain({
      amount: new PayAmount.Drain(),
      feeRateSatPerVbyte: undefined
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
    console.log(`Total fees: ${totalFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Receive Onchain

```typescript
import {
  BindingLiquidSdk,
  type RefundableSwap,
  PaymentState,
  PaymentDetails_Tags
} from '@breeztech/breez-sdk-liquid-react-native'

const getRefundables = (sdk: BindingLiquidSdk) => {
  try {
    const refundables = sdk.listRefundables()
    return refundables
  } catch (err) {
    console.error(err)
  }
}

const executeRefund = (sdk: BindingLiquidSdk, refundable: RefundableSwap, refundTxFeeRate: number) => {
  const destinationAddress = '...'
  const feeRateSatPerVbyte = refundTxFeeRate

  const refundResponse = sdk.refund({
    swapAddress: refundable.swapAddress,
    refundAddress: destinationAddress,
    feeRateSatPerVbyte
  })
  return refundResponse
}

const rescanSwaps = (sdk: BindingLiquidSdk) => {
  try {
    sdk.rescanOnchainSwaps()
  } catch (err) {
    console.error(err)
  }
}

const getRecommendedFees = (sdk: BindingLiquidSdk) => {
  try {
    const fees = sdk.recommendedFees()
    return fees
  } catch (err) {
    console.error(err)
  }
}
```

#### Handle Fee Acceptance

```typescript
const handlePaymentsWaitingFeeAcceptance = (sdk: BindingLiquidSdk) => {
  // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
  const paymentsWaitingFeeAcceptance = sdk.listPayments({
    states: [PaymentState.WaitingFeeAcceptance],
    filters: undefined,
    fromTimestamp: undefined,
    toTimestamp: undefined,
    offset: undefined,
    limit: undefined,
    details: undefined,
    sortAscending: undefined
  })

  for (const payment of paymentsWaitingFeeAcceptance) {
    if (payment.details.tag !== PaymentDetails_Tags.Bitcoin) {
      // Only Bitcoin payments can be `WaitingFeeAcceptance`
      continue
    }

    const fetchFeesResponse = sdk.fetchPaymentProposedFees({
      swapId: payment.details.inner.swapId
    })

    console.info(
      `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
    )

    // If the user is ok with the fees, accept them, allowing the payment to proceed
    sdk.acceptPaymentProposedFees({
      response: fetchFeesResponse
    })
  }
}
```

### Non-Bitcoin Assets

```typescript
import {
  BindingLiquidSdk,
  defaultConfig,
  LiquidNetwork,
  PaymentMethod,
  PayAmount,
  type PrepareSendResponse,
  ReceiveAmount
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareAssetPayment = (sdk: BindingLiquidSdk) => {
  // Create a Liquid BIP21 URI/address to receive an asset payment to.
  // Note: Not setting the amount will generate an amountless BIP21 URI.
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount = new ReceiveAmount.Asset({
    assetId: usdtAssetId,
    payerAmount: 1.50
  })

  const prepareResponse = sdk.prepareReceivePayment({
    paymentMethod: PaymentMethod.LiquidAddress,
    amount: optionalAmount
  })

  // If the fees are acceptable, continue to create the Receive Payment
  const receiveFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${receiveFeesSat} sats`)
  return prepareResponse
}

const prepareSendPaymentAsset = (sdk: BindingLiquidSdk) => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  const destination = '<Liquid BIP21 or address>'
  // If the destination is an address or an amountless BIP21 URI,
  // you must specify an asset amount

  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  const optionalAmount = new PayAmount.Asset({
    toAsset: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: false,
    fromAsset: undefined
  })

  const prepareResponse = sdk.prepareSendPayment({
    destination,
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the fees are acceptable, continue to create the Send Payment
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  return prepareResponse
}

const prepareSendPaymentAssetWithFees = (sdk: BindingLiquidSdk) => {
  const destination = '<Liquid BIP21 or address>'
  const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
  // Set the optional estimate asset fees param to true
  const optionalAmount = new PayAmount.Asset({
    toAsset: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: true,
    fromAsset: undefined
  })

  const prepareResponse = sdk.prepareSendPayment({
    destination,
    amount: optionalAmount,
    disableMrh: undefined,
    paymentTimeoutSec: undefined
  })

  // If the asset fees are set, you can use these fees to pay to send the asset
  const sendAssetFees = prepareResponse.estimatedAssetFees
  console.log(`Estimated Fees: ~${sendAssetFees}`)

  // If the asset fees are not set, you can use the sats fees to pay to send the asset
  const sendFeesSat = prepareResponse.feesSat
  console.log(`Fees: ${sendFeesSat} sats`)
  return prepareResponse
}

const sendPaymentWithAssetFees = (sdk: BindingLiquidSdk, prepareResponse: PrepareSendResponse) => {
  // Set the use asset fees param to true
  const sendResponse = sdk.sendPayment({
    prepareResponse,
    useAssetFees: true,
    payerNote: undefined
  })
  const payment = sendResponse.payment
  return payment
}

const configureAssetMetadata = () => {
  // Create the default config
  const config = defaultConfig(
    LiquidNetwork.Mainnet,
    '<your-Breez-API-key>'
  )

  // Configure asset metadata
  config.assetMetadata = [
    {
      assetId: '18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec',
      name: 'PEGx EUR',
      ticker: 'EURx',
      precision: 8
    }
  ]
  return config
}
```
