import breez_sdk_liquid
import logging
from breez_sdk_liquid import BindingLiquidSdk, InputType, LnUrlPayRequest, LnUrlPayRequestData, PayAmount, PrepareLnUrlPayRequest, PrepareLnUrlPayResponse


def prepare_pay(sdk: BindingLiquidSdk):
    # ANCHOR: prepare-lnurl-pay
    # Endpoint can also be of the form:
    # lnurlp://domain.com/lnurl-pay?key=val
    # lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    lnurl_pay_url = "lightning@address.com"
    try: 
        parsed_input = sdk.parse(lnurl_pay_url)
        if isinstance(parsed_input, InputType.LN_URL_PAY):
            amount = PayAmount.BITCOIN(5_000)
            optional_comment = "<comment>"
            optional_validate_success_action_url = True

            req = PrepareLnUrlPayRequest(parsed_input.data,
                                         amount, 
                                         optional_comment, 
                                         optional_validate_success_action_url)
            prepare_response = sdk.prepare_lnurl_pay(req)

            # If the fees are acceptable, continue to create the LNURL Pay
            fees_sat = prepare_response.fees_sat
            logging.debug("Fees: ", fees_sat, " sats")
            return prepare_response
    except Exception as error:
        logging.error(error)
        raise 
  # ANCHOR_END: prepare-lnurl-pay

def prepare_pay_drain(sdk: BindingLiquidSdk, data: LnUrlPayRequestData):
    # ANCHOR: prepare-lnurl-pay-drain
    try: 
        amount = PayAmount.DRAIN
        optional_comment = "<comment>"
        optional_validate_success_action_url = True

        req = PrepareLnUrlPayRequest(data,
                                     amount, 
                                     optional_comment, 
                                     optional_validate_success_action_url)
        prepare_response = sdk.prepare_lnurl_pay(req)
        return prepare_response
    except Exception as error:
        logging.error(error)
        raise 
  # ANCHOR_END: prepare-lnurl-pay-drain

def pay(sdk: BindingLiquidSdk, prepare_response: PrepareLnUrlPayResponse):
    # ANCHOR: lnurl-pay
    try:
        result = sdk.lnurl_pay(LnUrlPayRequest(prepare_response))
    except Exception as error:
        logging.error(error)
        raise
  # ANCHOR_END: lnurl-pay
