> v1.0 — 2026-04-03

# System Rule: Currency Normalization

> **SYSTEM-WIDE RULE** — applies to ALL cross-domain or cross-market analysis.
> "Never sum HUF and EUR. Never compare USD ROAS to HUF ROAS without conversion."

---

## The Problem

Multi-market clients operate in multiple currencies. ExampleBrand: HUF (Hungary), EUR (EU markets), USD (ExampleD2C US). Google Ads bills in one currency, Shopify reports in another, Databox aggregates both. Summing raw numbers across currencies produces nonsense.

## The Rule

**Before ANY cross-domain or cross-market calculation that involves monetary values:**
1. Identify the currency of each data source
2. Convert to the client's **reporting currency** before summing or comparing
3. State the conversion rate and source used
4. Flag if conversion rates are stale (> 7 days)

## Client Reporting Currency

Defined in `CLIENT_CONFIG.md` per client:

```markdown
## Reporting
reporting_currency: EUR
```

If not set: default to the currency of the client's largest market by revenue.

## Currency by Source

Each data source's native currency is documented in `DOMAIN_CHANNEL_MAP.md` in the `currency` column:

```markdown
| Source | Domain | Currency |
|---|---|---|
| Google Ads (HU) | example-ecom.com | HUF |
| Google Ads (EU) | examplebrand.eu | EUR |
| Shopify (ExampleD2C) | example-d2c.com | USD |
| Meta (US) | example-d2c.com | USD |
| ActiveCampaign (EU) | examplebrand.eu | EUR |
```

## Conversion Source

| Priority | Source | How | Staleness limit |
|---|---|---|---|
| 1 | Databox calculated metrics | If Databox already normalizes — use it | Real-time |
| 2 | Platform-reported conversions | Google Ads and Meta convert at transaction time | Real-time |
| 3 | ECB daily reference rates | `https://www.ecb.europa.eu/stats/eurofxref/` | 7 days |
| 4 | Manual rate in CLIENT_CONFIG | Last resort — state date | 30 days max |

## When NOT to Convert

- **Single-domain analysis:** If analyzing only example-ecom.com, keep HUF. No conversion needed.
- **Platform-internal ROAS:** Google Ads ROAS for a single-currency campaign is already internally consistent. Don't convert and reconvert.
- **When the client thinks in local currency:** Present both. "Campaign ROAS: 8.2x (in HUF) / 7.9x (in EUR at today's rate)"

## When to ALWAYS Convert

- **Cross-domain totals:** "Total ad spend across all markets" — must be in reporting currency
- **Cross-market comparison:** "Hungary ROAS vs US ROAS" — must be in same currency
- **Client reports:** Final numbers in reporting currency, with local currency in parentheses
- **Budget allocation decisions:** "Move €5K from HU to US" — must compare in same unit

## Output Format

```markdown
Total ad spend: €47,200 (reporting currency: EUR)
- example-ecom.com: €12,400 (converted from 5,084,000 HUF at 1 EUR = 410 HUF, ECB 2026-04-01)
- examplebrand.eu: €18,300 (native EUR)
- example-d2c.com: €16,500 (converted from $17,800 USD at 1 EUR = 1.08 USD, ECB 2026-04-01)
```

## Connection to DOMAIN_CHANNEL_MAP

The `currency` column already exists in some client maps (e.g., ExampleRetail: HUF, EUR, RON). Ensure ALL data sources have a currency value. Missing currency = cannot include in cross-domain calculations.

## References
- `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`
- `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`
- Per-client `DOMAIN_CHANNEL_MAP.md`
- Per-client `CLIENT_CONFIG.md`
