# Skill: GSC Report Narratives (`/seo-narrative`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Turn raw GSC impressions and clicks into the executive summary paragraph that goes at the top of the report. The one nobody wants to write. Makes numbers meaningful by connecting them to business outcomes.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Write separate narratives per domain or clearly attribute numbers. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every number in the narrative MUST be `[DATA]`. Interpretations and causal claims are `[INFERRED]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`.

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC totals for two periods. Optimal: GSC + GA4 + prior report for continuity.

> **Tone:** Before writing, load client tone from `PROJECT_GLOSSARY.md` or `brand/VOICE.md`. Match the client's communication style and language.

## Trigger

Use this skill when:
- Monthly SEO report needs an executive summary
- Client asks "how did our SEO do this month?"
- Preparing a client-facing report with GSC data
- `/seo-diagnose`, `/seo-decay`, or `/seo-gaps` produced findings that need a client-readable narrative

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Report period | Yes | User specifies or default: last calendar month |
| GSC totals | Yes | Databox MCP (Google Search Console) |
| GSC top queries | Yes | Databox MCP — gainers and losers |
| GSC top pages | Yes | Databox MCP — gainers and losers |
| GA4 organic sessions | Recommended | Databox MCP (GA4) — confirms GSC story |
| Client language | Yes | PROJECT_GLOSSARY.md or user — HU or EN |
| Prior report | Recommended | Previous `seo-narrative-*.md` for continuity |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum)
- Totals: clicks, impressions, CTR, avg position — current vs prior period
- Top 10 queries by click gain + top 10 by click loss
- Top 5 pages by click gain + top 5 by click loss

### Enriched Mode (+ GA4 via Databox)
- Organic sessions from GA4 to cross-validate GSC clicks
- Bounce rate / engagement rate for top gaining/losing pages

### Enriched Mode (+ Semrush MCP)
- Visibility index trend for a broader picture
- Competitor visibility comparison for context

## Execution Steps

1. **Data Sufficiency Check** — Minimum: GSC totals for both periods. If missing: STOP.

2. **Load tone and language** — Check `PROJECT_GLOSSARY.md` and `brand/VOICE.md`. Determine: Hungarian or English? Formal or informal? Technical or plain?

3. **Pull GSC totals** — Current vs prior period. Calculate absolute and percentage changes. Tag all `[DATA]`.

4. **Pull top movers:**
   - Top 10 queries gaining clicks
   - Top 10 queries losing clicks
   - Top 5 pages gaining clicks
   - Top 5 pages losing clicks
   Tag all `[DATA]`.

5. **Identify the story** — What's the ONE thing that happened this month?
   - If overall up: what drove the growth? Specific queries? New pages indexing?
   - If overall down: what caused the decline? Lost positions? Seasonal? Technical?
   - If flat: is "flat" good (maintained) or bad (stagnant)?

6. **Write the narrative (3-5 paragraphs):**
   - **Paragraph 1 (BLUF):** One-sentence verdict. "Organic traffic grew 12% month-over-month, driven primarily by improved positions for product category pages."
   - **Paragraph 2 (What improved):** Specific queries and pages that gained, with numbers that mean something. Not "impressions increased" but "impressions for 'hot tub maintenance' grew 45%, now reaching 2,400 potential searchers monthly."
   - **Paragraph 3 (What declined):** Honest about losses. Specific queries and pages.
   - **Paragraph 4 (Context):** Why this matters for the business. Connect SEO metrics to outcomes.
   - **Paragraph 5 (What to do next):** 2-3 concrete recommendations based on the data.

7. **If Hungarian:** Write in natural Hungarian. Not translated-from-English Hungarian. Use the client's terminology from PROJECT_GLOSSARY.md.

## Output Template

```markdown
# SEO Report Narrative — {CLIENT}
v1.0 — {DATE}
Period: {start} — {end} vs {prior start} — {prior end}

---

## Executive Summary

{3-5 paragraphs of narrative — see Step 6}

---

## Data Table
| Metric | Prior Period | Current Period | Change | Change % |
|--------|-------------|---------------|--------|----------|
| Clicks | | | | |
| Impressions | | | | |
| CTR | | | | |
| Avg Position | | | | |

### Top Gaining Queries
| Query | Clicks Δ | Position Δ | Impressions Δ |
|-------|----------|-----------|--------------|
| | | | |

### Top Losing Queries
| Query | Clicks Δ | Position Δ | Impressions Δ |
|-------|----------|-----------|--------------|
| | | | |

### Top Gaining Pages
| Page | Clicks Δ | Primary Query |
|------|----------|--------------|
| | | |

### Top Losing Pages
| Page | Clicks Δ | Primary Query Lost |
|------|----------|--------------------|
| | | |

## What to Do Next
1. {Specific action with expected impact}
2. {Specific action with expected impact}
3. {Specific action with expected impact}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC | HIGH/MED/LOW | |
| GA4 | HIGH/MED/LOW / NOT USED | |

## AMIT NEM TUDUNK (What We Don't Know)
- {Causal claims are [INFERRED] — correlation is not causation}
- {GSC data is sampled for large sites}
- {Click data does not include all search appearances (e.g., Discover, News)}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-narrative-{YYYY-MM-DD}.md`
Open in Typora: `open -a Typora "{path}"`

## Notes

- **Language matters.** "Impressions grew 14%" means nothing to most clients. "14% more people saw us in search results" means something. Write for the reader, not for SEOs.
- **Connect to business.** "Our product page moved from position 12 to position 6 — this is the difference between invisible and visible, because fewer than 1% of searchers click past page 1."
- **Prior reports:** If a previous `seo-narrative-*.md` exists, reference it for continuity. "Last month we flagged the declining position for 'medence' — this month it recovered to position 4."
- **Pairs with:** `/seo-diagnose` (diagnosis findings feed the narrative), `/seo-decay` (decay alerts add urgency), `/seo-gaps` (opportunities go in "What to do next"), `/seo-anomaly` (anomalies become the lead story)
- **This is a deliverable.** It follows the auto-save deliverable rules: check tone, check glossary, save, open in Typora.
