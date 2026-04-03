---
client: "{Client Name}"
slug: "{slug}"
created: "YYYY-MM-DD"
last_updated: "YYYY-MM-DD"
status: "active"
platform: ""
platform_version: ""
---

# {Client Name} — Configuration

## Domains

| Environment | Country | Domain | Notes |
|-------------|---------|--------|-------|
| Production  | HU      | `example.hu` | |
| Production  | RO      | `example.ro` | |
| Staging     | —       | `staging.example.hu` | |
| SGTM        | HU      | `sgtm.example.hu` | |
| SGTM        | RO      | `sgtm.example.ro` | |

## GTM / SGTM Container IDs

| Country | Type | Container ID | Container Name | Notes |
|---------|------|-------------|----------------|-------|
| HU      | Web  | `GTM-EXAMPLE-001` | | |
| HU      | SGTM | `GTM-EXAMPLE-001` | | |
| RO      | Web  | `GTM-EXAMPLE-001` | | |
| RO      | SGTM | `GTM-EXAMPLE-001` | | |

## Meta Pixel & Catalogue IDs

| Country | Pixel ID | Catalogue ID | Business Manager | Notes |
|---------|----------|-------------|------------------|-------|
| HU      | | | | |
| RO      | | | | |

## Feed URLs & Baselines

| Country | Feed URL | Format | Item Count (baseline) | Last Checked | Notes |
|---------|----------|--------|----------------------|--------------|-------|
| HU      | | XML/CSV | | | |
| RO      | | XML/CSV | | | |

## GA4 Property IDs

| Country | Property ID | Measurement ID | Data Stream | Notes |
|---------|-------------|---------------|-------------|-------|
| HU      | | `G-XXXXXXX` | | |
| RO      | | `G-XXXXXXX` | | |

## Google Ads Account & Conversion IDs

| Country | Account ID | Conversion Action | Conversion ID | Conversion Label | Notes |
|---------|-----------|-------------------|---------------|-----------------|-------|
| HU      | `XXX-XXX-XXXX` | Purchase | | | |
| HU      | `XXX-XXX-XXXX` | Add to Cart | | | |
| RO      | `XXX-XXX-XXXX` | Purchase | | | |

## CMP Configuration

| Field | Value |
|-------|-------|
| CMP Type | Amasty / CookieYes / OneTrust / Cookiebot / Custom |
| Cookie Banner Mode | opt-in / opt-out / implied |
| Analytics consent group | |
| Marketing consent group | |
| Functional consent group | |

**Consent type mapping:**

| GTM Consent Type | CMP Group | Cookie Name | Default |
|-----------------|-----------|-------------|---------|
| `analytics_storage` | | | `denied` |
| `ad_storage` | | | `denied` |
| `ad_user_data` | | | `denied` |
| `ad_personalization` | | | `denied` |
| `functionality_storage` | | | `granted` |
| `personalization_storage` | | | `denied` |
| `security_storage` | | | `granted` |

## Platform Access

| Platform | Who Has Access | Access Level | Notes |
|----------|---------------|-------------|-------|
| GTM (Web) | | Editor/Admin | |
| GTM (SGTM) | | Editor/Admin | |
| GA4 | | Editor/Viewer | |
| Meta Business Manager | | Admin/Analyst | |
| Google Ads | | MCC/Direct | |
| Magento Admin | | | |
| Feed Management Tool | | | |

## Test Products

> Select 10 products representing different types for full-path tracing.

| # | Product Name | Product ID | SKU | Type | URL | Price | Notes |
|---|-------------|-----------|-----|------|-----|-------|-------|
| 1 | | | | Simple | | | |
| 2 | | | | Simple | | | |
| 3 | | | | Configurable | | | |
| 4 | | | | Configurable | | | |
| 5 | | | | Bundle | | | |
| 6 | | | | Bundle | | | |
| 7 | | | | Grouped | | | |
| 8 | | | | Virtual/Download | | | |
| 9 | | | | On Sale | | | |
| 10 | | | | Out of Stock | | | |

## Product Types & SKU Structure

| Type | ID Format | SKU Format | Notes |
|------|----------|-----------|-------|
| Simple | | | |
| Configurable | Parent: / Child: | | |
| Bundle | | `BUNDLE-*` | |
| Grouped | | | |

## Platform Specifics

### Magento

| Field | Value |
|-------|-------|
| Version | 2.x.x |
| Edition | Community / Enterprise |
| Catalog Price Scope | Global / Website |
| Product ID attribute | `entity_id` / `sku` |
| Configurable → Simple relationship | |
| Bundle dynamic pricing | Yes / No |
| Custom modules affecting tracking | |

### Shopify (if applicable)

| Field | Value |
|-------|-------|
| Plan | |
| Theme | |
| Checkout type | Standard / Checkout Extensibility |
| Product ID format | `shopify_{region}_{id}` / numeric |
| Variant handling | |

### WooCommerce (if applicable)

| Field | Value |
|-------|-------|
| Version | |
| Theme | |
| Product ID format | |
| Variable product handling | |

---

**Template version:** 1.0
**Last updated:** 2026-03-07
