> v1.1 — {date}

# {Client} — Domain & Channel Map

> Maps every marketing channel, tool, and data source to the domain it serves.
> **LOAD THIS BEFORE ANY ANALYSIS.** See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.
> **Lag column:** typical sync delay per source. See `core/methodology/ALARM_CALIBRATION.md`.
> **Currency column:** native currency per source. See `core/methodology/CURRENCY_NORMALIZATION.md`.

---

## Domains

| Domain | Market | Platform | Primary Use |
|--------|--------|----------|-------------|
| example.com | US | Shopify | D2C e-commerce |
| example.hu | HU | WordPress | Corporate site |

---

## Ad Accounts → Domain Mapping

### Google Ads

| Account | Account ID | Currency | Domains served | Notes |
|---------|-----------|----------|----------------|-------|
| {Name} | `XXX-XXX-XXXX` | {CUR} | domain1, domain2 | Shared account — filter by campaign |

**Campaign → Domain patterns:**

| Campaign name pattern | Domain | Type | Notes |
|-----------------------|--------|------|-------|
| `domain1.com_*` | domain1.com | PMax/Search/etc. | |
| `domain2.hu_*` | domain2.hu | PMax/Search | |

### Meta / Facebook Ads

| Ad Account | Account ID | Domains served | Notes |
|------------|-----------|----------------|-------|
| {Name} | `act_XXXXX` | domain1.com | |

**Campaign → Domain patterns (if shared account):**

| Campaign name pattern | Domain | Type | Notes |
|-----------------------|--------|------|-------|
| | | | |

### Other Paid Channels

| Channel | Account/ID | Domain | Currency | Notes |
|---------|-----------|--------|----------|-------|
| Bing Ads | | | | |
| Criteo | | | | |
| Amazon Ads | | | | |

---

## Analytics → Domain Mapping

### GA4

| Property Name | Property ID | Domain | Notes |
|---------------|------------|--------|-------|
| {Name} | `XXXXXXXXX` | domain1.com | |

### GTM

| Container Name | Container ID | Type | Domain | Notes |
|----------------|-------------|------|--------|-------|
| {Name} | `GTM-EXAMPLE-001` | Web | domain1.com | |
| {Name} | `GTM-EXAMPLE-001` | Server | domain1.com | sst.domain1.com |

### Search Console

| Property | Domain | Notes |
|----------|--------|-------|
| `https://domain1.com` | domain1.com | |

---

## E-commerce → Domain Mapping

| Platform | Store/Instance | Domain | Currency | Notes |
|----------|---------------|--------|----------|-------|
| Shopify | {store}.myshopify.com | domain1.com | USD | |
| WooCommerce | domain2.hu | domain2.hu | HUF | |

---

## CRM / Email → Domain Mapping

| Platform | Instance/Account | Domain(s) | Notes |
|----------|-----------------|-----------|-------|
| ActiveCampaign | {url}.api-us1.com | domain1.com | |
| Klaviyo | | | |

---

## Databox → Domain Mapping

> **CRITICAL for automated analysis.** Every Databox data source ID must be mapped to the domain(s) it covers and whether it's shared.

| Databox Source ID | Platform | What it measures | Domain(s) | Shared? | Currency | Typical Lag | Filter by |
|-------------------|----------|-----------------|-----------|---------|----------|-------------|-----------|
| `XXXXXXX` | Google Ads | All campaigns in account | domain1, domain2 | **YES** | {CUR} | ~4h | `dimension: "campaign"` + name patterns |
| `XXXXXXX` | Shopify | domain1.com orders | domain1.com | No | {CUR} | ~24-48h | — |
| `XXXXXXX` | Meta Ads | domain1.com campaigns | domain1.com | No | {CUR} | ~6h | — |

---

## Reporting / BI → Domain Mapping

| Tool | Dashboard/Report | Domain(s) covered | Notes |
|------|-----------------|-------------------|-------|
| Databox | CEO Pulse | All domains (blended) | |
| Roivenue | | | |
| Windsor | | | |

---

## Unmapped / Unknown

> Channels discovered but not yet mapped. **Each is an analysis blind spot.**

| Channel | What we know | Discovered | Action needed |
|---------|-------------|------------|---------------|
| | | | |

---

## Change Log

| Date | Change | By |
|------|--------|-----|
| {date} | Initial map created | {name} |
