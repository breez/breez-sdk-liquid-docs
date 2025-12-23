from breez_sdk_liquid import AssetMetadata, default_config, LiquidNetwork, ExternalInputParser


def configure_asset_metadata():
    # ANCHOR: configure-asset-metadata
    # Create the default config
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure asset metadata. Setting the optional fiat ID will enable
    # paying fees using the asset (if available).
    config.asset_metadata = [
        AssetMetadata(
            asset_id="18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            name="PEGx EUR",
            ticker="EURx",
            precision=8,
            fiat_id="EUR"
        )
    ]
    # ANCHOR_END: configure-asset-metadata

def configure_parsers():
    # ANCHOR: configure-external-parser
    # Create the default config
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure external parsers
    config.external_input_parsers = [
        ExternalInputParser(
            provider_id="provider_a",
            input_regex="^provider_a",
            parser_url="https://parser-domain.com/parser?input=<input>"
        ),
        ExternalInputParser(
            provider_id="provider_b",
            input_regex="^provider_b",
            parser_url="https://parser-domain.com/parser?input=<input>"
        )
    ]
    # ANCHOR_END: configure-external-parser

def configure_magic_routing_hints():
    # ANCHOR: configure-magic-routing-hints
    # Create the default config
    config = default_config(
        network=LiquidNetwork.MAINNET,
        breez_api_key="<your-Breez-API-key>"
    )

    # Configure magic routing hints
    config.use_magic_routing_hints = False
    # ANCHOR_END: configure-magic-routing-hints
