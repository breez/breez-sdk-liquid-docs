#!/usr/bin/env python
from src.getting_started import start, set_logger, fetch_balance, add_event_listener, remove_event_listener, SdkLogger, SdkListener
from src.buy_btc import fetch_onchain_limits, prepare_buy_btc, buy_btc
from src.fiat_currencies import list_fiat_currencies, fetch_fiat_rates
from src.list_payments import list_payments, list_payments_filtered
from src.lnurl_auth import auth
from src.lnurl_pay import pay
from src.lnurl_withdraw import withdraw
from src.pay_onchain import fetch_pay_onchain_limits, prepare_pay_onchain, prepare_pay_onchain_fee_rate, start_pay_onchain
from src.receive_onchain import list_refundables, execute_refund, rescan_swaps
from src.receive_payment import prepare_receive_lightning, prepare_receive_onchain, prepare_receive_liquid, receive_payment
from src.send_payment import send_payment
from src.webhook import register_webhook, unregister_webhook


def main():  
   # getting started
   set_logger(SdkLogger)
   sdk = start()
   fetch_balance(sdk) 
   listener_id = add_event_listener(sdk, SdkListener)  
   remove_event_listener(listener_id)
   
   # buy btc
   current_limits = fetch_onchain_limits(sdk)
   prepare_response = prepare_buy_btc(sdk, current_limits)
   buy_btc(sdk, prepare_response)

   # fiat currencies
   list_fiat_currencies(sdk)
   fetch_fiat_rates(sdk)

   # list payments
   list_payments(sdk)
   list_payments_filtered(sdk)

   # lnurl
   auth(sdk)
   pay(sdk)
   withdraw(sdk)

   # pay onchain
   current_limits = fetch_pay_onchain_limits(sdk)
   prepare_response = prepare_pay_onchain(sdk)
   prepare_pay_onchain_fee_rate(sdk)
   start_pay_onchain(sdk, prepare_response)

   # receive onchain 
   refundables = list_refundables(sdk)
   execute_refund(sdk, 1, refundables[0])
   rescan_swaps(sdk)

   # receive payment
   prepare_response = prepare_receive_lightning(sdk)
   prepare_receive_onchain(sdk)
   prepare_receive_liquid(sdk)
   receive_payment(sdk, prepare_response)

   # send payment
   send_payment(sdk)

   # webhook
   register_webhook(sdk)
   unregister_webhook(sdk)


main()

  
