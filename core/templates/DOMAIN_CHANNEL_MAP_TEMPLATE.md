---
scope: shared
---

> v1.3 — {date}

# {Client} — Domain & Channel Map

> Maps every marketing channel, tool, and data source to the domain it serves.
> **LOAD THIS BEFORE ANY ANALYSIS.** See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.
> **Lag column:** typical sync delay per source. See `core/methodology/ALARM_CALIBRATION.md`.
> **Currency column:** native currency per source. See `core/methodology/CURRENCY_NORMALIZATION.md`.
> **Date columns (MANDATORY):** every mapping has `Active Since` and `Status` — accounts die, campaigns move, sources change. A mapping without dates is a mapping you can't trust.
> **Temporal Awareness:** See `core/methodology/TEMPORAL_AWARENESS_RULE.md`.

## Business Units

> **Define how this client's domains group into business units.** Different clients have different structures:
> - **Separate businesses** (e.g., BuenoSpa vs Wellis HU) → different P&L, different markets, NEVER blend
> - **Same business, different markets** (e.g., Diego HU/RO/SK) → same brand, different currencies/ads, specify market
> - **Same business, different segments** (e.g., Standard vs Premium) → different customers, different economics
> - **Same business, different domains** (e.g., SEO domains) → group by platform, analyze per domain
>
> If only 1 domain: delete this section.

| Unit | Domains | Market/Segment | Currency | Isolation Level | Active Since | Status |
|---|---|---|---|---|---|---|
| {Unit name} | {domain(s)} | {market or segment} | {currency} | {NEVER blend / specify market / per-domain} | 2023-01 | Active |

### Enforcement Rules

1. **"{Client} ROAS"** requires specifying which unit: {list units}.
2. **Budget recommendations** per unit — {reason}.
3. **Cross-unit comparison** is valid IF clearly labeled and currencies normalized.

---

## Domains

| Domain | Market | Platform | Primary Use | Active Since | Status |
|--------|--------|----------|-------------|-------------|--------|
| example.com | US | Shopify | D2C e-commerce | 2023-01 | Active |
| example.hu | HU | WordPress | Corporate site | 2021-06 | Active |

---

## Ad Accounts → Domain Mapping

### Google Ads

| Account | Account ID | Currency | Domains served | Active Since | Status | Notes |
|---------|-----------|----------|----------------|-------------|--------|-------|
| {Name} | `XXX-XXX-XXXX` | {CUR} | domain1, domain2 | 2023-01 | Active | Shared account — filter by campaign |

**Campaign → Domain patterns:**

| Campaign name pattern | Domain | Type | Active Since | Status | Notes |
|-----------------------|--------|------|-------------|--------|-------|
| `domain1.com_*` | domain1.com | PMax/Search/etc. | 2023-01 | Active | |
| `domain2.hu_*` | domain2.hu | PMax/Search | 2024-03 | Active | |

### Meta / Facebook Ads

| Ad Account | Account ID | Domains served | Active Since | Status | Notes |
|------------|-----------|----------------|-------------|--------|-------|
| {Name} | `act_XXXXX` | domain1.com | 2023-01 | Active | |

**Campaign → Domain patterns (if shared account):**

| Campaign name pattern | Domain | Type | Active Since | Status | Notes |
|-----------------------|--------|------|-------------|--------|-------|
| | | | | | |

### Other Paid Channels

| Channel | Account/ID | Domain | Currency | Active Since | Status | Notes |
|---------|-----------|--------|----------|-------------|--------|-------|
| Bing Ads | | | | | | |
| Criteo | | | | | | |
| Amazon Ads | | | | | | |

---

## Analytics → Domain Mapping

### GA4

| Property Name | Property ID | Domain | Active Since | Status | Notes |
|---------------|------------|--------|-------------|--------|-------|
| {Name} | `XXXXXXXXX` | domain1.com | 2023-01 | Active | |

### GTM

| Container Name | Container ID | Type | Domain | Active Since | Status | Notes |
|----------------|-------------|------|--------|-------------|--------|-------|
| {Name} | `GTM-XXXXXXX` | Web | domain1.com | 2023-01 | Active | |
| {Name} | `GTM-XXXXXXX` | Server | domain1.com | 2024-06 | Active | sst.domain1.com |

### Search Console

| Property | Domain | Active Since | Status | Notes |
|----------|--------|-------------|--------|-------|
| `https://domain1.com` | domain1.com | 2023-01 | Active | |

---

## E-commerce → Domain Mapping

| Platform | Store/Instance | Domain | Currency | Active Since | Status | Notes |
|----------|---------------|--------|----------|-------------|--------|-------|
| Shopify | {store}.myshopify.com | domain1.com | USD | 2023-01 | Active | |
| WooCommerce | domain2.hu | domain2.hu | HUF | 2021-06 | Active | |

---

## CRM / Email → Domain Mapping

| Platform | Instance/Account | Domain(s) | Active Since | Status | Notes |
|----------|-----------------|-----------|-------------|--------|-------|
| ActiveCampaign | {url}.api-us1.com | domain1.com | 2023-01 | Active | |
| Klaviyo | | | | | |

---

## Databox → Domain Mapping

> **CRITICAL for automated analysis.** Every Databox data source ID must be mapped to the domain(s) it covers and whether it's shared.

| Databox Source ID | Platform | What it measures | Domain(s) | Shared? | Currency | Typical Lag | Active Since | Status | Filter by |
|-------------------|----------|-----------------|-----------|---------|----------|-------------|-------------|--------|-----------|
| `XXXXXXX` | Google Ads | All campaigns in account | domain1, domain2 | **YES** | {CUR} | ~4h | 2024-01 | Active | `dimension: "campaign"` + name patterns |
| `XXXXXXX` | Shopify | domain1.com orders | domain1.com | No | {CUR} | ~24-48h | 2024-01 | Active | — |
| `XXXXXXX` | Meta Ads | domain1.com campaigns | domain1.com | No | {CUR} | ~6h | 2024-03 | Active | — |

---

## Reporting / BI → Domain Mapping

| Tool | Dashboard/Report | Domain(s) covered | Active Since | Status | Notes |
|------|-----------------|-------------------|-------------|--------|-------|
| Databox | CEO Pulse | All domains (blended) | 2024-01 | Active | |
| Roivenue | | | | | |
| Windsor | | | | | |

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
