> v1.0 — 2026-04-04

# Data Sufficiency Check — MANDATORY for all analytical skills

> **"Not enough data to state" is a valid — and valuable — conclusion.**
> Silence about what you don't know is more dangerous than silence about what you do know.
> A confident-sounding answer to a question you can't answer is the system's worst failure mode.

---

## When to apply

EVERY skill that produces findings, recommendations, or analysis. Specifically:
- /analyze-alchemy, /analyze-gtm, /plan-gtm
- /sales-pulse, /health-check, /morning-brief
- /7layer, /7layer-hu
- /map-results, /council
- /client-report
- Any freeform data analysis query

## Step 1: Classify data axes

Before ANY analysis, classify each data axis:

| Status | Meaning | Rule |
|---|---|---|
| ✅ **AVAILABLE** | Data is present, verified, and recent | Can make statements with [DATA] tag |
| 🟡 **PARTIAL** | Some data exists but incomplete (e.g., orders without revenue, contacts without campaigns) | Can make limited statements, must flag gaps |
| ❌ **MISSING** | No data for this axis | Cannot make ANY statement about this axis. "UNKNOWN" is the only valid conclusion. |

### Standard data axes for marketing analysis:

| Axis | What's needed | Minimum for analysis |
|---|---|---|
| **Traffic** | Sessions, new users, by channel, by period | REQUIRED — cannot do any analysis without |
| **Conversions** | GA4 conversions AND e-commerce orders (both) | REQUIRED — one alone creates distortion |
| **Revenue** | Transaction revenue, AOV, by source if possible | Strongly recommended — without it, can't assess value |
| **Ad Spend** | Per-platform spend, by campaign | Strongly recommended — ROAS impossible without |
| **Email/CRM** | Campaign sends, opens, clicks, automations, contact count | Recommended — email channel is blind spot without |
| **SEO** | Search Console queries, positions, impressions | Optional — organic analysis limited without |
| **Competitor** | Semrush, similar tools | Optional — market context limited without |
| **Prior period** | Same metrics for comparison period (MoM, QoQ, YoY) | REQUIRED for trend analysis — without it, numbers are meaningless |
| **Baselines** | BASELINES.md per client with rolling averages | Recommended — anomaly detection impossible without |

## Step 2: Determine sufficiency level

| Level | Condition | Action |
|---|---|---|
| **PROCEED** | All REQUIRED axes AVAILABLE, max 2 PARTIAL | Run analysis normally. Flag PARTIAL axes in Data Reliability section. |
| **PROCEED WITH WARNINGS** | All REQUIRED available, but 3+ PARTIAL or MISSING | Run analysis but place DATA SUFFICIENCY WARNING at top of output. Every finding on a PARTIAL/MISSING axis must be tagged [INFERRED] or [UNKNOWN]. |
| **STOP — INSUFFICIENT DATA** | Any REQUIRED axis MISSING | Do NOT produce analysis. Tell the user what's missing and what needs to be connected/fixed before analysis is meaningful. |

## Step 3: Tag every finding

Every finding, recommendation, or conclusion MUST carry a data class tag:

| Tag | Meaning | When to use | Example |
|---|---|---|---|
| `[DATA]` | Directly observed in the numbers | The number is right there | "Sessions dropped 38% [DATA]" |
| `[OBSERVED]` | Verified through manual check (browser, tool) | You saw it yourself | "The GTM tag fires correctly [OBSERVED]" |
| `[CALCULATED]` | Derived from available data through arithmetic | Math on verified inputs | "Conv rate = 0.62% [CALCULATED from DATA]" |
| `[INFERRED]` | Concluded from patterns, but not directly measured | The data suggests but doesn't prove | "PMax likely absorbed Paid Social volume [INFERRED — campaign data missing]" |
| `[STATED]` | Client or stakeholder said it | Someone told you | "Client says budget didn't change [STATED — not verified]" |
| `[UNKNOWN]` | Not enough data to make any statement | The axis is MISSING or PARTIAL | "Email campaign volume: [UNKNOWN — AC data not accessible via MCP]" |

### Rules:

1. **Never upgrade a tag.** [INFERRED] cannot become [DATA] without new data. [STATED] cannot become [DATA] without verification.
2. **Tag inheritance.** A conclusion built on [INFERRED] inputs is itself [INFERRED] at best. A conclusion built on [UNKNOWN] inputs is [UNKNOWN].
3. **One data point is not a pattern.** One month doing X does not mean "X is the trend." Minimum 3 months for a trend claim, minimum 2 years for a seasonality claim.
4. **Absence ≠ zero.** "We don't see email campaigns" ≠ "no email campaigns were sent." It could be a measurement gap.
5. **The gap between platforms IS data.** GA4 shows 262 conversions, Shopify shows 301 orders. The 39-order gap is a finding [DATA], but its CAUSE is [INFERRED] or [UNKNOWN].

## Step 4: State what you DON'T know

Every analysis output MUST include a section:

```
## AMIT NEM TUDUNK (What We Don't Know)

| Kérdés | Miért nem tudjuk | Mi kellene hozzá | Hatás az elemzésre |
|---|---|---|---|
| Mekkora a Google Ads spend? | Databox source nincs bekötve | Új fiók Databox összekötése | ROAS nem kalkulálható |
| Mentek-e emailek márciusban? | AC MCP nem ad kampány adatot | AC dashboard manual check | Email "collapse" = INFERRED, nem DATA |
| Szezonális-e a januári csúcs? | Csak 1 év adata van (2026) | 2024+2025 januári adat | Szezonalitás = INFERRED, nem pattern |
```

**This section is not optional.** An analysis without "What We Don't Know" is an analysis that pretends to know everything. That's more dangerous than no analysis at all.

## Integration with other frameworks

- **Confidence Engine (CONFIDENCE_ENGINE.md):** Data Sufficiency feeds the confidence score. If an axis is MISSING, confidence on any finding touching that axis cannot exceed 0.4.
- **Evidence Classification (EVIDENCE_CLASSIFICATION_RULE.md):** The [DATA]/[INFERRED]/[UNKNOWN] tags here are compatible with and extend the evidence classification system.
- **Discovery Not Pronouncement (DISCOVERY_NOT_PRONOUNCEMENT.md):** "We don't know" IS a discovery. Present it as such.
- **Alarm Calibration (ALARM_CALIBRATION.md):** Cannot flag anomalies on axes where BASELINES don't exist.

---

## The anti-pattern this prevents

> The system pulls 3 metrics from Databox, sees sessions dropped 38%, and produces a 200-line analysis with root causes, competing hypotheses, and 7 action items — all based on SESSION DATA ALONE.
>
> Meanwhile: ad spend is unknown, email data is missing, revenue isn't available, and the "root cause" is [INFERRED] from one data axis.
>
> This is the AI confidence loop applied to marketing analysis.
> A beautiful, well-structured, completely unreliable answer.
>
> The Data Sufficiency Check exists to prevent this.

---

*"Való, hazugság nélkül, biztos és igaz." (Tabula Smaragdina, 1. mondat)*
*Az igazság feltétele: tudom, hogy mit NEM tudok.*
