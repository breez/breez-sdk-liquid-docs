# Breez SDK Nodeless (Liquid implementation) Documentation

This comprehensive document provides all the context needed to build applications with the Dart bindings of Breez SDK Nodeless, a toolkit for integrating Bitcoin, Lightning Network, and Liquid Network functionality into your applications.

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

```yaml
# In your pubspec.yaml
dependencies:
  flutter_breez_liquid: 
    git:
      url: https://github.com/breez/breez-sdk-liquid-flutter
      tag: 0.7.2
```

### Guidelines
- **always make sure the sdk instance is synced before performing any actions**
- **Add logging**: Add sufficient logging into your application to diagnose any issues users are having.
- **Display pending payments**: Payments always contain a status field that can be used to determine if the payment was completed or not. Make sure you handle the case where the payment is still pending by showing the correct status to the user.
- **Enable swap refunds**: Swaps that are the result of receiving an On-Chain Transaction may not be completed and change to `Refundable` state. Make sure you handle this case correctly by allowing the user to retry the refund with different fees as long as the refund is not confirmed.
- **Expose swap fees**: When sending or receiving on-chain, make sure to clearly show the expected fees involved, as well as the send / receive amounts.

### Initializing the SDK

To get started with Breez SDK Nodeless (Liquid implementation), you need to initialize the SDK with your configuration:

```dart
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> initializeSDK() async {
  // Your mnemonic seed phrase for wallet recovery
  String mnemonic = "<mnemonic words>";

  // Create the default config, providing your Breez API key
  Config config = defaultConfig(
    network: LiquidNetwork.mainnet, 
    breezApiKey: "<your-Breez-API-key>"
  );

  // Customize the config object according to your needs
  config = config.copyWith(workingDir: "path to an existing directory");

  ConnectRequest connectRequest = ConnectRequest(mnemonic: mnemonic, config: config);

  try {
    await breezSDKLiquid.connect(req: connectRequest);
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

### Custom Signer Support

If you prefer to manage your own keys, you can use a custom signer:

```dart
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

class CustomSigner implements Signer {
  @override
  Future<String> sign(String message) async {
    // Your custom signing implementation
    return "<signed message>";
  }
}

Future<void> connectWithCustomSigner() async {
  CustomSigner signer = CustomSigner();
  
  // Create the default config, providing your Breez API key
  Config config = defaultConfig(
    network: LiquidNetwork.mainnet, 
    breezApiKey: "<your-Breez-API-key>"
  );

  // Customize the config object according to your needs
  config = config.copyWith(workingDir: "path to an existing directory");

  try {
    ConnectWithSignerRequest request = ConnectWithSignerRequest(config: config);
    await breezSDKLiquid.connectWithSigner(req: request, signer: signer);
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

### Basic Operations

#### Fetch Balance
- **always make sure the sdk instance is synced before performing any actions**

```dart
Future<void> fetchBalance() async {
  try {
    GetInfoResponse? info = await breezSDKLiquid.instance!.getInfo();
    BigInt balanceSat = info.walletInfo.balanceSat;
    BigInt pendingSendSat = info.walletInfo.pendingSendSat;
    BigInt pendingReceiveSat = info.walletInfo.pendingReceiveSat;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Logging and Event Handling

```dart
// Set up logging
void initializeLogStream() {
  // Initialize the log stream
  Stream<LogEntry>? breezLogStream = breezLogStream().asBroadcastStream();
  
  // Subscribe to the log stream
  breezLogStream?.listen((logEntry) {
    print("${logEntry.level}: ${logEntry.line}");
  }, onError: (error) {
    print("Log stream error: $error");
  });
}

// Define an event listener
class SdkListener extends EventListener {
  @override
  void onEvent(SdkEvent sdkEvent) {
    print("Received event: $sdkEvent");
    
    if (sdkEvent is SdkEvent_Synced) {
      print("SDK is synced");
    } else if (sdkEvent is SdkEvent_PaymentSucceeded) {
      print("Payment succeeded: ${sdkEvent.details.paymentHash}");
    } else if (sdkEvent is SdkEvent_PaymentFailed) {
      print("Payment failed: ${sdkEvent.details.error}");
    }
  }
}

// Add an event listener
Future<void> addEventListeners() async {
  try {
    SdkListener listener = SdkListener();
    breezSDKLiquid.instance!.addEventListener().listen(listener.onEvent);
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

## Core Features

### Buying Bitcoin

```dart
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<OnchainPaymentLimitsResponse> fetchOnchainLimits() async {
  try {
    OnchainPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
    print("Minimum amount: ${currentLimits.receive.minSat} sats");
    print("Maximum amount: ${currentLimits.receive.maxSat} sats");
    return currentLimits;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PrepareBuyBitcoinResponse> prepareBuyBitcoin(OnchainPaymentLimitsResponse currentLimits) async {
  try {
    PrepareBuyBitcoinRequest req =
        PrepareBuyBitcoinRequest(provider: BuyBitcoinProvider.moonpay, amountSat: currentLimits.receive.minSat);
    PrepareBuyBitcoinResponse prepareRes = await breezSDKLiquid.instance!.prepareBuyBitcoin(req: req);

    // Check the fees are acceptable before proceeding
    BigInt receiveFeesSat = prepareRes.feesSat;
    print("Fees: $receiveFeesSat sats");
    return prepareRes;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<String> buyBitcoin(PrepareBuyBitcoinResponse prepareResponse) async {
  try {
    BuyBitcoinRequest req = BuyBitcoinRequest(prepareResponse: prepareResponse);
    String url = await breezSDKLiquid.instance!.buyBitcoin(req: req);
    return url;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

### Fiat Currencies

```dart
Future<List<FiatCurrency>> listFiatCurrencies() async {
  try {
    List<FiatCurrency> fiatCurrencyList = await breezSDKLiquid.instance!.listFiatCurrencies();
    return fiatCurrencyList;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<Map<String, Rate>> fetchFiatRates() async {
  try {
    final List<Rate> rates = await breezSDKLiquid.instance!.fetchFiatRates();
    final fiatRatesMap = rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
    // print your desired rate
    print(fiatRatesMap["USD"]?.value);
    return fiatRatesMap;
  } catch (error) {
    print(error);
    rethrow;
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

```dart
Future<LightningPaymentLimitsResponse> getLightningLimits() async {
  try {
    LightningPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchLightningLimits();
    print("Minimum amount: ${currentLimits.send.minSat} sats");
    print("Maximum amount: ${currentLimits.send.maxSat} sats");
    return currentLimits;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PrepareSendResponse> prepareSendPaymentLightningBolt11() async {
  // Set the bolt11 invoice you wish to pay
  String destination = "<bolt11 invoice>";
  
  try {
    PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
      req: PrepareSendRequest(destination: destination),
    );

    // If the fees are acceptable, continue to create the Send Payment
    BigInt sendFeesSat = prepareSendResponse.feesSat;
    print("Fees: $sendFeesSat sats");
    return prepareSendResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PrepareSendResponse> prepareSendPaymentLightningBolt12() async {
  // Set the bolt12 offer you wish to pay
  String destination = "<bolt12 offer>";
  
  try {
    PayAmount_Bitcoin optionalAmount = PayAmount_Bitcoin(receiverAmountSat: BigInt.from(5000));
    PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
      req: PrepareSendRequest(destination: destination, amount: optionalAmount),
    );
    return prepareSendResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Liquid Payments

```dart
Future<PrepareSendResponse> prepareSendPaymentLiquid() async {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  String destination = "<Liquid BIP21 or address>";
  
  try {
    PayAmount_Bitcoin optionalAmount = PayAmount_Bitcoin(receiverAmountSat: BigInt.from(5000));
    PrepareSendRequest prepareSendRequest = PrepareSendRequest(
      destination: destination,
      amount: optionalAmount,
    );

    PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
      req: prepareSendRequest,
    );

    // If the fees are acceptable, continue to create the Send Payment
    BigInt sendFeesSat = prepareSendResponse.feesSat;
    print("Fees: $sendFeesSat sats");
    return prepareSendResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PrepareSendResponse> prepareSendPaymentLiquidDrain() async {
  // Set the Liquid BIP21 or Liquid address you wish to pay
  String destination = "<Liquid BIP21 or address>";
  
  try {
    PayAmount_Drain optionalAmount = PayAmount_Drain();
    PrepareSendRequest prepareSendRequest = PrepareSendRequest(
      destination: destination,
      amount: optionalAmount,
    );

    PrepareSendResponse prepareSendResponse = await breezSDKLiquid.instance!.prepareSendPayment(
      req: prepareSendRequest,
    );

    // If the fees are acceptable, continue to create the Send Payment
    BigInt sendFeesSat = prepareSendResponse.feesSat;
    print("Fees: $sendFeesSat sats");
    return prepareSendResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Execute Payment

For BOLT12 payments you can also include an optional payer note, which will be included in the invoice.

- **always make sure the sdk instance is synced before performing any actions**

```dart
Future<SendPaymentResponse> sendPayment({required PrepareSendResponse prepareResponse}) async {
  try {
    String optionalPayerNote = "<payer note>";
    SendPaymentResponse sendPaymentResponse = await breezSDKLiquid.instance!.sendPayment(
      req: SendPaymentRequest(prepareResponse: prepareResponse, payerNote: optionalPayerNote),
    );
    Payment payment = sendPaymentResponse.payment;
    return sendPaymentResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
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

1. **Lockup Transaction Fee:** ~27 sats (0.1 sat/discount vbyte).
2. **Claim Transaction Fee:** ~20 sats (0.1 sat/discount vbyte).
3. **Swap Service Fee:** 0.25% fee on the amount received.

Note: swap service fee is dynamic and can change. Currently, it is 0.25%.

> **Example**: If the sender sends 10k sats, the fee for the end-user would be:
> 
> - 27 sats [Lockup Transaction Fee] + 20 sats [Claim Transaction Fee] + 25 sats [Swapper Service Fee] = 72 sats

```dart
Future<PrepareReceiveResponse> prepareReceivePaymentLightning() async {
  try {
    // Fetch the Receive lightning limits
    LightningPaymentLimitsResponse currentLightningLimits =
        await breezSDKLiquid.instance!.fetchLightningLimits();
    print("Minimum amount: ${currentLightningLimits.receive.minSat} sats");
    print("Maximum amount: ${currentLightningLimits.receive.maxSat} sats");

    // Create an invoice and set the amount you wish the payer to send
    ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: BigInt.from(5000));
    PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
      req: PrepareReceiveRequest(
        paymentMethod: PaymentMethod.lightning,
        amount: optionalAmount,
      ),
    );

    // If the fees are acceptable, continue to create the Receive Payment
    BigInt receiveFeesSat = prepareResponse.feesSat;
    print("Fees: $receiveFeesSat sats");
    return prepareResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Onchain Payments

```dart
Future<PrepareReceiveResponse> prepareReceivePaymentOnchain() async {
  try {
    // Fetch the Receive onchain limits
    OnchainPaymentLimitsResponse currentOnchainLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
    print("Minimum amount: ${currentOnchainLimits.receive.minSat} sats");
    print("Maximum amount: ${currentOnchainLimits.receive.maxSat} sats");

    // Or create a cross-chain transfer (Liquid to Bitcoin) via chain swap
    ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: BigInt.from(5000));
    PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
      req: PrepareReceiveRequest(
        paymentMethod: PaymentMethod.bitcoinAddress,
        amount: optionalAmount,
      ),
    );

    // If the fees are acceptable, continue to create the Receive Payment
    BigInt receiveFeesSat = prepareResponse.feesSat;
    print("Fees: $receiveFeesSat sats");
    return prepareResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Liquid Payments

```dart
Future<PrepareReceiveResponse> prepareReceivePaymentLiquid() async {
  try {
    // Create a Liquid BIP21 URI/address to receive a payment to.
    // There are no limits, but the payer amount should be greater than broadcast fees when specified
    // Note: Not setting the amount will generate a plain Liquid address
    ReceiveAmount_Bitcoin optionalAmount = ReceiveAmount_Bitcoin(payerAmountSat: BigInt.from(5000));
    PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
      req: PrepareReceiveRequest(
        paymentMethod: PaymentMethod.liquidAddress,
        amount: optionalAmount,
      ),
    );

    // If the fees are acceptable, continue to create the Receive Payment
    BigInt receiveFeesSat = prepareResponse.feesSat;
    print("Fees: $receiveFeesSat sats");
    return prepareResponse;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Execute Receive

```dart
Future<ReceivePaymentResponse> receivePayment(PrepareReceiveResponse prepareResponse) async {
  try {
    String optionalDescription = "<description>";
    ReceivePaymentResponse res = await breezSDKLiquid.instance!.receivePayment(
      req: ReceivePaymentRequest(
        description: optionalDescription,
        prepareResponse: prepareResponse,
      ),
    );

    String destination = res.destination;
    print(destination);
    return res;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

### LNURL Operations

#### LNURL Authentication

```dart
Future<void> lnurlAuth() async {
  // Endpoint can also be of the form:
  // keyauth://domain.com/auth?key=val
  String lnurlAuthUrl =
      "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";

  try {
    InputType inputType = await breezSDKLiquid.instance!.parse(input: lnurlAuthUrl);
    if (inputType is InputType_LnUrlAuth) {
      LnUrlCallbackStatus result = await breezSDKLiquid.instance!.lnurlAuth(reqData: inputType.data);
      if (result is LnUrlCallbackStatus_Ok) {
        print("Successfully authenticated");
      } else {
        print("Failed to authenticate");
      }
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### LNURL Pay

```dart
Future<void> prepareLnurlPay() async {
  // Endpoint can also be of the form:
  // lnurlp://domain.com/lnurl-pay?key=val
  String lnurlPayUrl = "lightning@address.com";

  try {
    InputType inputType = await breezSDKLiquid.instance!.parse(input: lnurlPayUrl);
    if (inputType is InputType_LnUrlPay) {
      PayAmount_Bitcoin amount = PayAmount_Bitcoin(receiverAmountSat: BigInt.from(5000));
      String optionalComment = "<comment>";
      bool optionalValidateSuccessActionUrl = true;

      PrepareLnUrlPayRequest req = PrepareLnUrlPayRequest(
        data: inputType.data,
        amount: amount,
        bip353Address: inputType.bip353Address,
        comment: optionalComment,
        validateSuccessActionUrl: optionalValidateSuccessActionUrl,
      );
      PrepareLnUrlPayResponse prepareResponse = await breezSDKLiquid.instance!.prepareLnurlPay(req: req);

      // If the fees are acceptable, continue to create the LNURL Pay
      BigInt feesSat = prepareResponse.feesSat;
      print("Fees: $feesSat sats");
      return prepareResponse;
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<void> lnurlPay({required PrepareLnUrlPayResponse prepareResponse}) async {
  try {
    LnUrlPayResult result = await breezSDKLiquid.instance!.lnurlPay(
      req: LnUrlPayRequest(prepareResponse: prepareResponse),
    );
    print(result);
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### LNURL Withdraw

```dart
Future<void> lnurlWithdraw() async {
  // Endpoint can also be of the form:
  // lnurlw://domain.com/lnurl-withdraw?key=val
  String lnurlWithdrawUrl =
      "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk";

  try {
    InputType inputType = await breezSDKLiquid.instance!.parse(input: lnurlWithdrawUrl);
    if (inputType is InputType_LnUrlWithdraw) {
      BigInt amountMsat = inputType.data.minWithdrawable;
      LnUrlWithdrawRequest req = LnUrlWithdrawRequest(
        data: inputType.data,
        amountMsat: amountMsat,
        description: "<description>",
      );
      LnUrlWithdrawResult result = await breezSDKLiquid.instance!.lnurlWithdraw(req: req);
      print(result.data);
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

### Onchain Operations

#### Pay Onchain

```dart
Future<OnchainPaymentLimitsResponse> getOnchainLimits() async {
  try {
    OnchainPaymentLimitsResponse currentLimits = await breezSDKLiquid.instance!.fetchOnchainLimits();
    print("Minimum amount: ${currentLimits.send.minSat} sats");
    print("Maximum amount: ${currentLimits.send.maxSat} sats");
    return currentLimits;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PreparePayOnchainResponse> preparePayOnchain() async {
  try {
    PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
      amount: PayAmount_Bitcoin(receiverAmountSat: BigInt.from(5000)),
    );
    PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
      req: preparePayOnchainRequest,
    );

    // Check if the fees are acceptable before proceeding
    BigInt totalFeesSat = prepareRes.totalFeesSat;
    print(totalFeesSat);
    return prepareRes;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<PreparePayOnchainResponse> preparePayOnchainFeeRate() async {
  try {
    int optionalSatPerVbyte = 21;

    PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
      amount: PayAmount_Bitcoin(receiverAmountSat: BigInt.from(5000)),
      feeRateSatPerVbyte: optionalSatPerVbyte,
    );
    PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
      req: preparePayOnchainRequest,
    );

    // Check if the fees are acceptable before proceeding
    BigInt claimFeesSat = prepareRes.claimFeesSat;
    BigInt totalFeesSat = prepareRes.totalFeesSat;
    print(claimFeesSat);
    print(totalFeesSat);
    return prepareRes;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<SendPaymentResponse> startReverseSwap({
  required PreparePayOnchainResponse prepareRes,
}) async {
  try {
    String destinationAddress = "bc1..";

    PayOnchainRequest req = PayOnchainRequest(
      address: destinationAddress,
      prepareResponse: prepareRes,
    );
    SendPaymentResponse res = await breezSDKLiquid.instance!.payOnchain(req: req);
    return res;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Drain Funds

```dart
Future<PreparePayOnchainResponse> preparePayOnchainDrain() async {
  try {
    PreparePayOnchainRequest preparePayOnchainRequest = PreparePayOnchainRequest(
      amount: PayAmount_Drain(),
    );
    PreparePayOnchainResponse prepareRes = await breezSDKLiquid.instance!.preparePayOnchain(
      req: preparePayOnchainRequest,
    );

    // Check if the fees are acceptable before proceeding
    BigInt totalFeesSat = prepareRes.totalFeesSat;
    print(totalFeesSat);
    return prepareRes;
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Receive Onchain

```dart
Future<List<RefundableSwap>> listRefundables() async {
  try {
    List<RefundableSwap> refundables = await breezSDKLiquid.instance!.listRefundables();
    return refundables;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<RefundResponse> executeRefund({
  required int refundTxFeeRate,
  required RefundableSwap refundable,
}) async {
  try {
    String destinationAddress = "...";
    int feeRateSatPerVbyte = refundTxFeeRate;

    RefundRequest req = RefundRequest(
      swapAddress: refundable.swapAddress,
      refundAddress: destinationAddress,
      feeRateSatPerVbyte: feeRateSatPerVbyte,
    );
    RefundResponse resp = await breezSDKLiquid.instance!.refund(req: req);
    print(resp.refundTxId);
    return resp;
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future rescanSwaps() async {
  try {
    await breezSDKLiquid.instance!.rescanOnchainSwaps();
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future recommendedFees() async {
  try {
    RecommendedFees fees = await breezSDKLiquid.instance!.recommendedFees();
    print(fees);
  } catch (error) {
    print(error);
    rethrow;
  }
}
```

#### Handle Fee Acceptance

```dart
Future<void> handlePaymentsWaitingFeeAcceptance() async {
  try {
    // Payments on hold waiting for fee acceptance have the state WaitingFeeAcceptance
    List<Payment> paymentsWaitingFeeAcceptance = await breezSDKLiquid.instance!.listPayments(
      req: ListPaymentsRequest(
        states: [PaymentState.waitingFeeAcceptance],
      ),
    );

    for (Payment payment in paymentsWaitingFeeAcceptance) {
      if (payment.details is! PaymentDetails_Bitcoin) {
        // Only Bitcoin payments can be `WaitingFeeAcceptance`
        continue;
      }

      PaymentDetails_Bitcoin details = payment.details as PaymentDetails_Bitcoin;
      FetchPaymentProposedFeesResponse fetchFeesResponse =
          await breezSDKLiquid.instance!.fetchPaymentProposedFees(
        req: FetchPaymentProposedFeesRequest(
          swapId: details.swapId,
        ),
      );

      print(
        "Payer sent ${fetchFeesResponse.payerAmountSat} and currently proposed fees are ${fetchFeesResponse.feesSat}",
      );

      // If the user is ok with the fees, accept them, allowing the payment to proceed
      await breezSDKLiquid.instance!.acceptPaymentProposedFees(
        req: AcceptPaymentProposedFeesRequest(
          response: fetchFeesResponse,
        ),
      );
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}