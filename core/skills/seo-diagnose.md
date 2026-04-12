---
scope: shared
---

# Skill: SEO Traffic Drop Diagnostics (`/seo-diagnose`)

## Architecture

> v2.0 — 2026-04-12 — Refactored to agent-council architecture.

This skill uses the **seo-diagnostic council** (`core/agents/councils/seo-diagnostic.yaml`):

| Agent | What it tests | Hypothesis |
|---|---|---|
| `seo-traffic-analyzer` | GSC/GA4 data baseline | H1 (algorithm), H5 (seasonal) |
| `seo-decay-detector` | Content age + position bleed | H2 (content decay) |
| `seo-cannibalization-detector` | Multi-page query conflicts | H6 (cannibalization) |
| `seo-technical-checker` | Indexation, robots, schema, meta | H3 (technical) |
| `seo-competitor-analyzer` | Competitor visibility + SERP changes | H4 (competitor gain) |
| `seo-diagnosis-synthesizer` | ACH synthesis (chairman) | All 6 hypotheses |

Pipeline: data collection → 4 agents parallel → ACH synthesis
Scoring: `core/methodology/SEO_DIAGNOSTIC_SCORING.md` (ACH, not weighted average)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

When organic traffic drops, diagnose WHY in 30 seconds. Cross-reference GSC (impressions, clicks, position changes) with GA4 (sessions by channel, landing pages) to identify the root cause before panic sets in.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct GSC property and GA4 property for the domain in question. Never mix domain data. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC data for both periods. Optimal: GSC + GA4 + Semrush.

## Trigger

Use this skill when:
- Organic traffic has dropped and the client asks "why?"
- Weekly/monthly SEO check reveals a decline
- Client reports "we lost rankings" or "traffic is down"
- Proactive monitoring flags an organic session decline > 10%

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Comparison periods | Yes | User specifies or default: last 28d vs prior 28d |
| GSC data | Yes | Databox MCP (Google Search Console data source) |
| GA4 organic sessions | Recommended | Databox MCP (GA4 data source) |
| Semrush domain overview | Optional | Semrush MCP (`https://mcp.semrush.com/v1/mcp`) |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum)
Pull from Databox MCP using the client's Google Search Console data source:
- Total clicks, impressions, CTR, avg position — current vs prior period
- Top queries by click change (biggest losers)
- Top pages by click change (biggest losers)

### Enriched Mode (+ Semrush MCP)
Additionally pull from Semrush MCP:
- Domain overview: visibility trend, estimated traffic
- Keyword position changes: which keywords moved and by how much
- Competitor visibility comparison: did competitors gain what we lost?

## Execution Steps

1. **Data Sufficiency Check** — Verify GSC data available for both periods. Log gaps as `[UNKNOWN]`. If no GSC: STOP, explain what data is needed.

2. **Pull GSC totals** — Current vs prior period: clicks, impressions, CTR, avg position. Tag all numbers `[DATA]`.

3. **Pull affected queries** — Top 20 queries by click decline. For each: impressions change, click change, CTR change, position change. Tag `[DATA]`.

4. **Pull affected pages** — Top 10 pages by click decline. For each: total clicks lost, primary query lost. Tag `[DATA]`.

5. **Pull GA4 organic sessions** (if available) — Confirm the organic decline matches GSC. If GA4 shows different magnitude than GSC, flag the discrepancy.

6. **Generate Competing Hypotheses (ACH)**

   Mandatory hypothesis set (test ALL):
   | Hypothesis | Evidence FOR | Evidence AGAINST |
   |------------|-------------|-----------------|
   | Algorithm update | Position changes across many queries | Only 1-2 queries affected |
   | Content decay | Gradual position loss over months | Sudden drop |
   | Technical issue | All pages affected equally | Only specific pages |
   | Competitor gain | Competitor visibility up (Semrush) | `[UNKNOWN]` without Semrush |
   | Seasonal decline | Same pattern prior year | No prior year data |
   | Cannibalization | Multiple pages ranking for same query | Clean 1:1 query-page mapping |

7. **Score each hypothesis** — CC (Clearly Consistent), C (Consistent), N (Neutral), I (Inconsistent) against each evidence item. Rank by consistency.

8. **Generate action items** — For each plausible hypothesis, one concrete next step with owner.

## Output Template

```markdown
# SEO Traffic Drop Diagnosis — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: what happened, most likely cause, confidence level, what would invalidate it}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC | HIGH/MED/LOW | {issues} |
| GA4 | HIGH/MED/LOW | {issues} |
| Semrush | HIGH/MED/LOW / NOT AVAILABLE | {issues} |

## Traffic Change Summary
| Metric | Prior Period | Current Period | Change | Change % |
|--------|-------------|---------------|--------|----------|
| Clicks | | | | |
| Impressions | | | | |
| CTR | | | | |
| Avg Position | | | | |

## Affected Queries (Top Losers)
| Query | Clicks Δ | Impressions Δ | Position Δ | Evidence Tag |
|-------|----------|--------------|-----------|-------------|
| | | | | [DATA] |

## Affected Pages (Top Losers)
| Page | Clicks Lost | Primary Query Lost | Decay Type |
|------|------------|-------------------|-----------|
| | | | |

## ACH: Competing Hypotheses
| Hypothesis | {Evidence 1} | {Evidence 2} | {Evidence 3} | Score |
|------------|-------------|-------------|-------------|-------|
| Algorithm update | CC/C/N/I | | | |
| Content decay | | | | |
| Technical issue | | | | |
| Competitor gain | | | | |
| Seasonal | | | | |
| Cannibalization | | | | |

**Most likely:** {hypothesis} [Confidence: HIGH/MED/LOW — {reason}]

## AMIT NEM TUDUNK (What We Don't Know)
- {List all [UNKNOWN] items and [INFERRED] assumptions}
- {What data would change the diagnosis?}
- {What verification is needed?}

## Recommended Actions (OODA — Act)
| # | Action | Owner | Priority | Depends On |
|---|--------|-------|----------|-----------|
| 1 | | | | |

## What Could Invalidate These Findings?
- {List 2-3 scenarios}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-diagnose-{YYYY-MM-DD}.md`
Open in Typora: `open -a Typora "{path}"`

## Notes

- **GSC-only is valid.** The skill works without Semrush — just mark competitor hypotheses as `[UNKNOWN]`.
- **Pairs with:** `/seo-decay` (find which content is bleeding), `/seo-cannibalize` (check if internal competition caused the drop), `/seo-anomaly` (real-time alerting), `/seo-narrative` (write the report after diagnosis)
- **Databox query tips:** Use `dimension: "query"` for query-level GSC data, `dimension: "page"` for page-level. Always filter by the correct GSC property from DOMAIN_CHANNEL_MAP.md.
- **Do NOT conclude "algorithm update" without evidence.** Check Google Search Status Dashboard and SEO news. An algorithm update is a hypothesis, not a default explanation.
