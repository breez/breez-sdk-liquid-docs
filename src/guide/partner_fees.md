# **Partner Fees**

**Partners can configure additional fees for revenue sharing on swap-based payments.**

## **Overview**

In addition to the base fees charged by the SDK, partners can configure an additional fee percentage that applies to all swap-based payments processed through their integration. This enables revenue sharing opportunities for partners building applications with the Breez SDK.

**Important:** Partner fees only apply to swap-based payments (Lightning payments, BTC address payments). Payments resolved purely using Liquid are not affected by partner fees.

## **Partners Portal**

The <a target="_blank" href="https://partners.breez.technology/">Partners Portal</a> is used to configure fee percentages and view analytics on collected fees.

### **Authentication**

Access to the Partners Portal is authenticated using the email address that was originally used to request the SDK API key. Authentication is handled via magic link sent to this email address.

**Note:** If you need multiple team members to access the portal, consider using a shared or group email address when requesting your API key, as access is tied to the original email used for the API key request.

### **Configuring Fees**

When setting up a partner fee percentage through the portal:

1. Navigate to the Settings page
2. In Fee Settings review the terms and set your desired "Additional Fee Percentage"
3. Provide a Lightning address for fee payouts
4. Save your configuration by pressing "Save"

The Lightning address will be used for all fee payouts, so ensure it's an address you control and can receive payments on.

### **Analytics**

The Partners Portal provides analytics on:

- Total fees collected
- Historical fee data (monthly)

**Note:** Analytics data is not real-time and is updated periodically throughout the day. There may be delays between when transactions occur and when they appear in the analytics dashboard.

## **Fee Calculation**

When a partner fee is configured, it's calculated as a percentage of the payment amount and added to the base fees.

> **Example**: If a partner has configured a 0.5% fee and a user sends 10k sats via Lightning:
>
> - Base fees: 63 sats (from base fee structure)
> - Partner fee: 50 sats (0.5% of 10k sats)
> - Total fees: 113 sats
