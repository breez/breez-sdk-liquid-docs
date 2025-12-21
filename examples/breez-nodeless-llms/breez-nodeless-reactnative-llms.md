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

```javascript
import {
  addEventListener,
  defaultConfig,
  connect,
  LiquidNetwork,
  type LogEntry,
  getInfo,
  removeEventListener,
  disconnect,
  type SdkEvent,
  setLogger
} from '@breeztech/breez-sdk-liquid-react-native'

const initializeSDK = async () => {
  // Your mnemonic seed phrase for wallet recovery
  const mnemonic = '<mnemonics words>'

  // Create the default config, providing your Breez API key
  const config = await defaultConfig(
    LiquidNetwork.MAINNET,
    '<your-Breez-API-key>'
  )

  // By default in React Native the workingDir is set to:
  // `/<APPLICATION_SANDBOX_DIRECTORY>/breezSdkLiquid`
  // You can change this to another writable directory or a
  // subdirectory of the workingDir if managing multiple mnemonics.
  console.log(`Working directory: ${config.workingDir}`)
  // config.workingDir = "path to writable directory"

  await connect({ mnemonic, config }, null)
}
```

### Basic Operations

#### Fetch Balance

```javascript
const fetchBalance = async () => {
  try {
    const info = await getInfo()
    const balanceSat = info.walletInfo.balanceSat
    const pendingSendSat = info.walletInfo.pendingSendSat
    const pendingReceiveSat = info.walletInfo.pendingReceiveSat
    
    console.log(`Balance: ${balanceSat} sats`)
    console.log(`Pending Send: ${pendingSendSat} sats`)
    console.log(`Pending Receive: ${pendingReceiveSat} sats`)
  } catch (err) {
    console.error(err)
  }
}

const fetchAssetBalance = async () => {
  try {
    const info = await getInfo()
    const assetBalances = info.walletInfo.assetBalances
    return assetBalances
  } catch (err) {
    console.error(err)
  }
}
```

### Messages and Signing

```javascript
import {
  checkMessage,
  getInfo,
  signMessage
} from '@breeztech/breez-sdk-liquid-react-native'

const signMessageExample = async () => {
  try {
    const signMessageResponse = await signMessage({
      message: '<message to sign>'
    })

    // Get the wallet info for your pubkey
    const info = await getInfo()

    const signature = signMessageResponse.signature
    const pubkey = info.walletInfo.pubkey

    console.log(`Pubkey: ${pubkey}`)
    console.log(`Signature: ${signature}`)
    return { signature, pubkey }
  } catch (err) {
    console.error(err)
  }
}

const checkMessageExample = async () => {
  try {
    const checkMessageResponse = await checkMessage({
      message: '<message>',
      pubkey: '<pubkey of signer>',
      signature: '<message signature>'
    })
    const isValid = checkMessageResponse.isValid

    console.log(`Signature valid: ${isValid}`)
    return isValid
  } catch (err) {
    console.error(err)
  }
}
```

### List Payments

```javascript
import {
  getPayment,
  GetPaymentRequestVariant,
  ListPaymentDetailsVariant,
  listPayments,
  PaymentType
} from '@breeztech/breez-sdk-liquid-react-native'

const getPaymentExample = async () => {
  try {
    const paymentHash = '<payment hash>'
    const paymentByHash = await getPayment({
      type: GetPaymentRequestVariant.PAYMENT_HASH,
      paymentHash
    })

    const swapId = '<swap id>'
    const paymentBySwapId = await getPayment({
      type: GetPaymentRequestVariant.SWAP_ID,
      swapId
    })
    
    return { paymentByHash, paymentBySwapId }
  } catch (err) {
    console.error(err)
  }
}

const listAllPayments = async () => {
  try {
    const payments = await listPayments({})
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsFiltered = async () => {
  try {
    const payments = await listPayments({
      filters: [PaymentType.SEND],
      fromTimestamp: 1696880000,
      toTimestamp: 1696959200,
      offset: 0,
      limit: 50
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsDetailsAddress = async () => {
  try {
    const payments = await listPayments({
      details: {
        type: ListPaymentDetailsVariant.BITCOIN,
        address: '<Bitcoin address>'
      }
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}

const listPaymentsDetailsDestination = async () => {
  try {
    const payments = await listPayments({
      details: {
        type: ListPaymentDetailsVariant.LIQUID,
        destination: '<Liquid BIP21 or address>'
      }
    })
    return payments
  } catch (err) {
    console.error(err)
  }
}
```

### Webhook Integration

```javascript
import { registerWebhook, unregisterWebhook } from '@breeztech/breez-sdk-liquid-react-native'

const registerWebhookExample = async () => {
  try {
    await registerWebhook('https://your-nds-service.com/api/v1/notify?platform=ios&token=<PUSH_TOKEN>')
  } catch (err) {
    console.error(err)
  }
}

const unregisterWebhookExample = async () => {
  try {
    await unregisterWebhook()
  } catch (err) {
    console.error(err)
  }
}
```

### Input Parsing

```javascript
import {
  InputTypeVariant,
  parse
} from '@breeztech/breez-sdk-liquid-react-native'

const parseInputExample = async () => {
  const input = 'an input to be parsed...'

  try {
    const parsed = await parse(input)

    switch (parsed.type) {
      case InputTypeVariant.BITCOIN_ADDRESS:
        console.log(`Input is Bitcoin address ${parsed.address.address}`)
        break

      case InputTypeVariant.BOLT11:
        console.log(
          `Input is BOLT11 invoice for ${
            parsed.invoice.amountMsat != null
              ? parsed.invoice.amountMsat.toString()
              : 'unknown'
          } msats`
        )
        break

      case InputTypeVariant.LN_URL_PAY:
        console.log(
          `Input is LNURL-Pay/Lightning address accepting min/max ${parsed.data.minSendable}/${parsed.data.maxSendable} msats - BIP353 was used: ${parsed.bip353Address != null}`
        )
        break

      case InputTypeVariant.LN_URL_WITHDRAW:
        console.log(
          `Input is LNURL-Withdraw for min/max ${parsed.data.minWithdrawable}/${parsed.data.maxWithdrawable} msats`
        )
        break

      default:
        // Other input types are available
        break
    }
    
    return parsed
  } catch (err) {
    console.error(err)
  }
}

const configureParsers = async () => {
  try {
    const mnemonic = '<mnemonics words>'

    // Create the default config, providing your Breez API key
    const config = await defaultConfig(
      LiquidNetwork.MAINNET,
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

    await connect({ mnemonic, config }, null)
  } catch (err) {
    console.error(err)
  }
}
```

## React Native Component Example

Here's a complete React Native component example that implements basic wallet functionality:

```javascript
import React, { useState, useEffect } from 'react';
import { View, Text, ActivityIndicator, Button, StyleSheet, SafeAreaView, ScrollView, TextInput } from 'react-native';
import {
  connect,
  defaultConfig,
  disconnect,
  getInfo,
  LiquidNetwork,
  PaymentMethod,
  prepareReceivePayment,
  receivePayment,
  ReceiveAmountVariant,
  prepareSendPayment,
  sendPayment,
  PayAmountVariant,
  addEventListener,
  removeEventListener
} from '@breeztech/breez-sdk-liquid-react-native';

const WalletApp = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [walletInfo, setWalletInfo] = useState(null);
  const [listenerId, setListenerId] = useState(null);
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
      const config = await defaultConfig(
        LiquidNetwork.TESTNET, // Use TESTNET for development
        'your-api-key-here'
      );
      
      // Use a sample mnemonic for testing - in production you'd want to get this securely
      const mnemonic = 'sample mnemonic words here for testing only';
      
      await connect({ mnemonic, config }, null);
      
      // Set up event listener
      const onEvent = (e) => {
        console.log(`Event received: ${e.type}`);
        // Refresh wallet info when we get a relevant event
        if (
          e.type === 'PAYMENT_SUCCEEDED' || 
          e.type === 'PAYMENT_FAILED' ||
          e.type === 'SYNCED'
        ) {
          refreshWalletInfo();
        }
      };
      
      const id = await addEventListener(onEvent);
      setListenerId(id);
      
      // Get initial wallet info
      await refreshWalletInfo();
      
      setIsLoading(false);
    } catch (err) {
      console.error('Initialization error:', err);
      setError(`Initialization error: ${err.message}`);
      setIsLoading(false);
    }
  };
  
  const cleanupSDK = async () => {
    try {
      if (listenerId) {
        await removeEventListener(listenerId);
      }
      await disconnect();
    } catch (err) {
      console.error('Cleanup error:', err);
    }
  };
  
  const refreshWalletInfo = async () => {
    try {
      const info = await getInfo();
      setWalletInfo(info.walletInfo);
    } catch (err) {
      console.error('Error getting wallet info:', err);
      setError(`Error fetching wallet info: ${err.message}`);
    }
  };
  
  const handleReceive = async () => {
    try {
      setIsLoading(true);
      setError('');
      
      // Prepare receive request
      const amount = {
        type: ReceiveAmountVariant.BITCOIN,
        payerAmountSat: parseInt(amountSats, 10)
      };
      
      const prepareResponse = await prepareReceivePayment({
        paymentMethod: PaymentMethod.LIGHTNING,
        amount
      });
      
      // Check fees
      console.log(`Receive fees: ${prepareResponse.feesSat} sats`);
      
      // Create receive request
      const receiveResponse = await receivePayment({
        prepareResponse,
        description: 'Payment request from React Native app'
      });
      
      setReceiveAddress(receiveResponse.destination);
      setIsLoading(false);
    } catch (err) {
      console.error('Error creating receive request:', err);
      setError(`Error creating receive request: ${err.message}`);
      setIsLoading(false);
    }
  };
  
  const handleSend = async () => {
    try {
      if (!sendAddress) {
        setError('Please enter a destination address');
        return;
      }
      
      setIsLoading(true);
      setError('');
      
      // Prepare send payment
      const amount = {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: parseInt(amountSats, 10)
      };
      
      const prepareResponse = await prepareSendPayment({
        destination: sendAddress,
        amount
      });
      
      // Check fees
      console.log(`Send fees: ${prepareResponse.feesSat} sats`);
      
      // Confirm with user (in a real app)
      // For this example, we'll just proceed
      
      // Send payment
      const sendResponse = await sendPayment({
        prepareResponse
      });
      
      console.log('Payment sent:', sendResponse.payment);
      
      // Clear form fields
      setSendAddress('');
      
      // Refresh wallet info
      await refreshWalletInfo();
      
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
          onPress={refreshWalletInfo} 
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

```javascript
import { addEventListener, SdkEventType } from '@breeztech/breez-sdk-liquid-react-native';

// In a React component using the useEffect hook
useEffect(() => {
  let synced = false;
  let listenerId;
  
  const setupListener = async () => {
    const onEvent = (event) => {
      if (event.type === 'SYNCED') {
        synced = true;
        // Now it's safe to perform actions
        fetchWalletData();
      }
    };
    
    listenerId = await addEventListener(onEvent);
  };
  
  setupListener();
  
  return () => {
    // Cleanup when component unmounts
    if (listenerId) {
      removeEventListener(listenerId);
    }
  };
}, []);
```

### Error Handling

Always wrap your SDK method calls in try-catch blocks to properly handle errors:

```javascript
const sendPayment = async () => {
  try {
    // Call SDK method
    const result = await someMethod();
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

```javascript
import React, { useEffect } from 'react';
import { connect, disconnect } from '@breeztech/breez-sdk-liquid-react-native';

const WalletScreen = () => {
  useEffect(() => {
    const initializeSdk = async () => {
      try {
        // Initialize SDK
        await connect({
          mnemonic,
          config
        });
        
        // SDK is ready to use
      } catch (error) {
        console.error('Failed to initialize SDK:', error);
      }
    };
    
    initializeSdk();
    
    // Cleanup function
    return () => {
      const cleanupSdk = async () => {
        try {
          await disconnect();
        } catch (error) {
          console.error('Error disconnecting:', error);
        }
      };
      
      cleanupSdk();
    };
  }, []);
  
  // Rest of the component
};
```

### Fee Handling

Always check fees before executing payments and get user confirmation:

```javascript
const executePayment = async () => {
  try {
    // Get fee information
    const prepareResponse = await prepareSendPayment({
      destination,
      amount
    });
    
    const feesSat = prepareResponse.feesSat;
    
    // Ask user to confirm the fee (using an Alert or a custom modal)
    const userConfirmed = await showFeeConfirmationDialog(feesSat);
    
    if (userConfirmed) {
      // Execute payment
      const paymentResponse = await sendPayment({ prepareResponse });
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

```javascript
import { useEffect, useState } from 'react';
import { 
  addEventListener, 
  removeEventListener
} from '@breeztech/breez-sdk-liquid-react-native';

function useSdkEvents() {
  const [paymentEvents, setPaymentEvents] = useState([]);
  const [syncStatus, setSyncStatus] = useState(false);
  
  useEffect(() => {
    let listenerId;
    
    const setupListener = async () => {
      const handleEvent = (event) => {
        console.log('SDK Event:', event);
        
        switch (event.type) {
          case 'PAYMENT_SUCCEEDED':
            setPaymentEvents(prev => [...prev, event]);
            break;
          case 'SYNCED':
            setSyncStatus(true);
            break;
          case 'SYNCING':
            setSyncStatus(false);
            break;
          // Handle other event types
        }
      };
      
      listenerId = await addEventListener(handleEvent);
    };
    
    setupListener();
    
    return () => {
      if (listenerId) {
        removeEventListener(listenerId).catch(err => {
          console.error('Failed to remove event listener:', err);
        });
      }
    };
  }, []);
  
  return { paymentEvents, syncStatus };
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
   - Confirm listener is registered with `addEventListener`
   - Check event type matching in your handler
   - Add debug logging to trace events

### Debugging

Use the SDK's built-in logging system:

```javascript
import { setLogger } from '@breeztech/breez-sdk-liquid-react-native';

const setupLogging = async () => {
  try {
    const logHandler = (logEntry) => {
      if (logEntry.level !== 'TRACE') {
        console.log(`[${logEntry.level}] ${logEntry.line}`);
      }
    };
    
    await setLogger(logHandler);
  } catch (error) {
    console.error('Failed to set logger:', error);
  }
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
    console.error(err)
  }
}
```

#### Logging and Event Handling

```javascript
// Set up logging
const setupLogging = async () => {
  try {
    // Define a log handler function
    const onLogEntry = (l: LogEntry) => {
      console.log(`Received log [${l.level}]: ${l.line}`)
    }

    const subscription = await setLogger(onLogEntry)
  } catch (err) {
    console.error(err)
  }
}

// Add an event listener
const setupEventListener = async () => {
  try {
    // Define an event handler function
    const onEvent = (e: SdkEvent) => {
      console.log(`Received event: ${e.type}`)
    }

    const listenerId = await addEventListener(onEvent)
    return listenerId
  } catch (err) {
    console.error(err)
  }
}

// Remove an event listener
const removeListener = async (listenerId: string) => {
  try {
    await removeEventListener(listenerId)
  } catch (err) {
    console.error(err)
  }
}

// Clean up and disconnect
const cleanupSdk = async () => {
  try {
    await disconnect()
  } catch (err) {
    console.error(err)
  }
}
```

## Core Features

### Buying Bitcoin

```javascript
import {
  buyBitcoin,
  BuyBitcoinProvider,
  fetchOnchainLimits,
  type OnchainPaymentLimitsResponse,
  type PrepareBuyBitcoinResponse,
  prepareBuyBitcoin
} from '@breeztech/breez-sdk-liquid-react-native'

const fetchOnchainLimits = async () => {
  try {
    const currentLimits = await fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareBuyBtc = async (currentLimits: OnchainPaymentLimitsResponse) => {
  try {
    const prepareRes = await prepareBuyBitcoin({
      provider: BuyBitcoinProvider.MOONPAY,
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

const buyBtc = async (prepareResponse: PrepareBuyBitcoinResponse) => {
  try {
    const url = await buyBitcoin({
      prepareResponse
    })
    // Open URL in a WebView or external browser
  } catch (err) {
    console.error(err)
  }
}
```

### Fiat Currencies

```javascript
import {
  listFiatCurrencies,
  fetchFiatRates
} from '@breeztech/breez-sdk-liquid-react-native'

const getFiatCurrencies = async () => {
  try {
    const fiatCurrencies = await listFiatCurrencies()
    return fiatCurrencies
  } catch (err) {
    console.error(err)
  }
}

const getFiatRates = async () => {
  try {
    const fiatRates = await fetchFiatRates()
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

```javascript
import {
  fetchLightningLimits,
  prepareSendPayment,
  sendPayment,
  type PayAmount,
  PayAmountVariant,
  type PrepareSendResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const getLightningLimits = async () => {
  try {
    const currentLimits = await fetchLightningLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareSendPaymentLightningBolt11 = async () => {
  // Set the bolt11 invoice you wish to pay
  try {
    const prepareResponse = await prepareSendPayment({
      destination: '<bolt11 invoice>'
    })

    // If the fees are acceptable, continue to create the Send Payment
    const sendFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${sendFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const prepareSendPaymentLightningBolt12 = async () => {
  // Set the bolt12 offer you wish to pay
  try {
    const optionalAmount: PayAmount = {
      type: PayAmountVariant.BITCOIN,
      receiverAmountSat: 5_000
    }

    const prepareResponse = await prepareSendPayment({
      destination: '<bolt12 offer>',
      amount: optionalAmount
    })
    
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Liquid Payments

```javascript
const prepareSendPaymentLiquid = async () => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  try {
    const optionalAmount: PayAmount = {
      type: PayAmountVariant.BITCOIN,
      receiverAmountSat: 5_000
    }

    const prepareResponse = await prepareSendPayment({
      destination: '<Liquid BIP21 or address>',
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Send Payment
    const sendFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${sendFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const prepareSendPaymentLiquidDrain = async () => {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  try {
    const optionalAmount: PayAmount = {
      type: PayAmountVariant.DRAIN
    }

    const prepareResponse = await prepareSendPayment({
      destination: '<Liquid BIP21 or address>',
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Send Payment
    const sendFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${sendFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Execute Payment

For BOLT12 payments you can also include an optional payer note, which will be included in the invoice.

```javascript
const sendPayment = async (prepareResponse: PrepareSendResponse) => {
  try {
    const optionalPayerNote = '<payer note>'

    const sendResponse = await sendPayment({
      prepareResponse,
      payerNote: optionalPayerNote
    })
    const payment = sendResponse.payment
    return payment
  } catch (err) {
    console.error(err)
  }
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

```javascript
import {
  PaymentMethod,
  type PrepareReceiveResponse,
  fetchLightningLimits,
  prepareReceivePayment,
  type ReceiveAmount,
  ReceiveAmountVariant,
  receivePayment
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareReceiveLightning = async () => {
  try {
    // Fetch the Receive lightning limits
    const currentLimits = await fetchLightningLimits()
    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

    // Set the amount you wish the payer to send via lightning, which should be within the above limits
    const optionalAmount: ReceiveAmount = {
      type: ReceiveAmountVariant.BITCOIN,
      payerAmountSat: 5_000
    }

    const prepareResponse = await prepareReceivePayment({
      paymentMethod: PaymentMethod.LIGHTNING,
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Onchain Payments

```javascript
const prepareReceiveOnchain = async () => {
  try {
    // Fetch the Onchain lightning limits
    const currentLimits = await fetchOnchainLimits()
    console.log(`Minimum amount, in sats: ${currentLimits.receive.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.receive.maxSat}`)

    // Set the onchain amount you wish the payer to send, which should be within the above limits
    const optionalAmount: ReceiveAmount = {
      type: ReceiveAmountVariant.BITCOIN,
      payerAmountSat: 5_000
    }

    const prepareResponse = await prepareReceivePayment({
      paymentMethod: PaymentMethod.BITCOIN_ADDRESS,
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Liquid Payments

```javascript
const prepareReceiveLiquid = async () => {
  try {
    // Create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    // Note: Not setting the amount will generate a plain Liquid address
    const optionalAmount: ReceiveAmount = {
      type: ReceiveAmountVariant.BITCOIN,
      payerAmountSat: 5_000
    }

    const prepareResponse = await prepareReceivePayment({
      paymentMethod: PaymentMethod.LIQUID_ADDRESS,
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}
```

#### Execute Receive

```javascript
const receivePaymentFromPrepared = async (prepareResponse: PrepareReceiveResponse) => {
  try {
    const optionalDescription = '<description>'
    const res = await receivePayment({
      prepareResponse,
      description: optionalDescription
    })

    const destination = res.destination
    return destination
  } catch (err) {
    console.error(err)
  }
}
```

### LNURL Operations

#### LNURL Authentication

```javascript
import {
  InputTypeVariant,
  lnurlAuth,
  LnUrlCallbackStatusVariant,
  parse
} from '@breeztech/breez-sdk-liquid-react-native'

const lnurlAuthenticate = async () => {
  // Endpoint can also be of the form:
  // keyauth://domain.com/auth?key=val
  const lnurlAuthUrl =
        'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu'

  try {
    const input = await parse(lnurlAuthUrl)
    if (input.type === InputTypeVariant.LN_URL_AUTH) {
      const result = await lnurlAuth(input.data)
      if (result.type === LnUrlCallbackStatusVariant.OK) {
        console.log('Successfully authenticated')
      } else {
        console.log('Failed to authenticate')
      }
    }
  } catch (err) {
    console.error(err)
  }
}
```

#### LNURL Pay

```javascript
import {
  InputTypeVariant,
  lnurlPay,
  type LnUrlPayRequestData,
  parse,
  type PayAmount,
  PayAmountVariant,
  prepareLnurlPay,
  type PrepareLnUrlPayResponse
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareLnurlPayment = async () => {
  // Endpoint can also be of the
  // lnurlp://domain.com/lnurl-pay?key=val
  // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
  const lnurlPayUrl = 'lightning@address.com'

  try {
    const input = await parse(lnurlPayUrl)
    if (input.type === InputTypeVariant.LN_URL_PAY) {
      const amount: PayAmount = {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: 5_000
      }
      const optionalComment = '<comment>'
      const optionalValidateSuccessActionUrl = true

      const prepareResponse = await prepareLnurlPay({
        data: input.data,
        amount,
        bip353Address: input.bip353Address,
        comment: optionalComment,
        validateSuccessActionUrl: optionalValidateSuccessActionUrl
      })

      // If the fees are acceptable, continue to create the LNURL Pay
      const feesSat = prepareResponse.feesSat
      console.log(`Fees: ${feesSat} sats`)
      return prepareResponse
    }
  } catch (err) {
    console.error(err)
  }
}

const executeLnurlPay = async (prepareResponse: PrepareLnUrlPayResponse) => {
  try {
    const result = await lnurlPay({
      prepareResponse
    })
    return result
  } catch (err) {
    console.error(err)
  }
}
```

#### LNURL Withdraw

```javascript
import {
  InputTypeVariant,
  lnurlWithdraw,
  parse
} from '@breeztech/breez-sdk-liquid-react-native'

const executeLnurlWithdraw = async () => {
  // Endpoint can also be of the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  const lnurlWithdrawUrl =
        'lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk'

  try {
    const input = await parse(lnurlWithdrawUrl)
    if (input.type === InputTypeVariant.LN_URL_WITHDRAW) {
      const amountMsat = input.data.minWithdrawable
      const lnUrlWithdrawResult = await lnurlWithdraw({
        data: input.data,
        amountMsat,
        description: 'comment'
      })
      return lnUrlWithdrawResult
    }
  } catch (err) {
    console.error(err)
  }
}
```

### Onchain Operations

#### Pay Onchain

```javascript
import {
  type PreparePayOnchainResponse,
  fetchOnchainLimits,
  preparePayOnchain,
  payOnchain,
  PayAmountVariant
} from '@breeztech/breez-sdk-liquid-react-native'

const getOnchainLimits = async () => {
  try {
    const currentLimits = await fetchOnchainLimits()

    console.log(`Minimum amount, in sats: ${currentLimits.send.minSat}`)
    console.log(`Maximum amount, in sats: ${currentLimits.send.maxSat}`)
    return currentLimits
  } catch (err) {
    console.error(err)
  }
}

const prepareOnchainPayment = async () => {
  try {
    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: 5_000
      }
    })

    // Check if the fees are acceptable before proceeding
    const totalFeesSat = prepareResponse.totalFeesSat
    console.log(`Total fees: ${totalFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const prepareOnchainPaymentWithFeeRate = async () => {
  try {
    const optionalSatPerVbyte = 21

    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.BITCOIN,
        receiverAmountSat: 5_000
      },
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

const executePayOnchain = async (prepareResponse: PreparePayOnchainResponse) => {
  try {
    const destinationAddress = 'bc1..'

    const payOnchainRes = await payOnchain({
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

```javascript
const preparePayOnchainDrain = async () => {
  try {
    const prepareResponse = await preparePayOnchain({
      amount: {
        type: PayAmountVariant.DRAIN
      }
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

```javascript
import {
  listRefundables,
  rescanOnchainSwaps,
  type RefundableSwap,
  refund,
  recommendedFees,
  listPayments,
  fetchPaymentProposedFees,
  acceptPaymentProposedFees,
  PaymentState,
  PaymentDetailsVariant
} from '@breeztech/breez-sdk-liquid-react-native'

const getRefundables = async () => {
  try {
    const refundables = await listRefundables()
    return refundables
  } catch (err) {
    console.error(err)
  }
}

const executeRefund = async (refundable: RefundableSwap, refundTxFeeRate: number) => {
  try {
    const destinationAddress = '...'
    const feeRateSatPerVbyte = refundTxFeeRate

    const refundResponse = await refund({
      swapAddress: refundable.swapAddress,
      refundAddress: destinationAddress,
      feeRateSatPerVbyte
    })
    return refundResponse
  } catch (err) {
    console.error(err)
  }
}

const rescanSwaps = async () => {
  try {
    await rescanOnchainSwaps()
  } catch (err) {
    console.error(err)
  }
}

const getRecommendedFees = async () => {
  try {
    const fees = await recommendedFees()
    return fees
  } catch (err) {
    console.error(err)
  }
}
```

#### Handle Fee Acceptance

```javascript
const handlePaymentsWaitingFeeAcceptance = async () => {
  try {
    // Payments on hold waiting for fee acceptance have the state WAITING_FEE_ACCEPTANCE
    const paymentsWaitingFeeAcceptance = await listPayments({
      states: [PaymentState.WAITING_FEE_ACCEPTANCE]
    })

    for (const payment of paymentsWaitingFeeAcceptance) {
      if (payment.details.type !== PaymentDetailsVariant.BITCOIN) {
        // Only Bitcoin payments can be `WAITING_FEE_ACCEPTANCE`
        continue
      }

      const fetchFeesResponse = await fetchPaymentProposedFees({
        swapId: payment.details.swapId
      })

      console.info(
        `Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}`
      )

      // If the user is ok with the fees, accept them, allowing the payment to proceed
      await acceptPaymentProposedFees({
        response: fetchFeesResponse
      })
    }
  } catch (err) {
    console.error(err)
  }
}
```

### Non-Bitcoin Assets

```javascript
import {
  defaultConfig,
  getInfo,
  LiquidNetwork,
  PaymentMethod,
  type PayAmount,
  PayAmountVariant,
  prepareSendPayment,
  prepareReceivePayment,
  type ReceiveAmount,
  ReceiveAmountVariant
} from '@breeztech/breez-sdk-liquid-react-native'

const prepareAssetPayment = async () => {
  try {
    // Create a Liquid BIP21 URI/address to receive an asset payment to.
    // Note: Not setting the amount will generate an amountless BIP21 URI.
    const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
    const optionalAmount: ReceiveAmount = {
      type: ReceiveAmountVariant.ASSET,
      assetId: usdtAssetId,
      payerAmount: 1.50
    }

    const prepareResponse = await prepareReceivePayment({
      paymentMethod: PaymentMethod.LIQUID_ADDRESS,
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Receive Payment
    const receiveFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${receiveFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const prepareSendPaymentAsset = async () => {
  try {
    // Set the Liquid BIP21 or Liquid address you wish to pay
    const destination = '<Liquid BIP21 or address>'
    // If the destination is an address or an amountless BIP21 URI,
    // you must specifiy an asset amount

    const usdtAssetId = 'ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2'
    const optionalAmount: PayAmount = {
      type: PayAmountVariant.ASSET,
      assetId: usdtAssetId,
      receiverAmount: 1.50
    }

    const prepareResponse = await prepareSendPayment({
      destination,
      amount: optionalAmount
    })

    // If the fees are acceptable, continue to create the Send Payment
    const sendFeesSat = prepareResponse.feesSat
    console.log(`Fees: ${sendFeesSat} sats`)
    return prepareResponse
  } catch (err) {
    console.error(err)
  }
}

const configureAssetMetadata = async () => {
  try {
    // Create the default config
    const config = await defaultConfig(
      LiquidNetwork.MAINNET,
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
  } catch (err) {