> v1.0 — 2026-04-03

# AquaLux — Project Instructions

## What This Is
Example multi-domain e-commerce client — premium wellness products (hot tubs, swim spas).
3 business units, 5 domains, 2 currencies, shared ad accounts.
**Owner:** You | **Team:** You | **Created:** 2026-04-03

This is a demo project showing how Arcanian OS handles multi-domain, multi-currency complexity.

## Business Unit Isolation (MANDATORY)
**These are SEPARATE BUSINESSES. NEVER blend in analysis, budgets, or recommendations.**

| Unit | Domain | Market | Model | Currency |
|---|---|---|---|---|
| **AquaLux US** | aqualux-us.com | US D2C | Shopify, $3K-$7K products | USD |
| **AquaLux EU** | aqualux.eu, aqualux.de | EU B2C | WooCommerce | EUR |
| **AquaLux Dealers** | dealers.aqualux.com | US B2B | WordPress, lead gen | USD |

## Multi-Domain
**Before ANY analysis:** load `DOMAIN_CHANNEL_MAP.md` and filter by domain AND business unit.
- Google Ads account is SHARED (US + EU) — always filter by campaign prefix
- Meta has separate accounts per business unit
- AC has 2 instances: US and EU

## Task System
- `TASKS.md` / `TASKS_DONE.md` / `/tasks`
- Rules: `../../core/methodology/TASK_SYSTEM_RULES.md`
- Layers: L0-L7

## SOP Auto-Surface (ALWAYS-ON)
Before executing any task, check if a relevant SOP exists and LOAD it.

## Data Analysis Output Standard (ALWAYS-ON)
Every data query MUST use BLUF + OODA + Data Reliability frameworks.
Multi-domain: ALWAYS specify business unit in output.

## Databox Connection (DEMO)
**Account:** ArcanianOS DEMO (`748621`)
**Query method:** Use `ask_genie` with dataset IDs from `DOMAIN_CHANNEL_MAP.md`

**Quick reference — AquaLux US dataset IDs:**
| Data | Dataset ID | Use for |
|---|---|---|
| Sessions by channel | `83bc6595-ce2b-4c8d-89f5-5770d7900b1c` | Traffic analysis, channel breakdown |
| Conversions | `8f370b35-19af-4e27-83a0-066a0312e28d` | Conversion trends, revenue |
| Shopify Orders | `31adfa69-3f4b-471a-b746-bbe1635d8180` | Order count, AOV, tracking gap |
| CRM Contacts | `fb6f9f7c-3ff8-4dd1-990b-9db431932f7d` | Contact growth, list health |
| CRM Email | `e7ba2e29-8210-4913-8e8d-51027bcf448b` | Campaign sends, opens, clicks |
| CRM Pipeline | `dfb3c16d-3823-4592-b949-60ce27963a21` | Deals by stage, pipeline value |
| Google Ads | `01f567ea-8d5e-44f2-8f60-4c2b45b21a36` | Spend, ROAS, CPA |

**Do NOT use `list_metrics` — it returns empty for ingestion sources. Always use `ask_genie` with the dataset ID.**
