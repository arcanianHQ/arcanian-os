> v1.0 — 2026-04-03

# AquaLux — Domain & Channel Map

> Maps every marketing channel, tool, and data source to the domain it serves.
> **LOAD THIS BEFORE ANY ANALYSIS.** See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

## Business Units

| Unit | Domains | Market | Currency | Isolation Level |
|---|---|---|---|---|
| **AquaLux US** | aqualux-us.com | US D2C | USD | NEVER blend with EU or Dealers |
| **AquaLux EU** | aqualux.eu, aqualux.de | EU B2C | EUR | NEVER blend with US |
| **AquaLux Dealers** | dealers.aqualux.com | US B2B | USD | Different economics — lead gen, not e-commerce |

### Enforcement Rules
1. **"AquaLux ROAS"** requires specifying US, EU, or Dealers.
2. **Budget recommendations** per unit — different currencies, different models.
3. **Cross-unit comparison** valid IF labeled and currencies normalized.

---

## Domains

| Domain | Market | Platform | Primary Use | Brand |
|---|---|---|---|---|
| **aqualux-us.com** | US | Shopify | D2C e-commerce ($3K-$7K) | AquaLux US |
| **aqualux.eu** | EU | WooCommerce | B2C e-commerce (€2.5K-€6K) | AquaLux EU |
| **aqualux.de** | DE | WooCommerce | German market | AquaLux EU (DE) |
| **dealers.aqualux.com** | US | WordPress | Dealer lead gen | AquaLux Dealers |
| staging.aqualux-us.com | — | Shopify | Staging | — |

---

## Google Ads → Domain Mapping

| Account | Account ID | Currency | Domains | Shared? |
|---|---|---|---|---|
| AquaLux Main | `AW-EXAMPLE-101` | USD | aqualux-us.com + dealers.aqualux.com | **YES** |
| AquaLux EU | `AW-EXAMPLE-102` | EUR | aqualux.eu + aqualux.de | **YES** |

**Campaign → Domain patterns:**

| Pattern | Domain | Type |
|---|---|---|
| `aqualux-us_*` | aqualux-us.com | PMax/Search/Shopping |
| `dealers_*` | dealers.aqualux.com | Lead gen |
| `aqualux-eu_*` | aqualux.eu | PMax/Search |
| `aqualux-de_*` | aqualux.de | PMax/Search |

---

## Meta Ads → Domain Mapping

| Ad Account | Domains | Currency | Notes |
|---|---|---|---|
| AquaLux US | aqualux-us.com | USD | D2C only |
| AquaLux EU | aqualux.eu + aqualux.de | EUR | Shared — filter by campaign |
| AquaLux Dealers | dealers.aqualux.com | USD | Lead gen campaigns |

---

## Analytics → Domain Mapping

| Platform | Property | Domain | Notes |
|---|---|---|---|
| GA4 | GA4-EXAMPLE-US | aqualux-us.com | USD reporting |
| GA4 | GA4-EXAMPLE-EU | aqualux.eu + aqualux.de | EUR reporting |
| GA4 | GA4-EXAMPLE-DEALERS | dealers.aqualux.com | Lead tracking |

---

## E-commerce → Domain Mapping

| Platform | Store | Domain | Currency | Notes |
|---|---|---|---|---|
| Shopify | aqualux-us.myshopify.com | aqualux-us.com | USD | |
| WooCommerce | aqualux.eu | aqualux.eu | EUR | Shared with .de |

---

## CRM → Domain Mapping

| Platform | Instance | Domain(s) | Notes |
|---|---|---|---|
| ActiveCampaign | us.api-us1.com | aqualux-us.com + dealers.aqualux.com | US instance |
| ActiveCampaign | eu.activehosted.com | aqualux.eu + aqualux.de | EU instance |

---

## Databox → Domain Mapping

| Databox Source ID | Platform | Domain(s) | Shared? | Currency | Typical Lag | Filter by |
|---|---|---|---|---|---|---|
| `EXAMPLE-001` | GA4 | aqualux-us.com | No | USD | ~4h | — |
| `EXAMPLE-002` | Google Ads | aqualux-us.com + dealers | **YES** | USD | ~4h | `dimension: "campaign"` |
| `EXAMPLE-003` | Shopify | aqualux-us.com | No | USD | ~24-48h | — |
| `EXAMPLE-004` | Meta (US) | aqualux-us.com | No | USD | ~6h | — |
| `EXAMPLE-005` | GA4 | aqualux.eu + .de | **YES** | EUR | ~4h | — |
| `EXAMPLE-006` | Google Ads (EU) | aqualux.eu + .de | **YES** | EUR | ~4h | `dimension: "campaign"` |
