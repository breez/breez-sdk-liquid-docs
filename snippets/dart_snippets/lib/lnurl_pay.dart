import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> prepareLnurlPay() async {
  // ANCHOR: prepare-lnurl-pay
  /// Endpoint can also be of the form:
  /// lnurlp://domain.com/lnurl-pay?key=val
  /// lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
  String lnurlPayUrl = "lightning@address.com";

  InputType inputType = await breezSDKLiquid.instance!.parse(input: lnurlPayUrl);
  if (inputType is InputType_LnUrlPay) {
    BigInt amountMsat = inputType.data.minSendable;
    String optionalComment = "<comment>";
    bool optionalValidateSuccessActionUrl = true;

    PrepareLnUrlPayRequest req = PrepareLnUrlPayRequest(
      data: inputType.data,
      amountMsat: amountMsat,
      comment: optionalComment,
      validateSuccessActionUrl: optionalValidateSuccessActionUrl,
    );
    PrepareLnUrlPayResponse prepareResponse = await breezSDKLiquid.instance!.prepareLnurlPay(req: req);

    // If the fees are acceptable, continue to create the LNURL Pay
    BigInt feesSat = prepareResponse.feesSat;
    print("Fees: $feesSat sats");
  }
  // ANCHOR_END: prepare-lnurl-pay
}

Future<void> lnurlPay({required PrepareLnUrlPayResponse prepareResponse}) async {
  // ANCHOR: lnurl-pay
  LnUrlPayResult result = await breezSDKLiquid.instance!.lnurlPay(
    req: LnUrlPayRequest(prepareResponse: prepareResponse),
  );
  // ANCHOR_END: lnurl-pay
  print(result);
}
