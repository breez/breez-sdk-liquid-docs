import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<PrepareReceiveResponse> prepareReceivePaymentAsset() async {
  // ANCHOR: prepare-receive-payment-asset
  // Create a Liquid BIP21 URI/address to receive an asset payment to.
  // Note: Not setting the amount will generate an amountless BIP21 URI.
  String usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  ReceiveAmount_Asset optionalAmount = ReceiveAmount_Asset(assetId: usdtAssetId, payerAmount: 1.50);
  PrepareReceiveResponse prepareResponse = await breezSDKLiquid.instance!.prepareReceivePayment(
    req: PrepareReceiveRequest(
      paymentMethod: PaymentMethod.liquidAddress,
      amount: optionalAmount,
    ),
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
  // you must specifiy an asset amount
  String usdtAssetId = "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2";
  PayAmount_Asset optionalAmount = PayAmount_Asset(assetId: usdtAssetId, receiverAmount: 1.50);
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
  // ANCHOR_END: prepare-send-payment-asset
  return prepareSendResponse;
}

Future<void> configureAssetMatedata() async {
  // ANCHOR: configure-asset-metadata
  // Create the default config
  Config config = defaultConfig(network: LiquidNetwork.mainnet, breezApiKey: "<your-Breez-API-key>");

  // Configure asset metadata
  config = config.copyWith(
    assetMetadata: [
      AssetMetadata(
        assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
        name: "PEGx EUR",
        ticker: "EURx",
        precision: 8,
      ),
    ],
  );
  // ANCHOR_END: configure-asset-metadata
}

Future<void> fetchAssetBalance() async {
  // ANCHOR: fetch-asset-balance
  GetInfoResponse? info = await breezSDKLiquid.instance!.getInfo();
  List<AssetBalance> assetBalances = info.walletInfo.assetBalances;
  // ANCHOR_END: fetch-asset-balance
  print(assetBalances);
}

