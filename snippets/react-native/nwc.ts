import {
  BindingLiquidSdk,
  BindingNwcService,
  type NwcConfig,
  type AddConnectionRequest,
  type EditConnectionRequest,
  type NwcEvent,
  NwcEventDetails_Tags,
  NwcEventDetails
} from '@breeztech/breez-sdk-liquid-react-native'

const nwcConnect = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: connecting
  const nwcConfig: NwcConfig = {
    relayUrls: undefined,
    secretKeyHex: undefined,
    listenToEvents: undefined
  }
  const nwcService = sdk.useNwcPlugin(nwcConfig)

  // ...

  // Automatically stops the plugin
  sdk.disconnect()
  // Alternatively, you can stop the plugin manually, without disconnecting the SDK
  nwcService.stop()
  // ANCHOR_END: connecting
}

const nwcAddConnection = async (nwcService: BindingNwcService) => {
  // ANCHOR: add-connection
  // This connection will only allow spending at most 10,000 sats/hour
  const req: AddConnectionRequest = {
    name: 'my new connection',
    expiryTimeMins: 60,  // Expires after one hour
    periodicBudgetReq: {
      maxBudgetSat: BigInt(10000),
      renewalTimeMins: 60  // Renews every hour
    },
    receiveOnly: undefined // Defaults to false
  }
  const addResponse = nwcService.addConnection(req)
  console.log(addResponse.connection.connectionString)
  // ANCHOR_END: add-connection
}

const nwcEditConnection = async (nwcService: BindingNwcService) => {
  // ANCHOR: edit-connection
  const newExpiryTime = 60 * 24
  const req: EditConnectionRequest = {
    name: 'my new connection',
    expiryTimeMins: newExpiryTime,  // The connection will now expire after 1 day
    periodicBudgetReq: undefined,
    receiveOnly: undefined,
    removeExpiry: undefined,
    removePeriodicBudget: true  // The periodic budget has been removed
  }
  const editResponse = nwcService.editConnection(req)
  console.log(editResponse.connection.connectionString)
  // ANCHOR_END: edit-connection
}

const nwcListConnections = async (nwcService: BindingNwcService) => {
  // ANCHOR: list-connections
  const connections = nwcService.listConnections()
  for (const [connectionName, connection] of Object.entries(connections)) {
    console.log(
      `Connection: ${connectionName} - Expires at: ${connection.expiresAt}, Periodic Budget: ${JSON.stringify(connection.periodicBudget)}`
    )
    // ...
  }
  // ANCHOR_END: list-connections
}

const nwcRemoveConnection = async (nwcService: BindingNwcService) => {
  // ANCHOR: remove-connection
  nwcService.removeConnection('my new connection')
  // ANCHOR_END: remove-connection
}

const nwcGetInfo = async (nwcService: BindingNwcService) => {
  // ANCHOR: get-info
  const info = nwcService.getInfo()
  // ANCHOR_END: get-info
}

const nwcEvents = async (nwcService: BindingNwcService) => {
  // ANCHOR: events
  class MyListener {
    onEvent = (event: NwcEvent) => {
      if (event.details instanceof NwcEventDetails.Connected) {
        // ...
      } else if (event.details instanceof NwcEventDetails.Disconnected) {
        // ...
      } else if (event.details instanceof NwcEventDetails.ConnectionExpired) {
        // ...
      } else if (event.details instanceof NwcEventDetails.ConnectionRefreshed) {
        // ...
      } else if (event.details instanceof NwcEventDetails.PayInvoice) {
        // event.details.inner.success, event.details.inner.preimage, event.details.inner.feesSat, event.details.inner.error
        // ...
      } else if (event.details instanceof NwcEventDetails.ZapReceived) {
        // ...
      }
    }
  }

  const eventListener = new MyListener()
  const myListenerId = nwcService.addEventListener(eventListener)
  // If you wish to remove the event_listener later on, you can call:
  nwcService.removeEventListener(myListenerId)
  // Otherwise, it will be automatically removed on service stop
  // ANCHOR_END: events
}

const nwcListPayments = async (nwcService: BindingNwcService) => {
  // ANCHOR: payments
  const payments = nwcService.listConnectionPayments('my new connection')
  // ANCHOR_END: payments
}
