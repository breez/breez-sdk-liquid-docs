from colorama import init as colorama_init, Style
from mnemonic import Mnemonic
from os.path import exists
import argparse
import breez_sdk_liquid
import qrcode
import sys
import time

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

    def __init__(self):
        mnemonic = self.read_mnemonic()
        config = breez_sdk_liquid.default_config(breez_sdk_liquid.LiquidNetwork.MAINNET)
        connect_request = breez_sdk_liquid.ConnectRequest(config=config, mnemonic=mnemonic)
        self.instance = breez_sdk_liquid.connect(connect_request)
        self.listener = SdkListener()
        self.instance.add_event_listener(self.listener)

    def is_paid(self, destination: str):
        return self.listener.is_paid(destination)
    
    def read_mnemonic(self):
        if exists('phrase'):
            with open('phrase') as f:
                mnemonic = f.readline()
                f.close()
                return mnemonic
        else:
            with open('phrase', 'w') as f:
                mnemo = Mnemonic("english")
                words = mnemo.generate(strength=128)
                f.write(words)
                f.close()
                return words


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
        self.paid = []

    def on_event(self, event):
        if isinstance(event, breez_sdk_liquid.SdkEvent.SYNCED) == False:
            print_dim(event)
        if isinstance(event, breez_sdk_liquid.SdkEvent.PAYMENT_SUCCEEDED):
            if event.details.destination:
                self.paid.append(event.details.destination)

    def is_paid(self, destination: str):
        return destination in self.paid


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
            - amount (int): The amount to receive in satoshis
            - method (str): The payment method (e.g., 'LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS')

    Raises:
        Exception: If any error occurs during the payment receiving process
    """
    sdk = Sdk()
    try:
        # Prepare the receive request to get fees
        prepare_req = breez_sdk_liquid.PrepareReceiveRequest(params.amount, getattr(breez_sdk_liquid.PaymentMethod, params.method))
        prepare_res = sdk.instance.prepare_receive_payment(prepare_req)
        # Prompt to accept fees
        accepted = input(f"Fees: {prepare_res.fees_sat} sat. Are the fees acceptable? (Y/n)? : ")
        if accepted == "Y":
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
            - amount (int): The amount to send in satoshis

    Raises:
        Exception: If any error occurs during the payment sending process
    """
    sdk = Sdk()
    try:
        # Prepare the send request to get fees
        prepare_req = breez_sdk_liquid.PrepareSendRequest(params.destination, params.amount)
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
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
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

def main():
    if len(sys.argv) <= 1:
        sys.argv.append('--help')

    parser = argparse.ArgumentParser('Pythod SDK Example', description='Simple CLI to receive/send payments')
    subparser = parser.add_subparsers(title='subcommands')
    # receive
    receive_parser = subparser.add_parser('receive', help='Receive a payment')
    receive_parser.add_argument('-m', '--method', 
                                choices=['LIGHTNING', 'BITCOIN_ADDRESS', 'LIQUID_ADDRESS'], 
                                help='The payment method', 
                                required=True)
    receive_parser.add_argument('-a', '--amount', 
                                type=int, 
                                help='The optional amount to receive in sats')
    receive_parser.set_defaults(run=receive_payment)
    # send
    send_parser = subparser.add_parser('send', help='Send a payment')
    send_parser.add_argument('-d', '--destination', help='The bolt11 or Liquid BIP21 URI/address', required=True)
    send_parser.add_argument('-a', '--amount', type=int, help='The optional amount to send in sats')
    send_parser.set_defaults(run=send_payment)

    args = parser.parse_args()
    args.run(args)
