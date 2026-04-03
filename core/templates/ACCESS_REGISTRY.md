---
client: "{client}"
slug: "{slug}"
last_updated: "YYYY-MM-DD"
---

# {Client Name} — Access Registry

> Single source of truth for all platform accounts, property IDs, user access, API connections, and email service integrations. Update on every access change.

---

## Platform Accounts & Property IDs

### Google

| Platform | Account/Property ID | Account Name | Our Access | Access Level | Granted By | Date | Notes |
|----------|-------------------|--------------|-----------|-------------|-----------|------|-------|
| Google Analytics 4 | `{property_id}` | | `owner@example.com` | Editor | | | |
| Google Ads | `{account_id}` | | | MCC / Direct | | | |
| Google Ads (MCC) | `{mcc_id}` | | | Admin | | | |
| Google Tag Manager (Web) | `{gtm_id}` | | | Editor | | | |
| Google Tag Manager (SGTM) | `{sgtm_gtm_id}` | | | Editor | | | |
| Google Merchant Center | `{gmc_id}` | | | Admin / Standard | | | |
| Google Search Console | `{property_url}` | | | Owner / Full | | | |
| Looker Studio | | | | Editor | | | |

### Meta / Facebook

| Platform | Account/ID | Account Name | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----------|--------------|-----------|-------------|-----------|------|-------|
| Business Manager | `{bm_id}` | | | Admin / Analyst | | | |
| Meta Pixel | `{pixel_id}` | | | (via BM) | | | |
| Product Catalogue | `{catalogue_id}` | | | (via BM) | | | |
| Meta Ads Manager | `{ad_account_id}` | | | Advertiser / Analyst | | | |
| Commerce Manager | | | | | | | |

### SGTM Provider

| Platform | Account/ID | Endpoint | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----------|----------|-----------|-------------|-----------|------|-------|
| TAGGRS / Stape | `{account_id}` | `sst.{domain}` | | Admin / Viewer | | | |
| SGTM Dashboard | | | | | | | |

### E-Commerce Platform

| Platform | URL | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----|-----------|-------------|-----------|------|-------|
| Magento Admin | `{admin_url}` | | Admin / Limited | | | |
| Shopify Admin | `{shop}.myshopify.com` | | Staff / Collaborator | | | |
| WooCommerce | `{site}/wp-admin` | | Admin / Shop Manager | | | |

### Feed Management

| Platform | Account/ID | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----------|-----------|-------------|-----------|------|-------|
| Channable | | | Admin / Editor | | | |
| DataFeedWatch | | | | | | |
| Feedonomics | | | | | | |
| Google Sheets (manual) | `{sheet_id}` | | Editor | | | |

### CMP / Consent

| Platform | Account/ID | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----------|-----------|-------------|-----------|------|-------|
| Cookiebot | `{domain_group_id}` | | Admin | | | |
| CookieYes | | | | | | |
| OneTrust | | | | | | |
| Amasty (Magento) | | (via Magento admin) | | | | |

---

## Email / ESP & Marketing Automation

| Platform | Account/ID | Integration Type | Connected To | API Key (masked) | Our Access | Date | Notes |
|----------|-----------|-----------------|-------------|-----------------|-----------|------|-------|
| Klaviyo | `{public_api_key}` | JS snippet + API | Website + SGTM | `pk_***...` | | | |
| Mailchimp | | JS / API / Webhook | | | | | |
| ActiveCampaign | | | | | | | |
| Brevo (Sendinblue) | | | | | | | |
| HubSpot | `{portal_id}` | JS tracking + API | | | | | |
| Salesforce MC | | | | | | | |
| Emarsys | | | | | | | |

### ESP Integration Points

| Integration | Method | Where Configured | Status | Notes |
|-------------|--------|-----------------|--------|-------|
| Email signup tracking | GTM tag / Pixel event | | active / missing | |
| Purchase sync | API / webhook / SGTM | | active / missing | |
| Cart abandonment | JS / server-side | | active / missing | |
| Customer data sync | API / CSV / webhook | | active / missing | |
| Consent pass-through | CMP → ESP | | active / missing | GDPR: ESP must respect consent |

---

## Other Platforms & Integrations

| Platform | Account/ID | Purpose | Our Access | Access Level | Granted By | Date | Notes |
|----------|-----------|---------|-----------|-------------|-----------|------|-------|
| Hotjar / Clarity | `{site_id}` | Heatmaps, recordings | | | | | |
| Criteo | `{partner_id}` | Retargeting | | | | | |
| TikTok Pixel | `{pixel_id}` | Ads tracking | | | | | |
| Pinterest Tag | `{tag_id}` | Ads tracking | | | | | |
| LinkedIn Insight | `{partner_id}` | B2B tracking | | | | | |
| Bing UET | `{tag_id}` | Microsoft Ads | | | | | |
| Affiliate platform | | | | | | | |
| CRM | | | | | | | |
| ERP | | | | | | | |
| CDN / Cloudflare | | | | | | | |
| DNS provider | | | | | | | |

---

## API Keys & Tokens

> Store ONLY masked versions here. Full keys in secure vault (1Password, Bitwarden, etc.).

| Service | Key Type | Masked Value | Scope | Expires | Vault Location | Notes |
|---------|---------|-------------|-------|---------|---------------|-------|
| GA4 Data API | Service Account | `***@***.iam.gserviceaccount.com` | Read-only | Never | | |
| Meta Marketing API | Access Token | `EAAx...***` | Ads Read | YYYY-MM-DD | | |
| SGTM API | | | | | | |
| Feed API | | | | | | |
| ESP API | | `pk_***` / `sk_***` | | | | |

---

## Access Request Log

> Track every access request: when asked, who from, what for, status.

| Date | Platform | Requested From | What Was Requested | Status | Granted Date | Notes |
|------|----------|---------------|-------------------|--------|-------------|-------|
| | GTM Web | | Editor access | pending / granted / denied | | |
| | GA4 | | Viewer access | | | |
| | Meta BM | | Analyst access | | | |

### Access Status Legend

| Status | Meaning |
|--------|---------|
| `pending` | Requested, waiting for client |
| `granted` | Access confirmed and working |
| `denied` | Client declined (see notes) |
| `expired` | Access revoked or token expired |
| `not-needed` | Phase doesn't require this access |

---

## Access Checklist — Per Audit Phase

> Check off what's needed before each phase. Not all phases need all access.

| Access | Phase 0 (CLI) | Phase 1 (Browser) | Phase 2 (Dashboard) | Phase 3 (Container) | Phase 4 (Cross-verify) | Phase 5 (Diagnosis) |
|--------|:---:|:---:|:---:|:---:|:---:|:---:|
| Domain URL | **Required** | **Required** | | | **Required** | |
| SGTM endpoint | **Required** | | | | **Required** | |
| Feed URLs | **Required** | | | | **Required** | |
| Chrome DevTools | | **Required** | | | **Required** | |
| GA4 property | | | **Required** | | | |
| Google Ads account | | | **Required** | | | |
| Meta Business Manager | | | **Required** | | | |
| GTM Editor (Web) | | | | **Required** | | |
| GTM Editor (SGTM) | | | | **Required** | | |
| GMC account | | | **Required** | | | |
| Feed management tool | | | | | | |
| ESP platform | | | | | | |
| All collected data | | | | | | **Required** |

---

**Template version:** 1.0
**Last updated:** 2026-03-07
