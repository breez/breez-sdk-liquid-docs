using Breez.Sdk.Liquid;

public class PluginSnippets
{
    public static NwcConfig CreateNwcConfig()
    {
        return new NwcConfig
        {
            RelayUrls = new[] { "<your-relay-url-1>" },
            SecretKeyHex = null,
        };
    }

    public static Config CreateSdkConfig()
    {
        var config = BreezSdkLiquidMethods.DefaultConfig(
            LiquidNetwork.Testnet,
            null
        );
        config.WorkingDir = "path to an existing directory";
        return config;
    }

    public static ConnectRequest CreateConnectRequest(Config config)
    {
        return new ConnectRequest(config, "<your-mnemonic-here>");
    }

    public static BindingLiquidSdk ConnectWithNwcPlugin()
    {
        //ANCHOR: create-plugin-config
        // Create Plugin Config
        var nwcConfig = CreateNwcConfig();

        // Initialize Plugin
        var nwcService = new BindingNwcService(nwcConfig);
        
        // Create SDK Config
        var config = CreateSdkConfig();
        var plugins = new Plugin[] { nwcService };
        
        // Create Connect Request
        var connectRequest = CreateConnectRequest(config);
        
        // Connect to the SDK with the plugins
        var sdk = BreezSdkLiquidMethods.Connect(connectRequest, plugins);
        //ANCHOR_END: create-plugin-config
        return sdk;
    }
}

//ANCHOR: my-custom-plugin
public class MyPlugin : Plugin
{
    public string Id()
    {
        // Return the unique identifier for your plugin
        return "my-custom-plugin";
    }

    public void OnStart(BindingLiquidSdk sdk, PluginStorage storage)
    {
        // Initialize your plugin here
    }

    public void OnStop()
    {
        // Cleanup your plugin here
    }
}
//ANCHOR_END: my-custom-plugin