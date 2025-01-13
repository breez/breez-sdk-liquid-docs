import breez_sdk_liquid
import logging
from breez_sdk_liquid import BindingLiquidSdk, InputType, LnUrlWithdrawRequest


def withdraw(sdk: BindingLiquidSdk):
    # ANCHOR: lnurl-withdraw
    # Endpoint can also be of the form:
    # lnurlw://domain.com/lnurl-withdraw?key=val
    lnurl_withdraw_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk"

    try:
        parsed_input = sdk.parse(lnurl_withdraw_url)
        if isinstance(parsed_input, InputType.LN_URL_WITHDRAW):
            amount_msat = parsed_input.data.min_withdrawable
            result = sdk.lnurl_withdraw(LnUrlWithdrawRequest(
                parsed_input.data, amount_msat, "comment"
            ))
            return result
    except Exception as error:
        logging.error(error)
        raise
    # ANCHOR_END: lnurl-withdraw
