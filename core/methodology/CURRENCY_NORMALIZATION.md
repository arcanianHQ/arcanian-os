> v1.1 — 2026-04-22 — Added §Per-Skill Application with the tagging contract inherited by /nexus-answer and sibling skills

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
| Google Ads (HU) | solarnook.com | HUF |
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

- **Single-domain analysis:** If analyzing only solarnook.com, keep HUF. No conversion needed.
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
- solarnook.com: €12,400 (converted from 5,084,000 HUF at 1 EUR = 410 HUF, ECB 2026-04-01)
- examplebrand.eu: €18,300 (native EUR)
- example-d2c.com: €16,500 (converted from $17,800 USD at 1 EUR = 1.08 USD, ECB 2026-04-01)
```

## Connection to DOMAIN_CHANNEL_MAP

The `currency` column already exists in some client maps (e.g., ExampleRetail: HUF, EUR, RON). Ensure ALL data sources have a currency value. Missing currency = cannot include in cross-domain calculations.

## Per-Skill Application

Skills rendering monetary values MUST:
1. Resolve `reporting_currency` at session start (priority: `CLIENT_CONFIG.md` → `DOMAIN_CHANNEL_MAP.md` → `.nexus-config.md` → DEMO virtual client → `unknown`).
2. Tag every monetary metric line with `(CUR)` in the output (e.g., `Revenue (HUF):`). Dimensionless ratios (ROAS, Conv Rate) and counts (Sessions, Transactions) do NOT need currency tags but ROAS comparisons across currencies require explicit conversion disclosure.
3. If `reporting_currency` cannot be resolved: render `(?)` on monetary rows, prepend a ⚠ *Currency UNKNOWN* warning, and drop monetary-row confidence to MEDIUM max (never HIGH without a known unit).
4. Never guess or infer currency from the magnitude of numbers or the client's country — same hard prohibition as other inference rules.

Canonical implementation: `core/skills/nexus-answer.md §Prerequisites §1b` (Resolve reporting currency) + §Output templates §Block 1 rules. Other data-rendering skills (/client-report, /morning-brief, /health-check) inherit the same contract.

## References
- `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`
- `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`
- `core/skills/nexus-answer.md` — canonical per-skill implementation
- Per-client `DOMAIN_CHANNEL_MAP.md`
- Per-client `CLIENT_CONFIG.md`
