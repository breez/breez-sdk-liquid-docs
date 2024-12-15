using Breez.Sdk.Liquid;

public class ParsingInputsSnippets
{
    public void ParseInput(BindingLiquidSdk sdk)
    {
        // ANCHOR: parse-inputs
        var input = "an input to be parsed...";

        try
        {
            var parsed = sdk.Parse(input);

            switch (parsed)
            {
                case InputType.BitcoinAddress bitcoinAddress:
                    Console.WriteLine($"Input is Bitcoin address {bitcoinAddress.address}");
                    break;

                case InputType.Bolt11 bolt11:
                    var amount = bolt11.invoice.amountMsat.HasValue
                        ? bolt11.invoice.amountMsat.Value.ToString()
                        : "unknown";
                    Console.WriteLine($"Input is BOLT11 invoice for {amount} msats");
                    break;

                case InputType.LnUrlPay lnUrlPay:
                    Console.WriteLine(
                        $"Input is LNURL-Pay/Lightning address accepting min/max {lnUrlPay.data.minSendable}/{lnUrlPay.data.maxSendable} msats"
                    );
                    break;

                case InputType.LnUrlWithdraw lnUrlWithdraw:
                    Console.WriteLine(
                        $"Input is LNURL-Withdraw for min/max {lnUrlWithdraw.data.minWithdrawable}/{lnUrlWithdraw.data.maxWithdrawable} msats"
                    );
                    break;
                default:
                    // Other input types are available
                    break;
            }
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: parse-inputs
    }
}
