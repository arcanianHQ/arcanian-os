# Skill: Cannibalization Cleanup (`/seo-cannibalize`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Find pages competing for the same keyword. When two pages fight for the same query, neither wins. Show which to keep, merge, or redirect — with data, not guesses.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct GSC property. Cannibalization is per-domain — never mix. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC data with query+page dimensions. Optimal: GSC + Semrush.

## Trigger

Use this skill when:
- Multiple pages rank for the same keyword and none rank well
- `/seo-diagnose` identified cannibalization as a hypothesis
- Client says "we have too many pages about the same topic"
- Content audit reveals overlapping topics
- Position fluctuations suggest Google can't pick a canonical page

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| GSC data (query+page) | Yes | Databox MCP (Google Search Console) |
| Time period | Yes | Default: last 90 days |
| Semrush keyword data | Optional | Semrush MCP — adds search volume + difficulty |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum)
- All queries where 2+ pages received impressions
- Per page per query: clicks, impressions, CTR, avg position

### Enriched Mode (+ Semrush MCP)
- Keyword difficulty and search volume for cannibalizing queries
- Enables traffic value estimation (volume x CPC)

## Execution Steps

1. **Data Sufficiency Check** — Verify GSC query+page data available. Minimum 28 days, ideally 90 days. Log gaps as `[UNKNOWN]`.
> **Temporal Awareness applies.** Identify exact dates, check holidays/seasonality before flagging anomalies. See `core/methodology/TEMPORAL_AWARENESS_RULE.md`.

2. **Identify cannibalizing pairs** — Pull all queries where 2+ distinct pages received impressions in GSC. Tag `[DATA]`.

3. **Score each pair** — For each query with multiple pages:
   - Which page has better avg position? → Candidate winner
   - Which page has more clicks? → Confirms or contradicts position winner
   - Is CTR split (both pages getting some clicks)? → Active cannibalization
   - Is one page getting impressions but zero clicks? → Passive cannibalization

4. **Classify the recommended action per pair:**

   | Pattern | Action |
   |---------|--------|
   | Clear winner (1 page dominates position + clicks) | **KEEP** winner, **REDIRECT** loser (301) |
   | Both pages have unique value | **MERGE** content into stronger page, redirect the other |
   | Neither page ranks well (both > position 15) | **CONSOLIDATE** into one new comprehensive page |
   | Pages serve different intents (info vs transactional) | **DIFFERENTIATE** — adjust titles/content to target different queries |
   | Temporary fluctuation (pages alternating) | **MONITOR** — check again in 30 days |

5. **Prioritize by impact** — Score = estimated search volume x position gap between pages. If Semrush available, use actual volume. If not, use GSC impressions as proxy. Tag volume source.

6. **Build implementation plan** — Group by action type (redirects, merges, consolidations). Order by impact score.

## Output Template

```markdown
# Cannibalization Report — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: how many cannibalizing pairs found, estimated traffic impact, top priority action}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC (query+page) | HIGH/MED/LOW | {issues} |
| Semrush | HIGH/MED/LOW / NOT AVAILABLE | {issues} |
| Volume estimates | {proxy or actual} | {if proxy: based on impressions, not search volume} |

## Cannibalization Summary
- **Total cannibalizing queries:** {N}
- **Total affected pages:** {N}
- **Estimated monthly clicks at risk:** {N} [DATA] / [INFERRED]

## Cannibalizing Pairs (by priority)
| # | Query | Page A | Page B | Winner | Position A → B | Action | Impact Score |
|---|-------|--------|--------|--------|----------------|--------|-------------|
| 1 | | | | | | REDIRECT/MERGE/CONSOLIDATE/DIFFERENTIATE/MONITOR | |

## Detailed Analysis (Top 10 pairs)
### Pair 1: "{query}"
- **Page A:** {URL} — Pos: {X}, Clicks: {N}, CTR: {X}% `[DATA]`
- **Page B:** {URL} — Pos: {X}, Clicks: {N}, CTR: {X}% `[DATA]`
- **Diagnosis:** {why this is cannibalization, not healthy multiple rankings}
- **Recommendation:** {action + rationale} [Confidence: HIGH/MED/LOW]

## Implementation Plan
### Phase 1: Redirects (Quick Wins)
| Loser URL | Winner URL | Query | Expected Click Gain |
|-----------|-----------|-------|-------------------|

### Phase 2: Content Merges
| Source Pages | Target Page | Topics to Merge |
|-------------|------------|----------------|

### Phase 3: Consolidations (New Content)
| Existing Pages | New Page Topic | Target Query |
|---------------|---------------|-------------|

## AMIT NEM TUDUNK (What We Don't Know)
- {List [UNKNOWN] items — e.g., actual search volumes without Semrush}
- {Are there pages we can't see in GSC (new, deindexed)?}
- {Is cannibalization intentional (e.g., location pages)?}

## What Could Invalidate These Findings?
- {GSC data lag (up to 3 days)}
- {Seasonal query patterns making one page look like a loser}
- {Intent differences we didn't detect}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-cannibalize-{YYYY-MM-DD}.md`
Open in Typora: `open -a Typora "{path}"`

## Notes

- **GSC-only is valid.** Without Semrush, use impression counts as a proxy for search volume. Tag as `[INFERRED]`.
- **Not all multi-page rankings are cannibalization.** If both pages rank top 5 for different intents, that's healthy. Only flag when pages compete for the same SERP position.
- **Pairs with:** `/seo-diagnose` (cannibalization as root cause of traffic drop), `/seo-decay` (decaying page might be losing to internal competitor), `/seo-gaps` (after cleanup, gaps become clearer)
- **Implementation note:** Redirects require developer/webmaster. Create tasks in TASKS.md with owner and due date.
