> v1.2 — 2026-04-07 — added Active Since + Status columns to all mapping tables (v1.3 template standard)

# AquaLux — Domain & Channel Map

> Maps every marketing channel, tool, and data source to the domain it serves.
> **LOAD THIS BEFORE ANY ANALYSIS.** See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.
> **Date columns (MANDATORY):** every mapping has `Active Since` and `Status` — accounts die, campaigns move, sources change. A mapping without dates is a mapping you can't trust.

## Business Units

| Unit | Domains | Market | Currency | Isolation Level | Active Since | Status |
|---|---|---|---|---|---|---|
| **AquaLux US** | aqualux-us.com | US D2C | USD | NEVER blend with EU or Dealers | 2024-01 | Active |
| **AquaLux EU** | aqualux.eu, aqualux.de | EU B2C | EUR | NEVER blend with US | 2024-01 | Active |
| **AquaLux Dealers** | dealers.aqualux.com | US B2B | USD | Different economics — lead gen, not e-commerce | 2024-01 | Active |

### Enforcement Rules
1. **"AquaLux ROAS"** requires specifying US, EU, or Dealers.
2. **Budget recommendations** per unit — different currencies, different models.
3. **Cross-unit comparison** valid IF labeled and currencies normalized.

---

## Domains

| Domain | Market | Platform | Primary Use | Brand | Active Since | Status |
|---|---|---|---|---|---|---|
| **aqualux-us.com** | US | Shopify | D2C e-commerce ($3K-$7K) | AquaLux US | 2024-01 | Active |
| **aqualux.eu** | EU | WooCommerce | B2C e-commerce (€2.5K-€6K) | AquaLux EU | 2024-01 | Active |
| **aqualux.de** | DE | WooCommerce | German market | AquaLux EU (DE) | 2024-01 | Active |
| **dealers.aqualux.com** | US | WordPress | Dealer lead gen | AquaLux Dealers | 2024-01 | Active |
| staging.aqualux-us.com | — | Shopify | Staging | — | — | Staging |

---

## Google Ads → Domain Mapping

| Account | Account ID | Currency | Domains | Shared? | Active Since | Status |
|---|---|---|---|---|---|---|
| AquaLux Main | `AW-EXAMPLE-101` | USD | aqualux-us.com + dealers.aqualux.com | **YES** | 2024-01 | Active |
| AquaLux EU | `AW-EXAMPLE-102` | EUR | aqualux.eu + aqualux.de | **YES** | 2024-01 | Active |

**Campaign → Domain patterns:**

| Pattern | Domain | Type | Active Since | Status |
|---|---|---|---|---|
| `aqualux-us_*` | aqualux-us.com | PMax/Search/Shopping | 2024-01 | Active |
| `dealers_*` | dealers.aqualux.com | Lead gen | 2024-01 | Active |
| `aqualux-eu_*` | aqualux.eu | PMax/Search | 2024-01 | Active |
| `aqualux-de_*` | aqualux.de | PMax/Search | 2024-01 | Active |

---

## Meta Ads → Domain Mapping

| Ad Account | Domains | Currency | Notes | Active Since | Status |
|---|---|---|---|---|---|
| AquaLux US | aqualux-us.com | USD | D2C only | 2024-01 | Active |
| AquaLux EU | aqualux.eu + aqualux.de | EUR | Shared — filter by campaign | 2024-01 | Active |
| AquaLux Dealers | dealers.aqualux.com | USD | Lead gen campaigns | 2024-01 | Active |

---

## Analytics → Domain Mapping

| Platform | Property | Domain | Notes | Active Since | Status |
|---|---|---|---|---|---|
| GA4 | GA4-EXAMPLE-US | aqualux-us.com | USD reporting | 2024-01 | Active |
| GA4 | GA4-EXAMPLE-EU | aqualux.eu + aqualux.de | EUR reporting | 2024-01 | Active |
| GA4 | GA4-EXAMPLE-DEALERS | dealers.aqualux.com | Lead tracking | 2024-01 | Active |

---

## E-commerce → Domain Mapping

| Platform | Store | Domain | Currency | Notes | Active Since | Status |
|---|---|---|---|---|---|---|
| Shopify | aqualux-us.myshopify.com | aqualux-us.com | USD | | 2024-01 | Active |
| WooCommerce | aqualux.eu | aqualux.eu | EUR | Shared with .de | 2024-01 | Active |

---

## CRM → Domain Mapping

| Platform | Instance | Domain(s) | Notes | Active Since | Status |
|---|---|---|---|---|---|
| ActiveCampaign | us.api-us1.com | aqualux-us.com + dealers.aqualux.com | US instance | 2024-01 | Active |
| ActiveCampaign | eu.activehosted.com | aqualux.eu + aqualux.de | EU instance | 2024-01 | Active |

---

## Databox → Domain Mapping

**Account:** ArcanianOS DEMO (`748621`)

| Databox Source ID | Dataset ID | Name | Domain(s) | Currency | Notes | Active Since | Status |
|---|---|---|---|---|---|---|---|
| `4942417` | `83bc6595-ce2b-4c8d-89f5-5770d7900b1c` | GA4 Sessions by Channel | aqualux-us.com | USD | Daily sessions by channel, 60 days | 2026-04 | Active |
| `4942418` | `8f370b35-19af-4e27-83a0-066a0312e28d` | GA4 Conversions | aqualux-us.com | USD | Daily conversions + revenue + AOV | 2026-04 | Active |
| `4942419` | `31adfa69-3f4b-471a-b746-bbe1635d8180` | Shopify Orders | aqualux-us.com | USD | Daily orders + revenue + AOV | 2026-04 | Active |
| `4942420` | `fb6f9f7c-3ff8-4dd1-990b-9db431932f7d` | CRM Contacts | aqualux-us.com | — | New contacts, list growth, unsubscribes | 2026-04 | Active |
| `4942421` | `e7ba2e29-8210-4913-8e8d-51027bcf448b` | CRM Email Campaigns | aqualux-us.com | — | Sends, opens, clicks, bounces | 2026-04 | Active |
| `4942422` | `dfb3c16d-3823-4592-b949-60ce27963a21` | CRM Pipeline | aqualux-us.com | USD | 16 deals by stage + value | 2026-04 | Active |
| `4942423` | `01f567ea-8d5e-44f2-8f60-4c2b45b21a36` | Google Ads Daily | aqualux-us.com | USD | Spend, conversions, value, CPA, ROAS | 2026-04 | Active |
| `4942424` | `52ab550e-8845-4ba3-80d4-9035e6bbf016` | GA4 Ecommerce | aqualux-us.com | USD | Sessions, transactions, revenue, CR | 2026-04 | Active |
| `4942425` | `2a42bc33-ba7c-4544-b47e-cdde0ec55f2d` | Platform Changes | all | — | Change log with dates | 2026-04 | Active |
| `4942426` | `2ba31fa8-1bff-4c5e-97ec-8076be5f1e5d` | Client Health | all (5 clients) | mixed | Multi-client health metrics | 2026-04 | Active |
| `4942427` | `f4732c3a-1b32-4b92-b836-4007ac04664c` | Weekend Anomaly | Summit Fitness | — | Anomaly detail with baselines | 2026-04 | Active |

**How to query:** Use `ask_genie` with the dataset ID. Example:
```
ask_genie(dataset_id="dfb3c16d-3823-4592-b949-60ce27963a21", question="Show pipeline value by stage")
```
