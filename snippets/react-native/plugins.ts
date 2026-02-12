import {
  NwcConfig,
  BindingNwcService,
  Plugin,
  PluginStorage,
  defaultConfig,
  connect,
  ConnectRequest,
  LiquidNetwork,
  BindingLiquidSdk
} from '@breeztech/breez-sdk-liquid-react-native';

function createNwcConfig(): NwcConfig {
  return {
    relayUrls: ["<your-relay-url-1>"],
    secretKeyHex: null,
  };
}

function createSdkConfig() {
  const config = defaultConfig(
    LiquidNetwork.TESTNET,
    null
  );
  config.workingDir = "path to an existing directory";
  return config;
}

function createConnectRequest(config: any): ConnectRequest {
  return {
    config,
    mnemonic: "<your-mnemonic-here>"
  };
}

async function connectWithNwcPlugin(): Promise<BindingLiquidSdk> {
  //ANCHOR: create-plugin-config
  // Create Plugin Config
  const nwcConfig = createNwcConfig();

  // Initialize Plugin
  const nwcService = new BindingNwcService(nwcConfig);
  
  // Create SDK Config
  const config = createSdkConfig();
  const plugins: Plugin[] = [nwcService];
  
  // Create Connect Request
  const connectRequest = createConnectRequest(config);
  
  // Connect to the SDK with the plugins
  const sdk = await connect(connectRequest, plugins);
  //ANCHOR_END: create-plugin-config
  return sdk;
}

//ANCHOR: my-custom-plugin
class MyPlugin implements Plugin {
  id(): string {
    // Return the unique identifier for your plugin
    return "my-custom-plugin";
  }

  async onStart(sdk: BindingLiquidSdk, storage: PluginStorage): Promise<void> {
    // Initialize your plugin here
  }

  async onStop(): Promise<void> {
    // Cleanup your plugin here
  }
}
//ANCHOR_END: my-custom-plugin