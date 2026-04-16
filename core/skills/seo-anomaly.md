---
scope: shared
argument-hint: client slug or URL
---

# Skill: Ranking Anomaly Detection (`/seo-anomaly`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Detect sudden position changes (drops OR gains) and flag them immediately. A position drop from 4 to 14 on a Tuesday should be flagged in hours, not discovered next quarter. Early detection = early response.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct GSC property. Anomalies are per-domain. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC data with daily/weekly granularity. Optimal: GSC + BASELINES.md + CAPTAINS_LOG.md.

## Trigger

Use this skill when:
- Proactive SEO monitoring check (weekly or after known Google updates)
- Client reports "we suddenly lost/gained a keyword"
- `/morning-brief` or `/health-check` flags organic traffic anomaly
- After a site deployment or technical change — check for ranking impact
- Google confirms an algorithm update — check exposure

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| GSC data (daily/weekly) | Yes | Databox MCP (Google Search Console) |
| Detection period | Yes | Default: last 7 days vs prior 30-day rolling average |
| BASELINES.md | Optional | Client `data/seo/BASELINES.md` — tracked query baselines |
| CAPTAINS_LOG.md | Recommended | Client directory — check for known site changes |
| Semrush sensor/visibility | Optional | Semrush MCP — SERP volatility context |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum)
- Daily position data for top queries (last 7 days vs 30-day rolling average)
- Page-level click/impression changes

### Enriched Mode (+ Semrush MCP)
- SERP volatility sensor (is the whole SERP volatile or just our site?)
- Competitor visibility changes (did they gain what we lost?)

### Enriched Mode (+ BASELINES.md)
- Compare against established baseline positions rather than rolling average
- More accurate anomaly detection for sites with volatile historical data

## Execution Steps

1. **Data Sufficiency Check** — Verify GSC daily/weekly data available. Need at least 7 days of current + 30 days of historical for rolling average. If insufficient: use whatever is available but flag reduced confidence.

2. **Establish baselines:**
   - If `data/seo/BASELINES.md` exists: load baseline positions per query
   - If no baselines: calculate 30-day rolling average position per query from GSC data
   - Tag baseline source: `[DATA]` if from BASELINES.md, `[INFERRED]` if calculated

3. **Pull recent position data** — Last 7 days, daily granularity if possible, per query. Tag `[DATA]`.

4. **Detect anomalies** — Flag any query where:

   | Anomaly Type | Detection Rule | Threshold |
   |-------------|---------------|-----------|
   | **Position drop** | Current position > baseline + 5 | 5+ spots worse |
   | **Position gain** | Current position < baseline - 5 | 5+ spots better |
   | **Impression collapse** | Impressions < 50% of 30-day avg | 50%+ drop |
   | **Impression surge** | Impressions > 200% of 30-day avg | 100%+ gain |
   | **CTR anomaly** | CTR deviates > 50% from expected for position | Unusual behavior |

5. **For each anomaly — check scope:**
   - Did other queries on the SAME PAGE also move? → Page-level issue (technical, content change, penalty)
   - Did queries across MULTIPLE pages move? → Site-level issue (algorithm, technical, crawl)
   - Only ONE query on ONE page? → Query-level issue (SERP feature change, competitor, seasonal)

6. **Cross-reference with known events:**
   - Check `CAPTAINS_LOG.md` for site changes (deploys, content updates, redirects) in the affected period
   - Check Google Search Status Dashboard for confirmed algorithm updates
   - If Semrush available: check SERP volatility sensor
   - Tag all cross-references: `[DATA]` (confirmed event), `[OBSERVED]` (we verified), `[INFERRED]` (timing correlation)

7. **Classify each anomaly:**

   | Classification | Criteria | Response |
   |---------------|----------|----------|
   | **SERP volatility** | Many queries fluctuating, SERP sensor high | MONITOR — wait 7 days, re-check |
   | **Algorithm update** | Broad position changes, Google confirmed update | ANALYZE — run `/seo-diagnose` |
   | **Technical issue** | All pages on a subdirectory affected, or new 404s/redirects | FIX — immediate technical investigation |
   | **Competitor displacement** | Our position dropped, competitor position gained (Semrush) | RESPOND — analyze competitor content |
   | **Content change impact** | Anomaly timing matches content edit in CAPTAINS_LOG | EVALUATE — was the edit beneficial or harmful? |
   | **Positive anomaly** | Significant position gain | CAPITALIZE — internal link to the gaining page |

8. **If signals conflict** — Multiple plausible classifications with contradicting evidence → flag for `/council` diagnostic session.

## Output Template

```markdown
# Ranking Anomaly Report — {CLIENT}
v1.0 — {DATE}
Detection period: {start} — {end}
Baseline: {BASELINES.md / 30-day rolling average}

## BLUF
{2-3 sentences: how many anomalies detected, most critical one, immediate action needed}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC (daily) | HIGH/MED/LOW | {issues} |
| BASELINES.md | AVAILABLE / NOT AVAILABLE | |
| CAPTAINS_LOG | CHECKED / NOT CHECKED | |
| Semrush sensor | AVAILABLE / NOT AVAILABLE | |

## Anomaly Summary
| Type | Count | Critical | Needs Action |
|------|-------|----------|-------------|
| Position drops | {N} | {N} | {N} |
| Position gains | {N} | — | {N} (capitalize) |
| Impression collapses | {N} | {N} | {N} |
| Impression surges | {N} | — | {N} |
| CTR anomalies | {N} | {N} | {N} |

## Critical Anomalies (Immediate Attention)
| # | Query | Page | Old Pos → New Pos | Change Date | Scope | Classification | Action |
|---|-------|------|------------------|------------|-------|---------------|--------|
| 1 | | | | | Page/Site/Query | | |

## Positive Anomalies (Capitalize)
| # | Query | Page | Old Pos → New Pos | Potential |
|---|-------|------|------------------|----------|
| 1 | | | | |

## Detailed Analysis (Critical Anomalies)
### Anomaly 1: "{query}" — {page}
- **Position:** {old} → {new} (Δ{change}) `[DATA]`
- **When:** {date or date range of change} `[DATA]`
- **Scope:** {page-level / site-level / query-level} `[DATA]`
- **Other queries on same page:** {moved / stable} `[DATA]`
- **Known events in period:** {from CAPTAINS_LOG or "none found"} `[DATA/INFERRED]`
- **Classification:** {SERP volatility / algorithm / technical / competitor / content change}
- **Confidence:** [HIGH/MED/LOW — {reason}]
- **Recommended action:** {specific next step}

## Cross-Reference: Known Events
| Date | Event | Source | Possibly Related Anomalies |
|------|-------|--------|--------------------------|
| | | CAPTAINS_LOG / Google / Semrush | |

## AMIT NEM TUDUNK (What We Don't Know)
- {GSC daily data can lag 2-3 days — anomalies from the last 48h may not be visible yet}
- {Without Semrush: competitor movements are [UNKNOWN]}
- {Without BASELINES.md: anomaly detection uses rolling average, which can be noisy}
- {SERP feature changes (featured snippets appearing/disappearing) are not visible in GSC position data}

## What Could Invalidate These Findings?
- {GSC position is an average — daily fluctuations are normal}
- {Position change may reverse within days (SERP volatility)}
- {Correlation with site changes ≠ causation}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-anomaly-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **Run weekly minimum.** Best paired with `/morning-brief` or `/health-check` for continuous monitoring.
- **BASELINES.md:** Create one per client after the first run. Store target/expected positions for top 20-50 queries. Update quarterly.
- **Position is an average.** GSC reports average position — a query might show position 7 but actually fluctuate between 3 and 15. Flag high-variance queries separately.
- **Gains are actionable too.** A sudden position gain means Google is testing us in a new position. Capitalize: add internal links, update content, improve CTR to "lock in" the gain.
- **Pairs with:** `/seo-diagnose` (anomaly → full diagnosis), `/seo-decay` (anomaly may be the beginning of decay), `/seo-narrative` (anomalies become the lead story in the report), `/seo-cannibalize` (if a page dropped, check if another internal page took its place)
- **Council escalation:** If anomaly has conflicting signals (e.g., position dropped but impressions grew), escalate to `/council` for multi-agent diagnostic.
