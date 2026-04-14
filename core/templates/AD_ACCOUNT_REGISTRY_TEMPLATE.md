---
scope: shared
type: template
version: 1.0
created: 2026-04-14
standard: core/methodology/AD_ACCOUNT_REGISTRY_STANDARD.md
---

# Ad Account Registry — {Client Display Name}

v1.0 — {date}

> Built by: {agent or person}
> Last audited: {date}
> Next scheduled audit: {date}

---

## Account Inventory

### Meta Ads

| Databox ID | Account Name | Account ID | Currency | Business Unit | Campaign Prefixes | Agency | First Data | Last Data | Status |
|---|---|---|---|---|---|---|---|---|---|
| {databox_source_id} | {account_name} | {meta_account_id} | {HUF/USD/EUR} | {bu_name} | {prefix_pattern or "not shared"} | {agency_name or "internal"} | {YYYY-MM} | {YYYY-MM} | ACTIVE / INACTIVE / SHARED |

### Google Ads

| Databox ID | Account Name | Account ID | Currency | Business Unit | Campaign Prefixes | Agency | First Data | Last Data | Status |
|---|---|---|---|---|---|---|---|---|---|
| {databox_source_id} | {account_name} | {google_customer_id} | {HUF/USD/EUR} | {bu_name} | {prefix_pattern or "not shared"} | {agency_name or "internal"} | {YYYY-MM} | {YYYY-MM} | ACTIVE / INACTIVE / SHARED |

### Other Platforms

> Add sections below for TikTok Ads, LinkedIn Ads, Pinterest Ads, etc. as applicable.
> Use the same table structure.

| Databox ID | Account Name | Account ID | Currency | Business Unit | Campaign Prefixes | Agency | First Data | Last Data | Status |
|---|---|---|---|---|---|---|---|---|---|
| {databox_source_id} | {account_name} | {platform_account_id} | {HUF/USD/EUR} | {bu_name} | {prefix_pattern or "not shared"} | {agency_name or "internal"} | {YYYY-MM} | {YYYY-MM} | ACTIVE / INACTIVE / SHARED |

---

## Campaign Prefix → Business Unit Map

> Complete this section for ALL accounts. For non-shared accounts, note "exclusive to {BU}."
> For shared accounts, this table is MANDATORY and must be kept current.

| Prefix Pattern | Business Unit | Platform | Account Name | Notes |
|---|---|---|---|---|
| {prefix_*} | {bu_name} | {platform} | {account_name} | {e.g., "convention since YYYY-MM"} |
| {prefix_*} | {bu_name} | {platform} | {account_name} | {e.g., "changed from X to Y on YYYY-MM"} |

---

## Shared Account Isolation Rules

> One section per shared account. If no accounts are shared, write "No shared accounts — all accounts are exclusive to a single business unit."

### {Account Name} — {Databox ID}

**Shared between:** {BU_A} and {BU_B}

**Filter rule for {BU_A} queries:** Campaign name contains `{prefix_A}`
**Filter rule for {BU_B} queries:** Campaign name contains `{prefix_B}`

**MANDATORY:** Never query this account at account level without a campaign filter applied. Account-level spend mixes {BU_A} and {BU_B} and produces meaningless totals.

**Verification date:** {date}
**Verified by:** {agent or person}

---

## Monthly Spend History (Trailing 24 Months)

> One subsection per account. Pull via ad-account-auditor agent using Databox MCP.
> Flag null months. Flag months with >30% MoM change (up or down).

### {Account Name} ({Databox ID}) — {Currency}

| Month | Spend | Currency | Notes |
|---|---|---|---|
| {YYYY-MM} | {amount} | {currency} | |
| {YYYY-MM} | {amount} | {currency} | |
| {YYYY-MM} | {amount} | {currency} | FLAG: null data — possible gap |
| {YYYY-MM} | {amount} | {currency} | FLAG: +{X}% MoM — verify cause |
| {YYYY-MM} | {amount} | {currency} | FLAG: -{X}% MoM — verify cause |

> Repeat for all 24 months. Minimum 12 rows required; 24 rows preferred.
> If the account is less than 24 months old, fill from first data date and note the account age.

---

## Data Gaps & Warnings

| Account | Gap Period | Severity | Possible Cause | Verified? |
|---|---|---|---|---|
| {account_name} | {YYYY-MM to YYYY-MM} | HIGH / MEDIUM / LOW | {e.g., "Databox source disconnected", "account paused", "agency handover"} | YES / NO |
| {account_name} | {YYYY-MM} | MEDIUM | {e.g., ">30% MoM drop — campaign restructuring suspected"} | NO |

**Severity guide:**
- HIGH — null data for 2+ consecutive months, or account status unknown
- MEDIUM — single null month, or >30% MoM change without a known cause
- LOW — minor anomaly, likely explained by seasonality or budget adjustment

---

## Currency Notes

> Complete only if multiple currencies are in use across accounts.

| Business Unit | Reporting Currency | Account Currency | Conversion Required? | Notes |
|---|---|---|---|---|
| {bu_name} | {HUF/EUR/USD} | {account_currency} | YES / NO | {e.g., "USD account, reports in HUF — use ECB rate at month-end"} |

**Conversion standard:** {state the rate source and cadence used, e.g., "ECB monthly average, applied on last day of each month"}

---

## Last Audit

**Date:** {YYYY-MM-DD}
**Auditor:** {agent name or person name}
**Method:** {e.g., "ad-account-auditor agent via Databox MCP" or "manual review"}
**Accounts verified:** {n} of {n}
**Changes from previous audit:** {brief summary or "first audit"}
**Next scheduled:** {YYYY-MM-DD}

---

> Standard: `core/methodology/AD_ACCOUNT_REGISTRY_STANDARD.md`
> Related: `clients/{slug}/brand/DOMAIN_CHANNEL_MAP.md`, `clients/{slug}/EVENT_LOG.md`
