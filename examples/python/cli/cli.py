from typing import Optional
from colorama import init as colorama_init, Style
from mnemonic import Mnemonic
from os.path import exists
from qrcode.main import QRCode
from qrcode.constants import ERROR_CORRECT_L
from breez_sdk_liquid import LiquidNetwork, PayAmount, ReceiveAmount
import argparse
import breez_sdk_liquid
import sys
import time
import os
import json

colorama_init()

class Sdk:
    """
    A wrapper class for the Breez SDK.

    This class initializes the Breez SDK, manages the mnemonic phrase,
    and provides methods to interact with the SDK.

    Attributes:
        instance: The Breez SDK instance.
        listener: An instance of SdkListener to handle SDK events.
    """

    def __init__(self, network: Optional[LiquidNetwork] = None, debug: Optional[bool] = False):
        if debug:
            breez_sdk_liquid.set_logger(SdkLogListener())

        api_key = os.getenv('BREEZ_API_KEY')
        mnemonic = self.read_mnemonic()
        config = breez_sdk_liquid.default_config(network or LiquidNetwork.TESTNET, api_key)
        connect_request = breez_sdk_liquid.ConnectRequest(config=config, mnemonic=mnemonic)
        self.instance = breez_sdk_liquid.connect(connect_request)
        self.listener = SdkListener()
        self.instance.add_event_listener(self.listener)

    def is_paid(self, destination: str):
        return self.listener.is_paid(destination)

    def is_synced(self):
        return self.listener.is_synced()
    
    def generate_mnemonic(self):
        mnemo = Mnemonic("english")
        words = mnemo.generate(strength=128)
        return words

    def read_mnemonic(self):
        if exists('phrase'):
            with open('phrase') as f:
                mnemonic = f.readline()
                if not mnemonic:
                    mnemonic = self.generate_mnemonic()
                    with open('phrase', 'w') as f:
                        f.write(mnemonic)
                f.close()
                return mnemonic
        else:
            with open('phrase', 'w') as f:
                mnemonic = self.generate_mnemonic()
                f.write(mnemonic)
                f.close()
                return mnemonic


class SdkLogListener(breez_sdk_liquid.Logger):
    def log(self, log_entry):
        if log_entry.level != "TRACE":
            print_dim("{}: {}".format(log_entry.level, log_entry.line))


class SdkListener(breez_sdk_liquid.EventListener):
    """
    A listener class for handling Breez SDK events.

    This class extends the EventListener from breez_sdk_liquid and implements
    custom event handling logic, particularly for tracking successful payments.

    Attributes:
        paid (list): A list to store destinations of successful payments.
    """

    def __init__(self):
        """
        Initialize the SdkListener.

        Sets up an empty list to track paid destinations.
        """
        self.synced = False
        self.paid = []

    def on_event(self, event):
        if isinstance(event, breez_sdk_liquid.SdkEvent.SYNCED):
            self.synced = True
        else:
            print_dim(event)
        if isinstance(event, breez_sdk_liquid.SdkEvent.PAYMENT_SUCCEEDED):
            if event.details.destination:
                self.paid.append(event.details.destination)
    
    def is_paid(self, destination: str):
        return destination in self.paid
    
    def is_synced(self):
        return self.synced

def parse_network(network_str: str) -> LiquidNetwork:
    if network_str == 'TESTNET':
        return LiquidNetwork.TESTNET
    elif network_str == 'MAINNET':
        return LiquidNetwork.MAINNET

    raise Exception("Invalid network specified")

def parse_pay_amount(params) -> Optional[PayAmount]:
    amount_sat = getattr(params, 'amount_sat', None)
    amount = getattr(params, 'amount', None)
    asset_id = getattr(params, 'asset_id', None)
    drain = getattr(params, 'drain', None)
    asset_params = (asset_id, amount)
    if drain is True:
        return PayAmount.DRAIN
    elif amount_sat is not None:
        return PayAmount.BITCOIN(amount_sat)
    elif any(asset_params):
        if not all(asset_params):
            raise ValueError('Sending an asset requires both `asset_id` and `amount`')
        return PayAmount.ASSET(asset_id, amount)
    return None

def parse_receive_amount(params) -> Optional[ReceiveAmount]:
    amount_sat = getattr(params, 'amount_sat', None)
    amount = getattr(params, 'amount', None)
    asset_id = getattr(params, 'asset_id', None)
    if amount_sat is not None:
        return ReceiveAmount.BITCOIN(amount_sat)
    elif asset_id is not None:
        return ReceiveAmount.ASSET(asset_id, amount)
    return None

def list_payments(params):
    """
    List payments using the Breez SDK.

    This function initializes the Breez SDK and retrieves a list of payments
    based on the provided parameters. It then prints the results.

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - from_timestamp (int, optional): The start timestamp for filtering payments.
            - to_timestamp (int, optional): The end timestamp for filtering payments.
            - offset (int, optional): The number of payments to skip before starting to return results.
            - limit (int, optional): The maximum number of payments to return.

    Raises:
        Exception: If any error occurs during the process of listing payments.
    """
    sdk = Sdk(params.network, params.debug)
    try:
        req = breez_sdk_liquid.ListPaymentsRequest(from_timestamp=params.from_timestamp, 
                                                   to_timestamp=params.to_timestamp, 
                                                   offset=params.offset, 
                                                   limit=params.limit)
        res = sdk.instance.list_payments(req)
        print(*res, sep='\n\n')
    except Exception as error:
        print(error)

def receive_payment(params):
    """
    Handles the process of receiving a payment using the Breez SDK.

    This function performs the following steps:
    1. Initializes the SDK
    2. Prepares a receive request to get fee information
    3. Prompts the user to accept the fees
    4. If accepted, initiates the receive payment process
    5. Displays a QR code for the payment destination
    6. Waits for the payment to be received

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - method (str): The payment method (e.g., 'LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS')
            - amount_sat (int): The amount to receive in satoshis
            - asset_id (str): The optional id of the asset to receive
            - amount (float): The optional amount to receive of the asset

    Raises:
        Exception: If any error occurs during the payment receiving process
    """
    sdk = Sdk(params.network, params.debug)
    try:
        # Prepare the receive request to get fees
        receive_amount = parse_receive_amount(params)
        prepare_req = breez_sdk_liquid.PrepareReceiveRequest(getattr(breez_sdk_liquid.PaymentMethod, params.method), receive_amount)
        prepare_res = sdk.instance.prepare_receive_payment(prepare_req)
        # Prompt to accept fees
        accepted = input(f"Fees: {prepare_res.fees_sat} sat. Are the fees acceptable? (y/N)? : ")
        if accepted in ["Y", "y"]:
            # Receive payment
            req = breez_sdk_liquid.ReceivePaymentRequest(prepare_res)
            res = sdk.instance.receive_payment(req)
            if res.destination:
                print_qr(res.destination)
                print('Waiting for payment:', res.destination)
                wait_for_payment(sdk, res.destination)
    except Exception as error:
        print(error)

def send_payment(params):
    """
    Handles the process of sending a payment using the Breez SDK.

    This function performs the following steps:
    1. Initializes the SDK
    2. Prepares a send request to get fee information
    3. Prompts the user to accept the fees
    4. If accepted, initiates the send payment process
    5. Waits for the payment to be completed

    Args:
        params (argparse.Namespace): Command-line arguments containing:
            - destination (str): The bolt11 or Liquid BIP21 URI/address
            - amount_sats (int): The amount to send in satoshis
            - asset_id (str): The optional id of the asset to send
            - amount (float): The optional amount to send of the asset
            - drain: Drain all funds when sending

    Raises:
        Exception: If any error occurs during the payment sending process
    """
    sdk = Sdk(params.network, params.debug)
    try:
        # Prepare the send request to get fees
        pay_amount = parse_pay_amount(params)
        prepare_req = breez_sdk_liquid.PrepareSendRequest(params.destination, pay_amount)
        prepare_res = sdk.instance.prepare_send_payment(prepare_req)
        # Prompt to accept fees
        accepted = input(f"Fees: {prepare_res.fees_sat} sat. Are the fees acceptable? (Y/n)? : ")
        if accepted == "Y":
            # Send payment
            req = breez_sdk_liquid.SendPaymentRequest(prepare_res)
            res = sdk.instance.send_payment(req)
            if res.payment.destination:
                print('Sending payment:', res.payment.destination)
                wait_for_payment(sdk, res.payment.destination)
    except Exception as error:
        print(error)

def print_dim(data):
    print(Style.DIM)
    print(data)
    print(Style.RESET_ALL)

def print_qr(text: str):
    qr = QRCode(
        version=1,
        error_correction=ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(text)
    qr.make(fit=True)
    qr.print_ascii()

def wait_for_payment(sdk: Sdk, destination: str):
    while True:
        if sdk.is_paid(destination):
            break
        time.sleep(1)

def wait_for_synced(sdk: Sdk):
    while True:
        if sdk.is_synced():
            break
        time.sleep(1)

def get_info(params):
    sdk = Sdk(params.network, params.debug)
    wait_for_synced(sdk)
    res = sdk.instance.get_info()
    print(json.dumps(res, default=lambda x: x.__dict__, indent=2))

def main():
    if len(sys.argv) <= 1:
        sys.argv.append('--help')

    parser = argparse.ArgumentParser('Pythod SDK Example', description='Simple CLI to receive/send payments')
    parser.add_argument('-d', '--debug',
                        default=False,
                        action='store_true',
                        help='Output SDK logs')
    parser.add_argument('-n', '--network',
                        help='The network the SDK runs on, either "MAINNET" or "TESTNET"',
                        type=parse_network)
    subparser = parser.add_subparsers(title='subcommands')
    # info
    info_parser = subparser.add_parser('info', help='Get wallet info')
    info_parser.set_defaults(run=get_info)
    # list
    list_parser = subparser.add_parser('list', help='List payments')
    list_parser.add_argument('-f', '--from_timestamp', 
                                type=int, 
                                help='The optional from unix timestamp')
    list_parser.add_argument('-t', '--to_timestamp', 
                                type=int, 
                                help='The optional to unix timestamp')
    list_parser.add_argument('-o', '--offset', 
                                type=int, 
                                help='The optional offset of payments')
    list_parser.add_argument('-l', '--limit', 
                                type=int, 
                                help='The optional limit of listed payments')
    list_parser.set_defaults(run=list_payments)
    # receive
    receive_parser = subparser.add_parser('receive', help='Receive a payment')
    receive_parser.add_argument('-m', '--method', 
                                choices=['LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS'], 
                                help='The payment method', 
                                required=True)
    receive_parser.add_argument('-a', '--amount_sat', 
                                type=int, 
                                help='The optional amount to receive in sats')
    receive_parser.add_argument('--asset_id', help='The optional id of the asset to receive')
    receive_parser.add_argument('--amount', type=float, help='The optional amount to receive of the asset')
    receive_parser.set_defaults(run=receive_payment)
    # send
    send_parser = subparser.add_parser('send', help='Send a payment')
    send_parser.add_argument('-d', '--destination', help='The bolt11 or Liquid BIP21 URI/address', required=True)
    send_parser.add_argument('-a', '--amount_sat', type=int, help='The optional amount to send in sats')
    send_parser.add_argument('--asset_id', help='The optional id of the asset to send')
    send_parser.add_argument('--amount', type=float, help='The optional amount to send of the asset')
    send_parser.add_argument('--drain', default=False, action='store_true', help='Drain all funds when sending')
    send_parser.set_defaults(run=send_payment)

    args = parser.parse_args()
    args.run(args)
