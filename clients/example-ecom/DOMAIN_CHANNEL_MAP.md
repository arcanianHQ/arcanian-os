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

**Account:** ArcanianOS DEMO (`748621`)

| Databox Source ID | Dataset ID | Name | Domain(s) | Currency | Notes |
|---|---|---|---|---|---|
| `4942417` | `83bc6595-ce2b-4c8d-89f5-5770d7900b1c` | GA4 Sessions by Channel | aqualux-us.com | USD | Daily sessions by channel, 60 days |
| `4942418` | `8f370b35-19af-4e27-83a0-066a0312e28d` | GA4 Conversions | aqualux-us.com | USD | Daily conversions + revenue + AOV |
| `4942419` | `31adfa69-3f4b-471a-b746-bbe1635d8180` | Shopify Orders | aqualux-us.com | USD | Daily orders + revenue + AOV |
| `4942420` | `fb6f9f7c-3ff8-4dd1-990b-9db431932f7d` | CRM Contacts | aqualux-us.com | — | New contacts, list growth, unsubscribes |
| `4942421` | `e7ba2e29-8210-4913-8e8d-51027bcf448b` | CRM Email Campaigns | aqualux-us.com | — | Sends, opens, clicks, bounces |
| `4942422` | `dfb3c16d-3823-4592-b949-60ce27963a21` | CRM Pipeline | aqualux-us.com | USD | 16 deals by stage + value |
| `4942423` | `01f567ea-8d5e-44f2-8f60-4c2b45b21a36` | Google Ads Daily | aqualux-us.com | USD | Spend, conversions, value, CPA, ROAS |
| `4942424` | `52ab550e-8845-4ba3-80d4-9035e6bbf016` | GA4 Ecommerce | aqualux-us.com | USD | Sessions, transactions, revenue, CR |
| `4942425` | `2a42bc33-ba7c-4544-b47e-cdde0ec55f2d` | Platform Changes | all | — | Change log with dates |
| `4942426` | `2ba31fa8-1bff-4c5e-97ec-8076be5f1e5d` | Client Health | all (5 clients) | mixed | Multi-client health metrics |
| `4942427` | `f4732c3a-1b32-4b92-b836-4007ac04664c` | Weekend Anomaly | Summit Fitness | — | Anomaly detail with baselines |

**How to query:** Use `ask_genie` with the dataset ID. Example:
```
ask_genie(dataset_id="dfb3c16d-3823-4592-b949-60ce27963a21", question="Show pipeline value by stage")
```
