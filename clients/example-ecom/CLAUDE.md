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

## Databox Connection

**Account:** ArcanianOS DEMO (`748621`)

### How This Demo Differs from Production

This demo uses **synthetic data pushed to Databox** via the ingestion API. In a real client setup, you connect native data sources (GA4, Google Ads, Shopify, ActiveCampaign, etc.) directly in Databox — and then `load_metric_data` works with standard metric keys like `GoogleAnalytics4@sessions` or `Shopify@orders`.

| | Demo (this project) | Production (real client) |
|---|---|---|
| **Data source** | Custom datasets (pushed CSV) | Native connectors (GA4, Shopify, etc.) |
| **Query method** | `ask_genie` with dataset ID | `load_metric_data` with metric key |
| **Speed** | Slower (natural language query) | Fast (structured API call) |
| **Setup** | Ingest data → query via Genie | Connect account → metrics auto-discovered |

**For this demo, ALWAYS use `ask_genie` with the dataset ID. Do NOT use `list_metrics` or `load_metric_data` — they return empty for custom ingestion sources.**

In production: connect GA4 in Databox → `load_metric_data(data_source_id=X, metric_key="GoogleAnalytics4@sessions")` works immediately.

### Quick Reference — AquaLux US Dataset IDs

Query these with `ask_genie(dataset_id="...", question="...")`:

| Data | Dataset ID | Columns | Period |
|---|---|---|---|
| Sessions by channel | `83bc6595-ce2b-4c8d-89f5-5770d7900b1c` | date, channel, sessions | 60 days |
| Conversions + Revenue | `8f370b35-19af-4e27-83a0-066a0312e28d` | date, conversions, revenue, aov | 60 days |
| Shopify Orders | `31adfa69-3f4b-471a-b746-bbe1635d8180` | date, orders, revenue, aov | 60 days |
| CRM Contacts | `fb6f9f7c-3ff8-4dd1-990b-9db431932f7d` | date, new_contacts, total_contacts, new_list_subscribers, unsubscribes | 60 days |
| CRM Email | `e7ba2e29-8210-4913-8e8d-51027bcf448b` | date, sends, opens, clicks, bounces, unsubscribes, open_rate, click_rate | 60 days |
| CRM Pipeline | `dfb3c16d-3823-4592-b949-60ce27963a21` | deal_name, stage, value, days_in_stage, created_date | 16 deals |
| Google Ads | `01f567ea-8d5e-44f2-8f60-4c2b45b21a36` | date, spend, conversions, conversion_value, cpa, roas | 30 days |

### Planted Anomalies (for testing/demos)

The data contains realistic anomalies the system should detect:
- Email campaign sends collapsed ~55% in March vs February
- Paid Social sessions declining while Cross-network grows
- Organic Search surged +50%
- Shopify orders 13% higher than GA4 conversions (tracking gap)
- Weekly sessions peak in Week 2, then decline through Month end
- Pipeline concentration: top 2 deals = 65% of Contract Sent stage
