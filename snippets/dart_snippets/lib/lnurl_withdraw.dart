import 'package:flutter_breez_liquid/breez_liquid.dart';
import 'package:flutter_breez_liquid/bridge_generated.dart';

Future<void> lnurlWithdraw() async {
  // ANCHOR: lnurl-withdraw
  /// Endpoint can also be of the form:
  /// lnurlw://domain.com/lnurl-withdraw?key=val
  String lnurlWithdrawUrl =
      "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk";

  InputType inputType = await breezSDK.parseInput(input: lnurlWithdrawUrl);
  if (inputType is InputType_LnUrlWithdraw) {
    int amountMsat = inputType.data.minWithdrawable;
    LnUrlWithdrawRequest req = LnUrlWithdrawRequest(
      data: inputType.data,
      amountMsat: amountMsat,
      description: "<description>",
    );
    LnUrlWithdrawResult result = await breezSDK.lnurlWithdraw(req: req);
    print(result.data);
  }
  // ANCHOR_END: lnurl-withdraw
}
