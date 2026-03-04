import { type BindingLiquidSdk } from '@breeztech/breez-sdk-liquid'
import {
  type NwcConfig,
  type AddConnectionRequest,
  type EditConnectionRequest,
  type NwcEvent
} from '@breeztech/breez-sdk-liquid-nwc'

const nwcConnect = async (sdk: BindingLiquidSdk) => {
  // ANCHOR: connecting
  const nwcConfig: NwcConfig = {
    relayUrls: null,
    secretKeyHex: null,
    listenToEvents: null
  }
  const nwcService = await sdk.useNwcPlugin(nwcConfig)

  // ...

  // Automatically stops the plugin
  await sdk.disconnect()
  // Alternatively, you can stop the plugin manually, without disconnecting the SDK
  await nwcService.stop()
  // ANCHOR_END: connecting
}

const nwcAddConnection = async (nwcService: SdkNwcService) => {
  // ANCHOR: add-connection
  // This connection will only allow spending at most 10,000 sats/hour
  const req: AddConnectionRequest = {
    name: 'my new connection',
    expiryTimeMins: 60,  // Expires after one hour
    periodicBudgetReq: {
      maxBudgetSat: 10000,
      renewalTimeMins: 60  // Renews every hour
    },
    receiveOnly: null  // Defaults to false
  }
  const addResponse = await nwcService.addConnection(req)
  console.log(addResponse.connection.connectionString)
  // ANCHOR_END: add-connection
}

const nwcEditConnection = async (nwcService: SdkNwcService) => {
  // ANCHOR: edit-connection
  const newExpiryTime = 60 * 24
  const req: EditConnectionRequest = {
    name: 'my new connection',
    expiryTimeMins: newExpiryTime,  // The connection will now expire after 1 day
    periodicBudgetReq: null,
    receiveOnly: null,
    removeExpiry: null,
    removePeriodicBudget: true  // The periodic budget has been removed
  }
  const editResponse = await nwcService.editConnection(req)
  console.log(editResponse.connection.connectionString)
  // ANCHOR_END: edit-connection
}

const nwcListConnections = async (nwcService: SdkNwcService) => {
  // ANCHOR: list-connections
  const connections = await nwcService.listConnections()
  for (const [connectionName, connection] of Object.entries(connections)) {
    console.log(
      `Connection: ${connectionName} - Expires at: ${connection.expiresAt}, Periodic Budget: ${JSON.stringify(connection.periodicBudget)}`
    )
    // ...
  }
  // ANCHOR_END: list-connections
}

const nwcRemoveConnection = async (nwcService: SdkNwcService) => {
  // ANCHOR: remove-connection
  await nwcService.removeConnection('my new connection')
  // ANCHOR_END: remove-connection
}

const nwcGetInfo = async (nwcService: SdkNwcService) => {
  // ANCHOR: get-info
  const info = await nwcService.getInfo()
  // ANCHOR_END: get-info
}

const nwcEvents = async (nwcService: SdkNwcService) => {
  // ANCHOR: events
  class MyListener {
    onEvent = (event: NwcEvent) => {
      switch (event.details.type) {
        case 'connected':
          // ...
          break
        case 'disconnected':
          // ...
          break
        case 'payInvoice':
          // event.details.success, event.details.preimage, event.details.feesSat, event.details.error
          break
        case 'zapReceived':
          // event.details.invoice
          break
        default:
          break
      }
    }
  }

  const eventListener = new MyListener()
  const myListenerId = await nwcService.addEventListener(eventListener)
  // If you wish to remove the event_listener later on, you can call:
  await nwcService.removeEventListener(myListenerId)
  // Otherwise, it will be automatically removed on service stop
  // ANCHOR_END: events
}

const nwcListPayments = async (nwcService: SdkNwcService) => {
  // ANCHOR: payments
  const payments = await nwcService.listConnectionPayments('my new connection')
  // ANCHOR_END: payments
}
