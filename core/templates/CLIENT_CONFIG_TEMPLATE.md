---
client: "{project_name}"
updated: "YYYY-MM-DD"
classification: "CONFIDENTIAL"
---
> v1.0 — 2026-04-03

# {Display Name} — Client Configuration

> **CONFIDENTIAL** — Contains tracking IDs, domains, and system details.
> Update on every access/platform change. Review quarterly.

---

## Company

| Field | Value |
|---|---|
| **Legal name** | |
| **Contact person** | |
| **Industry** | |
| **Market** | (country/countries) |
| **Currency** | |
| **Website(s)** | |

## Reporting

| Field | Value |
|---|---|
| **Reporting currency** | (EUR / HUF / USD — for cross-domain totals. See `core/methodology/CURRENCY_NORMALIZATION.md`) |
| **Alarm sensitivity** | normal (low / normal / high — see `core/methodology/ALARM_CALIBRATION.md`) |

## Domains

| Domain | Platform | Country | Status |
|---|---|---|---|
| | | | Active / Inactive |

---

## Tracking IDs

| Platform | Property/ID | Container | Notes |
|---|---|---|---|
| **GA4** | G- | | |
| **Google Ads** | AW- | | |
| **Meta Pixel** | | | |
| **GTM (Web)** | GTM- | Workspace | |
| **GTM (sGTM)** | GTM- | Workspace | |
| **sGTM Domain** | sst. | Provider | TAGGRS / Stape / Custom |
| **Hotjar** | | | |
| **TikTok** | | | |
| **Pinterest** | | | |

---

## Platform Access (System Access Dictionary)

> Per-platform detail: URL, plan, auth, risk, integrations.

### CRM / Email

| Field | Value |
|---|---|
| **Platform** | (ActiveCampaign / HubSpot / etc.) |
| **URL** | |
| **Plan** | |
| **Primary auth** | |
| **Backup auth** | |
| **Key data** | (contacts, deals, automations) |
| **Risk if lost** | HIGH / MEDIUM / LOW |
| **Integrations** | |
| **Status** | |

### E-commerce

| Field | Value |
|---|---|
| **Platform** | (Shopify / WooCommerce / Unas / Magento / etc.) |
| **URL** | (admin URL) |
| **Primary auth** | |
| **Backup auth** | |
| **Key data** | (products, orders/month) |
| **Integrations** | |

### Analytics

| Field | Value |
|---|---|
| **GA4 Property** | |
| **BigQuery** | (linked? project ID?) |
| **Looker Studio** | (dashboard URLs) |
| **Attribution** | (Roivenue / other) |

### Advertising

| Platform | Account ID | Status | Manager | Billing | Notes |
|---|---|---|---|---|---|
| Google Ads | | Active/Suspended | (who manages) | (payment method) | |
| Meta Ads | | | | | |
| TikTok Ads | | | | | |

### Tag Management

| Container | ID | Type | Workspace | Active Tags | Paused Tags |
|---|---|---|---|---|---|
| Web GTM | GTM- | Web | ws | | |
| sGTM | GTM- | Server | ws | | |

### Other Platforms

| Platform | URL | Auth | Status | Purpose |
|---|---|---|---|---|
| (Channable, Databox, JustCall, Make.com, etc.) | | | | |

---

## Feed URLs

| Feed | URL | Format | Items | Updated |
|---|---|---|---|---|
| Google Shopping | | XML | | |
| Meta Catalogue | | XML | | |
| Árukereső | | XML | | |

---

## CMP (Consent Management)

| Field | Value |
|---|---|
| **Platform** | (CookieBot / Amasty / Unas native / etc.) |
| **Type** | |
| **Default state** | (denied / granted) |
| **Notes** | |

---

## Contacts

| Name | Role | Email | Phone | Access scope | Status |
|---|---|---|---|---|---|
| | Decision maker | | | | Active |
| | Developer | | | | Active |
| | Marketing | | | | Active |
| | Agency (PPC) | | | | Active |
| | Agency (SEO) | | | | Active |

---

## Access History

| Date | Change | By |
|---|---|---|
| YYYY-MM-DD | Initial setup | |
