import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> lnurlAuth() async {
  // ANCHOR: lnurl-auth
  /// Endpoint can also be of the form:
  /// keyauth://domain.com/auth?key=val
  String lnurlAuthUrl =
      "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";

  InputType inputType = await parse(input: lnurlAuthUrl);
  if (inputType is InputType_LnUrlAuth) {
    LnUrlCallbackStatus result = await breezSDKLiquid.instance!.lnurlAuth(reqData: inputType.data);
    if (result is LnUrlCallbackStatus_Ok) {
      print("Successfully authenticated");
    } else {
      print("Failed to authenticate");
    }
  }
  // ANCHOR_END: lnurl-auth
}
