import breez_sdk_liquid
import logging
from breez_sdk_liquid import BindingLiquidSdk, InputType, LnUrlPayRequest


def pay(sdk: BindingLiquidSdk):
    # ANCHOR: lnurl-pay
    # Endpoint can also be of the form:
    # lnurlp://domain.com/lnurl-pay?key=val
    # lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    lnurl_pay_url = "lightning@address.com"
    try: 
        parsed_input = breez_sdk_liquid.parse(lnurl_pay_url)
        if isinstance(parsed_input, InputType.LN_URL_PAY):
            amount_msat = parsed_input.data.min_sendable
            optional_comment = "<comment>"
            optional_payment_label = "<label>"
            req = LnUrlPayRequest(parsed_input.data, amount_msat, optional_comment, optional_payment_label)
            result = sdk.lnurl_pay(req)
            return result
    except Exception as error:
        logging.error(error)
        raise 
  # ANCHOR_END: lnurl-pay
