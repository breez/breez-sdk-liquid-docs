from breez_sdk_liquid import BindingLiquidSdk

def list_fiat_currencies(sdk: BindingLiquidSdk):
   # ANCHOR: list-fiat-currencies
   try:
      supported_fiat_currencies = sdk.list_fiat_currencies()
   except Exception as error:
      print(error)
      raise
   # ANCHOR_END: list-fiat-currencies

def fetch_fiat_rates(sdk: BindingLiquidSdk):
   # ANCHOR: fetch-fiat-rates
   try:
      fiat_rates = sdk.fetch_fiat_rates()
   except Exception as error:
      print(error)
      raise
   # ANCHOR_END: fetch-fiat-rates
