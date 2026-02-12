import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<PrepareReceiveResponse> prepareReceivePaymentAsset() async {
  // ANCHOR: prepare-receive-payment-asset
  // Create a Liquid BIP21 URI/address to receive an asset payment to.
  // Note: Not setting the amount will generate an amountless BIP21 URI.
  String usdtAssetId =
      "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  ReceiveAmount_Asset optionalAmount =
      ReceiveAmount_Asset(assetId: usdtAssetId, payerAmount: 1.50);
  PrepareReceiveRequest prepareReceiveRequest = PrepareReceiveRequest(
    paymentMethod: PaymentMethod.liquidAddress,
    amount: optionalAmount,
  );

  PrepareReceiveResponse prepareResponse =
      await breezSDKLiquid.instance!.prepareReceivePayment(
    req: prepareReceiveRequest,
  );

  // If the fees are acceptable, continue to create the Receive Payment
  BigInt receiveFeesSat = prepareResponse.feesSat;
  print("Fees: $receiveFeesSat sats");
  // ANCHOR_END: prepare-receive-payment-asset
  return prepareResponse;
}

Future<PrepareSendResponse> prepareSendPaymentAsset() async {
  // ANCHOR: prepare-send-payment-asset
  // Set the Liquid BIP21 or Liquid address you wish to pay
  String destination = "<Liquid BIP21 or address>";
  // If the destination is an address or an amountless BIP21 URI,
  // you must specify an asset amount
  String usdtAssetId =
      "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  PayAmount_Asset optionalAmount = PayAmount_Asset(
    toAsset: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: false,
    fromAsset: null,
  );
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: destination,
    amount: optionalAmount,
    disableMrh: null,
    paymentTimeoutSec: null,
  );

  PrepareSendResponse prepareSendResponse =
      await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  // If the fees are acceptable, continue to create the Send Payment
  BigInt? sendFeesSat = prepareSendResponse.feesSat;
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-asset
  return prepareSendResponse;
}

Future<PrepareSendResponse> prepareSendPaymentAssetFees() async {
  // ANCHOR: prepare-send-payment-asset-fees
  String destination = "<Liquid BIP21 or address>";
  String usdtAssetId =
      "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  // Set the optional estimate asset fees param to true
  PayAmount_Asset optionalAmount = PayAmount_Asset(
    toAsset: usdtAssetId,
    receiverAmount: 1.50,
    estimateAssetFees: true,
    fromAsset: null,
  );
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: destination,
    amount: optionalAmount,
    disableMrh: null,
    paymentTimeoutSec: null,
  );

  PrepareSendResponse prepareSendResponse =
      await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  // If the asset fees are set, you can use these fees to pay to send the asset
  double? sendAssetFees = prepareSendResponse.estimatedAssetFees;
  print("Estimated Fees: ~$sendAssetFees");

  // If the asset fess are not set, you can use the sats fees to pay to send the asset
  BigInt? sendFeesSat = prepareSendResponse.feesSat;
  print("Fees: $sendFeesSat sats");
  // ANCHOR_END: prepare-send-payment-asset-fees
  return prepareSendResponse;
}

Future<SendPaymentResponse> sendPaymentFees(
    {required PrepareSendResponse prepareResponse}) async {
  // ANCHOR: send-payment-fees
  // Set the use asset fees param to true
  SendPaymentRequest sendPaymentRequest = SendPaymentRequest(
    prepareResponse: prepareResponse,
    useAssetFees: true,
  );

  SendPaymentResponse sendPaymentResponse =
      await breezSDKLiquid.instance!.sendPayment(
    req: sendPaymentRequest,
  );
  Payment payment = sendPaymentResponse.payment;
  // ANCHOR_END: send-payment-fees
  print(payment);
  return sendPaymentResponse;
}

Future<void> fetchAssetBalance() async {
  // ANCHOR: fetch-asset-balance
  GetInfoResponse? info = await breezSDKLiquid.instance!.getInfo();
  List<AssetBalance> assetBalances = info.walletInfo.assetBalances;
  // ANCHOR_END: fetch-asset-balance
  print(assetBalances);
}

Future<SendPaymentResponse> sendSelfPaymentAsset() async {
  // ANCHOR: send-self-payment-asset
  // Create a Liquid address to receive to
  PrepareReceiveRequest prepareReceiveRequest = PrepareReceiveRequest(
    paymentMethod: PaymentMethod.liquidAddress,
    amount: null,
  );

  PrepareReceiveResponse prepareReceiveRes =
      await breezSDKLiquid.instance!.prepareReceivePayment(
    req: prepareReceiveRequest,
  );

  ReceivePaymentRequest receivePaymentRequest = ReceivePaymentRequest(
    prepareResponse: prepareReceiveRes,
    description: null,
    useDescriptionHash: null,
    payerNote: null,
  );

  ReceivePaymentResponse receiveRes =
      await breezSDKLiquid.instance!.receivePayment(
    req: receivePaymentRequest,
  );

  // Swap your funds to the address we've created
  String usdtAssetId =
      "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  String btcAssetId =
      "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d";
  PrepareSendRequest prepareSendRequest = PrepareSendRequest(
    destination: receiveRes.destination,
    amount: PayAmount_Asset(
      toAsset: usdtAssetId,
      // We want to receive 1.5 USDt
      receiverAmount: 1.5,
      estimateAssetFees: null,
      fromAsset: btcAssetId,
    ),
    disableMrh: null,
    paymentTimeoutSec: null,
  );

  PrepareSendResponse prepareSendRes =
      await breezSDKLiquid.instance!.prepareSendPayment(
    req: prepareSendRequest,
  );

  SendPaymentRequest sendPaymentRequest = SendPaymentRequest(
    prepareResponse: prepareSendRes,
    useAssetFees: null,
  );

  SendPaymentResponse sendRes = await breezSDKLiquid.instance!.sendPayment(
    req: sendPaymentRequest,
  );
  Payment payment = sendRes.payment;
  // ANCHOR_END: send-self-payment-asset
  print(payment);
  return sendRes;
}
