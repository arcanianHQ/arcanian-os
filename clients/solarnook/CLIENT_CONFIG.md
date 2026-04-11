---
client: "SolarNook"
slug: "solarnook"
created: "2026-04-03"
last_updated: "2026-04-03"
status: "active"
---
> v1.0 — 2026-04-03

# SolarNook — Configuration

## Company

| Field | Value |
|---|---|
| **Legal name** | SolarNook International Ltd. |
| **Industry** | Premium outdoor living (pergolas, shading systems) |
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
| solarnook-us.com | Shopify | US | Active |
| solarnook.eu | WooCommerce | EU | Active |
| solarnook.de | WooCommerce | DE | Active |
| dealers.solarnook.com | WordPress | US | Active |

## Tracking IDs

| Platform | Property/ID | Domain | Notes |
|---|---|---|---|
| **GA4** | G-EXAMPLE-US | solarnook-us.com | |
| **GA4** | G-EXAMPLE-EU | solarnook.eu + .de | |
| **GA4** | G-EXAMPLE-DLR | dealers.solarnook.com | |
| **Google Ads (US)** | AW-EXAMPLE-101 | US + Dealers (shared) | Filter by campaign prefix |
| **Google Ads (EU)** | AW-EXAMPLE-102 | EU (shared .eu + .de) | Filter by campaign prefix |
| **GTM (US)** | GTM-EXAMPLE-US | solarnook-us.com | |
| **GTM (EU)** | GTM-EXAMPLE-EU | solarnook.eu + .de | |

## Attribution Windows (verified)

| Platform | Window | Notes |
|---|---|---|
| Google Ads | 30d click / 1d view | Default |
| Meta | 7d click / 1d view | Default |
| GA4 | Data-driven, 30d | |

## CRM

| Instance | Platform | Domains | Notes |
|---|---|---|---|
| US | ActiveCampaign (api-us1) | solarnook-us.com + dealers | ~8,000 contacts |
| EU | ActiveCampaign (EU) | solarnook.eu + .de | ~3,500 contacts |
