import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> parseInput() async {
  // ANCHOR: parse-inputs
  String input = "an input to be parsed...";

  InputType inputType = await breezSDKLiquid.instance!.parse(input: input);
  if (inputType is InputType_BitcoinAddress) {
    print("Input is Bitcoin address ${inputType.address.address}");
  } else if (inputType is InputType_Bolt11) {
    String amountStr =
        inputType.invoice.amountMsat != null ? inputType.invoice.amountMsat.toString() : "unknown";
    print("Input is BOLT11 invoice for $amountStr msats");
  } else if (inputType is InputType_Bolt12Offer) {
    print(
      "Input is BOLT12 offer for min ${inputType.offer.minAmount} msats - BIP353 was used: ${inputType.bip353Address != null}",
    );
  } else if (inputType is InputType_LnUrlPay) {
    print(
      "Input is LNURL-Pay/Lightning address accepting min/max ${inputType.data.minSendable}/${inputType.data.maxSendable} msats - BIP353 was used: ${inputType.bip353Address != null}",
    );
  } else if (inputType is InputType_LnUrlWithdraw) {
    print(
      "Input is LNURL-Withdraw for min/max ${inputType.data.minWithdrawable}/${inputType.data.maxWithdrawable} msats",
    );
  } else {
    // Other input types are available
  }
  // ANCHOR_END: parse-inputs
}
