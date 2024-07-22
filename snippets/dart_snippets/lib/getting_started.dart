import 'package:dart_snippets/sdk_instance.dart';
import 'package:flutter_breez_liquid/flutter_breez_liquid.dart';

Future<void> initializeSDK() async {
  // ANCHOR: init-sdk
  // It is recommended to use a single instance of BreezSDKLiquid across your Dart/Flutter app.
  //
  // All of the snippets assume a BreezSDKLiquid object is created on entrypoint of the app as such:
  //
  // ConnectRequest req = ConnectRequest(...);
  // BindingLiquidSdk instance = await connect(req: req);
  //
  // and is accessible throughout the app. There are various approaches on how to achieve this:
  // creating a Singleton class using factory constructor, using state management libraries such as 'provider', 'GetX',
  // 'Riverpod' and 'Redux' to name a few.
  //
  // The Dart snippets included here rely on the example approach seen on sdk_instance.dart to manage wallet connection
  // and Liquid SDK streams. This approach also has essential helper methods to ensure wallet data is in sync.
  // Please see sdk_instance.dart for more details:
  // [sdk_instance.dart](https://github.com/breez/breez-sdk-liquid-docs/blob/main/snippets/dart_snippets/lib/sdk_instance.dart)

  // Create the default config
  String mnemonic = "<mnemonic words>";

  // Create the default config
  Config config = defaultConfig(
    network: LiquidNetwork.mainnet,
  );

  // Customize the config object according to your needs
  config = config.copyWith(workingDir: "path to an existing directory");

  ConnectRequest connectRequest = ConnectRequest(mnemonic: mnemonic, config: config);

  await breezSDKLiquid.connect(req: connectRequest);

  // ANCHOR_END: init-sdk
}

Future<void> fetchBalance(String lspId) async {
  // ANCHOR: fetch-balance
  GetInfoResponse? walletInfo = await breezSDKLiquid.instance!.getInfo();
  BigInt balanceSat = walletInfo.balanceSat;
  BigInt pendingSendSat = walletInfo.pendingSendSat;
  BigInt pendingReceiveSat = walletInfo.pendingReceiveSat;
  // ANCHOR_END: fetch-balance
  print(balanceSat);
  print(pendingSendSat);
  print(pendingReceiveSat);
}

class BreezSDKLiquid {
  // ANCHOR: logging
  StreamSubscription<liquid_sdk.LogEntry>? _breezLogSubscription;
  Stream<liquid_sdk.LogEntry>? _breezLogStream;

  // Initializes SDK log stream.
  //
  // Call once on your Dart entrypoint file, e.g.; `lib/main.dart`.
  void initializeLogStream() {
    _breezLogStream ??= liquid_sdk.breezLogStream().asBroadcastStream();
  }

  final _logStreamController = StreamController<liquid_sdk.LogEntry>.broadcast();
  Stream<liquid_sdk.LogEntry> get logStream => _logStreamController.stream;

  // Subscribe to the log stream
  void _subscribeToLogStream() {
    _breezLogSubscription = _breezLogStream?.listen((logEntry) {
      _logStreamController.add(logEntry);
    }, onError: (e) {
      _logStreamController.addError(e);
    });
  }

  // Unsubscribe from the log stream
  void _unsubscribeFromLogStream() {
    _breezLogSubscription?.cancel();
  }
  // ANCHOR_END: logging

  // ANCHOR: add-event-listener
  StreamSubscription<liquid_sdk.SdkEvent>? _breezEventSubscription;
  Stream<liquid_sdk.SdkEvent>? _breezEventStream;

  // Initializes SDK event stream.
  //
  // Call once on your Dart entrypoint file, e.g.; `lib/main.dart`.
  void _initializeEventsStream(liquid_sdk.BindingLiquidSdk sdk) {
    _breezEventStream ??= sdk.addEventListener().asBroadcastStream();
  }
    
  final _eventStreamController = StreamController<liquid_sdk.SdkEvent>.broadcast();
  Stream<liquid_sdk.SdkEvent> get eventStream => _eventStreamController.stream;

  // Subscribe to the event stream
  void _subscribeToEventStream() {
    _breezEventSubscription = _breezEventStream?.listen((sdkEvent) {
      _eventStreamController.add(sdkEvent);
    }, onError: (e) {
      _eventStreamController.addError(e);
    });
  }
  // ANCHOR_END: add-event-listener

  // ANCHOR: remove-event-listener
  void _unsubscribeFromEventStream() {
    _breezEventSubscription?.cancel();
  }
  // ANCHOR_END: remove-event-listener
}
