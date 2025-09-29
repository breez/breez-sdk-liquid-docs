# Moving to production 

## Production checklist
There are some use cases where you need to verify that they are implemented correctly. Here is a checklist you can use to verify that your application is production ready.

- **Add logging**: Add sufficient logging into your application to diagnose any issues users are having. Include log entries from the Breez SDK upto and including **DEBUG** level. For more information: [Adding logging](logging.md).

- **Display pending payments**: Payments always contain a status field that can be used to determine if the payment was completed or not. Make sure you handle the case where the payment is still pending by showing the correct status to the user.

- **Enable swap refunds**: Swaps that are the result of [receiving a Bitcoin payment](receive_payment.html#bitcoin) may not be completed and change to `Refundable` state. Make sure you handle this case correctly by allowing the user to retry the [refund](refund_payment.html#refunding-payments) with different fees as long as the refund is not confirmed.

- **Expose swap fees**: When sending or receiving on-chain, make sure to clearly show the expected fees involved, as well as the send / receive amounts.
