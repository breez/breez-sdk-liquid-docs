using System.Reflection;
using Breez.Sdk.Liquid;

public class ConfigurationSnippets
{
    public void ConfigureAssetMetadata()
    {
        // ANCHOR: configure-asset-metadata
        // Create the default config
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Mainnet,
            "<your-Breez-API-key>"
        ) with
        {
            // Configure asset metadata. Setting the optional fiat ID will enable
            // paying fees using the asset (if available).
            assetMetadata = new List<AssetMetadata>
            {
                new(
                    assetId: "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
                    name: "PEGx EUR",
                    ticker: "EURx",
                    precision: 8,
                    fiatId: "EUR"
                )
            }
        };
        // ANCHOR_END: configure-asset-metadata
    }

    public void ConfigureParsers()
    {
        // ANCHOR: configure-external-parser
        // Create the default config
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
        // ANCHOR_END: configure-external-parser
    }

    public void ConfigureMagicRoutingHints()
    {
        // ANCHOR: configure-magic-routing-hints
        // Create the default config
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Mainnet,
            "<your-Breez-API-key>"
        ) with
        {
            // Configure magic routing hints
            useMagicRoutingHints = false
        };
        // ANCHOR_END: configure-magic-routing-hints
    }

}
