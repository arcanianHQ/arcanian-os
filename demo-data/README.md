---
type: demo-data
date: 2026-04-04
purpose: Synthetic datasets for Arcanian OS video walkthroughs
format: CSV (upload to Google Sheets → connect to Databox as data source)
---

# Demo Data — Video Walkthroughs

## Video 1: Sales Pulse
Multi-source e-commerce data with planted anomalies.
- `ga4_sessions.csv` — daily sessions by channel (60 days)
- `ga4_conversions.csv` — daily conversions + revenue (60 days)
- `shopify_orders.csv` — daily orders + AOV (60 days)
- `crm_contacts.csv` — daily new contacts + list growth (60 days)
- `crm_email.csv` — campaign sends, opens, clicks (60 days)
- `crm_pipeline.csv` — deal stages + values (snapshot)

**Planted anomalies:**
- Email sessions collapse -55% in last 30 days
- Paid Social declining while Cross-network grows
- Organic Search surge +50%
- 13% tracking gap (Shopify orders > GA4 conversions)
- Weekly session downtrend from week 2 peak

## Video 3: Council Debate
Conversion value drop with competing explanations.
- `google_ads_daily.csv` — daily spend, conversions, value (30 days, includes 74% drop)
- `ga4_ecommerce.csv` — sessions, transactions, revenue (same period)
- `platform_changes.csv` — log of campaign/GTM/platform changes during the period

**Planted anomaly:** 74% drop in Google Ads conversion value on day 18.
**Competing explanations baked into data:**
- H1: Campaign paused (spend drops same day)
- H2: Attribution window closing (conversions recover after 5 days)
- H3: Tracking change (GA4 shows different pattern than Google Ads)

## Video 4: Day Start
Multi-client health dashboard data.
- `client_health.csv` — 5 clients × 10 metrics × 7 days
- `weekend_anomaly.csv` — one client's Saturday/Sunday data with a real problem

**Planted:** Client 3 had a 40% session drop over the weekend + consent tracking broke.
