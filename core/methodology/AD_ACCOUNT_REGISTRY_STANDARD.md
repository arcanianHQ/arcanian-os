---
scope: shared
type: methodology
version: 1.0
created: 2026-04-14
---

# Ad Account Registry Standard

## Purpose

Every client with paid media MUST have an `AD_ACCOUNT_REGISTRY.md` in their client directory. Without it, paid channel analysis is blind.

The registry answers one question before any analysis begins: **which accounts are we looking at, over what time window, in what currency, and who controls them?** These are not details — they are prerequisites. An analysis that skips them is not an analysis; it is a guess dressed as one.

Specific failure modes this standard prevents:
- Querying a shared account at account level, attributing another client's spend to this client
- Missing an account that went dark 4 months ago and interpreting the resulting drop as performance decline
- Summing HUF and USD spend as if they were the same number
- Treating a newly restructured account as a continuation of the previous one
- Comparing current performance against a period when a different agency was running a different account structure

## What the Registry Contains

### Per Account
- **Databox source ID** — the exact ID used in every MCP query
- **Platform** — Google Ads, Facebook/Meta Ads, TikTok Ads, LinkedIn Ads, etc.
- **Account name** — as it appears in the platform
- **Account ID** — platform-native account identifier (customer ID, ad account ID, etc.)
- **Currency** — the account's native currency (HUF, USD, EUR, etc.)
- **Business unit** — which BU or domain this account belongs to (critical for multi-domain clients)
- **Campaign prefix → business unit mapping** — for shared accounts, the prefix convention that separates spend
- **Managing agency** — who is currently running this account (internal team, or which agency)
- **Active date range** — first confirmed data date and last confirmed data date
- **Monthly spend trailing 24 months** — populated by the ad-account-auditor agent
- **Flagged gaps** — months with null data, >30% MoM swings, or structural breaks

### Registry-Level
- **Shared account isolation rules** — any account managing spend for multiple BUs must have explicit campaign prefix filters documented here. These filters are mandatory in every query.
- **Data gaps and warnings table** — cross-account view of missing data, severity ratings, possible causes, and verification status
- **Last audit metadata** — date, auditor identity, next scheduled audit date

## When to Update

Update the registry immediately when any of the following occurs:

| Trigger | Required Action |
|---|---|
| New ad account discovered | Add to inventory, pull 24-month history, classify BU |
| Account goes dark (2+ months null data) | Update status to INACTIVE, flag in gaps table, log to EVENT_LOG.md |
| Agency change | Update managing agency field, note handover date, check for account restructuring |
| Campaign prefix convention changes | Update prefix → BU map, note the change date |
| New Databox data source added | Add source ID to registry, verify it matches an existing account or create new entry |
| New domain or business unit spins up | Verify no existing account is shared; if shared, enforce prefix isolation immediately |
| Currency change on an account | Update currency field, flag all historical comparisons that span the change date |

## The 5-Step Pre-Flight Rule

Before any paid channel analysis, run this checklist in order. Do not skip steps.

**Step 1 — Load the registry.**
Read `clients/{slug}/AD_ACCOUNT_REGISTRY.md`. If it does not exist, STOP. Create a task to build it, flag all paid data as [PARTIAL], and note this limitation explicitly in the output.

**Step 2 — Verify current data coverage.**
Check the "Last Data" column for every account in the analysis scope. If Last Data is more than 2 months before the analysis period end, that account may be dead or the Databox source may be broken. Do not include it silently — flag it.

**Step 3 — Flag new and inactive accounts.**
Accounts with less than 3 months of history cannot support period-over-period comparisons. Accounts with no data for 2+ months may have been decommissioned. Both must be called out before conclusions are drawn.

**Step 4 — Apply campaign prefix filters for shared accounts.**
If any account in scope appears in the "Shared Account Isolation Rules" section, the campaign prefix filter is mandatory. Querying at account level without the filter will mix spend from different business units. This is not a suggestion.

**Step 5 — Confirm currency.**
If the analysis spans multiple accounts with different currencies, conversion is required before any aggregate calculation. Never sum HUF and USD. Note the exchange rate used and its date.

## The 2-Year Lookback Principle

A single-period view of paid performance is always misleading. Accounts appear, die, get restructured, get handed to different agencies, have campaigns renamed, have budgets reallocated. Without seeing the full 24-month pattern, the analyst cannot distinguish:

- Organic performance change from structural account change
- True seasonality from a gap in data
- Agency performance from budget shift
- Campaign optimization from a competing campaign being paused

**Before drawing any conclusion about paid channel performance, pull 24-month monthly spend for all accounts in the registry.** This is the baseline. Anything that looks like a trend, a drop, or a breakthrough must be checked against this timeline first.

## Currency Handling

- Note currency per account. Every account has exactly one native currency.
- Never sum accounts with different currencies without explicit conversion.
- Flag accounts where the account currency does not match the business unit's reporting currency (e.g., a HUF-denominated BU running ads through a USD account).
- When conversion is applied, state: the rate source, the rate used, and the date of the rate.
- Historical analysis that spans a currency change on an account requires a note at the point of change.

Evidence tags for spend data: `[DATA: Databox, {date}]` for live MCP queries. `[STATED: registry, {date}]` for values taken from the registry without live verification. `[INFERRED]` for any spend figure derived from incomplete data.

## Relationship to Other Files

### DOMAIN_CHANNEL_MAP.md
The DOMAIN_CHANNEL_MAP.md answers "how does data flow" — which tracking sources, tags, and integrations are live for each domain. The AD_ACCOUNT_REGISTRY.md answers "how does money move" — which accounts, in which platforms, controlled by whom. These are complementary. For multi-domain clients, every ad account in the registry must map to exactly one domain in the channel map.

Reference: `core/methodology/DOMAIN_CHANNEL_MAP.md` (per-client, in `clients/{slug}/brand/`)

### EVENT_LOG.md
Account start dates, account decommission dates, agency handovers, and campaign restructuring events are mandatory entries in the client's EVENT_LOG.md. The registry stores the current state; the event log stores the history of how it got there.

Reference: `clients/{slug}/EVENT_LOG.md`

### DATABOX_MANDATORY_RULE.md
All spend data in the registry must originate from live Databox MCP queries. No fallback to cached data, spreadsheets, or memory.

Reference: `core/methodology/DATABOX_MANDATORY_RULE.md`

## What Did We Get Wrong? What's Missing?

This standard was built from observed failure patterns across multiple clients. It should be revised when:
- A new failure mode is discovered that these rules would not have caught
- A client's account structure doesn't fit the template (add a variant, don't silently skip)
- The 2-year lookback window proves too long or too short in practice

Raise revisions via CAPTAINS_LOG.md or the core/ PR process.
