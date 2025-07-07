# Partner Fees

Partners have the option to set additional fees, which will be used for revenue sharing. In addition to the base fees charged by the SDK, partners can configure an additional fee percentage for Bitcoin on-chain and Lightning transactions processed through their integration.

**Note:** Transactions between Liquid addresses are excluded.

## Partners Portal

The <a target="_blank" href="https://partners.breez.technology/">Partners Portal</a> is used to configure fee percentages and view analytics on collected fees.

### Authentication

Access to the Partners Portal is authenticated using the email address that was originally used to request the SDK API key. Authentication is handled via magic link sent to this email address.

**Note:** If you need multiple team members to access the portal, consider using a shared or group email address when requesting your API key. To change the email address, you can request a new API key.

### Configuring Fees

When setting up a partner fee percentage through the portal:

1. Navigate to the **Settings** page.
2. In **Fee Settings** review the terms and set your desired **Additional Fee Percentage**.
3. Provide a Lightning address for fee payouts.
4. Save your configuration by pressing **Save**.

All fee payouts will be sent to the configured Lightning address, so make sure it's one you control and can receive payments on.

### Analytics

The Partners Portal provides analytics on:

- Total fees collected
- Historical fee data (monthly)

**Note:** Analytics data is updated hourly rather than in real-time, so some delay between transaction activity and its appearance in the dashboard is expected.

## Fee Calculation

When a partner fee is configured, it's calculated as a percentage of the transaction amount and added to the base fees.

> **Example**: If a partner has configured a 0.5% fee and a user sends 10k sats via Lightning:
>
> - Base fees: 63 sats (from base fee structure)
> - Partner fee: 50 sats (0.5% of 10k sats)
> - Total fees: 113 sats
