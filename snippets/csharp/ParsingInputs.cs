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

                case InputType.Bolt12Offer bolt12:
                    Console.WriteLine($"Input is BOLT12 offer for min {bolt12.offer.minAmount} msats - BIP353 was used: {bolt12.bip353Address != null}");
                    break;

                case InputType.LnUrlPay lnUrlPay:
                    Console.WriteLine(
                        $"Input is LNURL-Pay/Lightning address accepting min/max {lnUrlPay.data.minSendable}/{lnUrlPay.data.maxSendable} msats - BIP353 was used: {lnUrlPay.bip353Address != null}"
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

    public void ConfigureParsers()
    {
        // ANCHOR: configure-external-parser
        var mnemonic = "<mnemonic words>";

        // Create the default config, providing your Breez API key
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Mainnet,
            "<your-Breez-API-key>"
        ) with
        {
            // Configure external parsers
            externalInputParsers = new List<ExternalInputParser>
            {
                new(
                    providerId: "provider_a",
                    inputRegex: "^provider_a",
                    parserUrl: "https://parser-domain.com/parser?input=<input>"
                ),
                new(
                    providerId: "provider_b",
                    inputRegex: "^provider_b",
                    parserUrl: "https://parser-domain.com/parser?input=<input>"
                )
            }
        };

        try
        {
            var connectRequest = new ConnectRequest(config, mnemonic);
            var sdk = BreezSdkLiquidMethods.Connect(connectRequest);
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: configure-external-parser
    }
}
