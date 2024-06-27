# Using LNURL

Interacting with a LNURL endpoint consists of two steps:

1. Parse the LNURL string using `parse(lnurl_url).await`. This returns a `Result<InputType>`. The specific `InputType`
you receive will tell you what kind of endpoint this is, as well as give you the relevant endpoint parameters.
2. Call the corresponding service method. For example, for LNURL-pay, that is `LiquidSdk::lnurl_pay()`.