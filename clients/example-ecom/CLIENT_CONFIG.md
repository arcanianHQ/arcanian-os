---
client: "AquaLux"
slug: "example-ecom"
created: "2026-04-03"
last_updated: "2026-04-03"
status: "active"
---
> v1.0 — 2026-04-03

# AquaLux — Configuration

## Company

| Field | Value |
|---|---|
| **Legal name** | AquaLux International Ltd. |
| **Industry** | Premium wellness (hot tubs, swim spas) |
| **Market** | US + EU (DE, AT, NL) |
| **Currency** | USD (US), EUR (EU) |

## Reporting

| Field | Value |
|---|---|
| **Reporting currency** | EUR (for cross-domain totals) |
| **Alarm sensitivity** | normal |

## Domains

| Domain | Platform | Country | Status |
|---|---|---|---|
| aqualux-us.com | Shopify | US | Active |
| aqualux.eu | WooCommerce | EU | Active |
| aqualux.de | WooCommerce | DE | Active |
| dealers.aqualux.com | WordPress | US | Active |

## Tracking IDs

| Platform | Property/ID | Domain | Notes |
|---|---|---|---|
| **GA4** | G-EXAMPLE-US | aqualux-us.com | |
| **GA4** | G-EXAMPLE-EU | aqualux.eu + .de | |
| **GA4** | G-EXAMPLE-DLR | dealers.aqualux.com | |
| **Google Ads (US)** | AW-EXAMPLE-101 | US + Dealers (shared) | Filter by campaign prefix |
| **Google Ads (EU)** | AW-EXAMPLE-102 | EU (shared .eu + .de) | Filter by campaign prefix |
| **GTM (US)** | GTM-EXAMPLE-US | aqualux-us.com | |
| **GTM (EU)** | GTM-EXAMPLE-EU | aqualux.eu + .de | |

## Attribution Windows (verified)

| Platform | Window | Notes |
|---|---|---|
| Google Ads | 30d click / 1d view | Default |
| Meta | 7d click / 1d view | Default |
| GA4 | Data-driven, 30d | |

## CRM

| Instance | Platform | Domains | Notes |
|---|---|---|---|
| US | ActiveCampaign (api-us1) | aqualux-us.com + dealers | ~8,000 contacts |
| EU | ActiveCampaign (EU) | aqualux.eu + .de | ~3,500 contacts |
