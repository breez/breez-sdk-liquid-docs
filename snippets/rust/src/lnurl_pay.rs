use std::sync::Arc;

use anyhow::Result;
use breez_sdk_liquid::prelude::*;

async fn pay(sdk: Arc<LiquidSdk>) -> Result<()> {
    // ANCHOR: lnurl-pay
    // Endpoint can also be of the form:
    // lnurlp://domain.com/lnurl-pay?key=val
    // lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf
    let lnurl_pay_url = "lightning@address.com";

    if let Ok(InputType::LnUrlPay { data: pd }) = parse(lnurl_pay_url).await {
        let amount_msat = pd.min_sendable;
        let optional_comment = Some("<comment>".to_string());
        let optional_payment_label = Some("<label>".to_string());
        let optional_validate_success_action_url = Some(true);

        let prepare_response = sdk.prepare_lnurl_pay(PrepareLnUrlPayRequest {
            data: pd,
            amount_msat,
            comment: optional_comment,
            validate_success_action_url: optional_validate_success_action_url,
        }).await?;

        sdk.lnurl_pay(model::LnUrlPayRequest {
            prepare_response
        })
        .await?;
    }
    // ANCHOR_END: lnurl-pay

    Ok(())
}
