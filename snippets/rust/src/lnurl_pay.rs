use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::{model::LnUrlPayRequest, prelude::*};
use log::info;

async fn prepare_pay(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: prepare-lnurl-pay
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    let lnurl_pay_url = "lightning@address.com";

    if let Ok(InputType::LnUrlPay { data: pd }) = parse(lnurl_pay_url).await {
        let amount_msat = pd.min_sendable;
        let optional_comment = Some("<comment>".to_string());
        let optional_validate_success_action_url = Some(true);

        let prepare_response = sdk.prepare_lnurl_pay(PrepareLnUrlPayRequest {
            data: pd,
            amount_msat,
            comment: optional_comment,
            validate_success_action_url: optional_validate_success_action_url,
        })
        .await?;

        // If the fees are acceptable, continue to create the LNURL Pay
        let fees_sat = prepare_response.fees_sat;
        info!("Fees: {} sats", fees_sat);    
    }
    // ANCHOR_END: prepare-lnurl-pay
    Ok(())
}

async fn pay(sdk: Arc<LiquidSdk>, prepare_response: PrepareLnUrlPayResponse) -> Result<()> {
    // ANCHOR: lnurl-pay
    let result = sdk
        .lnurl_pay(LnUrlPayRequest { prepare_response })
        .await?;
    // ANCHOR_END: lnurl-pay
    Ok(())
}
