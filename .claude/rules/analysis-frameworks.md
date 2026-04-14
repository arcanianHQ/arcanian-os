---
paths:
  - "clients/*/docs/*"
  - "clients/*/data/*"
  - "clients/*/audit/*"
  - "internal/analyses/*"
  - "clients/*/reports/*"
---

# Analysis Frameworks (path-scoped)

## Data Analysis Output Standard (ALWAYS-ON for analysis files)
**Every data analysis — whether from a skill or a freeform question — MUST use the analytical frameworks.**
This is not optional. A table of numbers is not analysis.

**Minimum output for any data query:**
1. **BLUF** (2-3 sentences) — conclusion first, confidence level, what would invalidate it
2. **Data table** — the numbers, with domain attribution for multi-domain clients
3. **OODA** — Observe (facts), Orient (interpretation + competing explanations), Decide (recommendation), Act (tasks with owner + due)
4. **Data Reliability** — source confidence table + "What Could Invalidate These Findings?"

**When data shows anomalies or declines (>15% change):**
5. **ACH** (Analysis of Competing Hypotheses) — generate 3-6 hypotheses, score each against evidence (CC/C/N/I), rank by consistency
6. **Pull additional diagnostic metrics** to test/falsify each hypothesis before concluding

**When to scale down:** Simple status checks ("what's our current spend?") can use BLUF + data table only. But any question involving WHY, comparison, or threshold triggers requires the full framework.

Template: `core/templates/BLUF_OODA_TEMPLATE.md`

## Event Timeline Pre-Load (MANDATORY — HARD BLOCK)
**Before ANY data analysis, load `EVENT_LOG.md` for the client.**
- Step 0b (after DOMAIN_CHANNEL_MAP): Read `clients/{slug}/EVENT_LOG.md`
- Identify which events fall within the analysis period
- Flag date ranges where events explain expected data shifts (e.g., "sessions dropped because budget was cut on Jan 26")
- If EVENT_LOG.md doesn't exist → WARN, proceed, create task to populate it
- **After analysis:** append any newly discovered dated inflection points back to EVENT_LOG.md
- Source tag every event: `[DATA: Databox]`, `[STATED: client]`, `[OBSERVED: GA4]`, `[INFERRED]`
- `[INFERRED]` events MUST get a verification task — they are NOT confirmed facts
- Rule: `core/methodology/EVENT_LOG_RULE.md`

## Multi-Domain & Business Unit Isolation (MANDATORY)
**Before ANY query on a multi-domain client — Databox, ActiveCampaign MCP, GA4, or any tool — load `DOMAIN_CHANNEL_MAP.md` and answer "which domain?" AND "which business unit?" FIRST.**
- **Business units ≠ domains.** Multiple domains may be one unit. Different units = different P&L, market, currency, economics. NEVER blend across units.
- **"Client ROAS"** is meaningless for multi-unit clients — always specify which business unit.
- **The domain question comes before the data question.**
- Shared ad accounts contaminate results if queried at account level — ALWAYS filter by campaign name patterns
- ActiveCampaign: identify which instance before ANY query
- GA4: select the correct property ID for the domain
- Never present account-level totals as domain-level metrics
- **Domain Isolation (v2.0):** non-target domain data must be EXCLUDED — not flagged and kept. "Flagging ≠ isolating."
- Rule: `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`
- Per-client file: `clients/{slug}/DOMAIN_CHANNEL_MAP.md`

## Temporal Awareness (MANDATORY)
**Every analysis must identify the EXACT dates, check for holidays/seasonality, and distinguish anomalies from calendar effects.**
- Always state exact period (not "last 90 days" but "Jan 6 – Apr 6, 2026")
- Check: is this a holiday week? School break? Black Friday? Season change?
- A 40% drop during Easter is not an anomaly — it's the calendar
- Never compare periods without checking seasonal context
- **Temporal mapping:** verify that DOMAIN_CHANNEL_MAP and CONTACTS were valid for the analyzed period
- Rule: `core/methodology/TEMPORAL_AWARENESS_RULE.md`

## Data Sufficiency Check (MANDATORY)
**Before ANY analysis: classify data axes as AVAILABLE / PARTIAL / MISSING.**
- If a REQUIRED axis is MISSING → STOP, don't analyze
- If 3+ axes PARTIAL/MISSING → proceed with DATA SUFFICIENCY WARNING at top
- Every finding tagged: `[DATA]`, `[INFERRED]`, or `[UNKNOWN]` — never upgrade a tag
- "AMIT NEM TUDUNK" (What We Don't Know) section is MANDATORY
- One data point ≠ pattern. Absence ≠ zero. Platform gap IS data, its cause is INFERRED.
- Rule: `core/methodology/DATA_SUFFICIENCY_CHECK.md`

## Attribution Window Awareness (MANDATORY for cross-platform)
**Google Ads "conversions" and Meta "conversions" are different numbers measuring different things.**
- Google: 30d click. Meta: 7d click. GA4: data-driven. Shopify: session-based.
- Never sum platform conversions. Use GA4 as cross-platform arbitrator.
- Flag window mismatches in every cross-platform comparison.
- Rule: `core/methodology/ATTRIBUTION_WINDOWS.md`

## Currency Normalization (MANDATORY for multi-market)
**Never sum HUF and EUR. Never compare USD ROAS to HUF ROAS without conversion.**
- Each client has a `reporting_currency` in CLIENT_CONFIG.md
- DOMAIN_CHANNEL_MAP.md has `currency` per data source
- Rule: `core/methodology/CURRENCY_NORMALIZATION.md`

## Alarm Calibration (Anomaly Detection)
**Not every metric drop is a crisis. Calibrate per client.**
- `alarm_sensitivity` in CLIENT_CONFIG.md: `low` (2x std dev), `normal` (1.5x), `high` (1.0x)
- Requires `data/BASELINES.md` per client
- Check sync lag from DOMAIN_CHANNEL_MAP before flagging
- Rule: `core/methodology/ALARM_CALIBRATION.md`
