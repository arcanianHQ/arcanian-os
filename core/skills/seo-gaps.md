---
scope: shared
argument-hint: client slug or competitor URL
---

# Skill: Content Gap Analysis (`/seo-gaps`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

"What are competitors ranking for that we're not?" — answered with real data, not generic keyword dumps. Identifies content gaps and striking-distance opportunities to prioritize content creation and optimization.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct GSC property and Semrush project. Competitor sets differ by domain. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC queries. Optimal: GSC + Semrush competitor analysis.

## Trigger

Use this skill when:
- Client asks "what content should we create next?"
- Content strategy planning or quarterly review
- Competitor just launched new content and gained visibility
- After `/seo-cannibalize` cleanup frees resources for new content
- SEO roadmap needs data-backed priorities

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Client domain | Yes | DOMAIN_CHANNEL_MAP.md or user |
| Competitor domains | Recommended | User or brand/COMPETITIVE_LANDSCAPE.md |
| GSC query data | Yes | Databox MCP (Google Search Console) |
| Semrush keyword gap | Optional | Semrush MCP — competitor keyword comparison |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum — "Striking Distance" Analysis)
Without Semrush, we can't see competitor keywords. Instead, focus on:
- **Striking distance queries:** Our queries ranking position 8-20 (close to page 1 or just off it)
- **Page 2-3 queries:** Ranking 11-30 with decent impressions = Google thinks we're relevant but not good enough
- **Low CTR outliers:** Ranking top 10 but CTR below expected for that position = title/meta needs work

### Enriched Mode (+ Semrush MCP)
- **Keyword gap analysis:** Queries where competitor ranks top 10, we don't rank at all
- **Keyword overlap:** Queries where both rank but competitor outranks us
- **Competitor-only keywords:** Queries competitor ranks for, we have zero presence
- Search volume and keyword difficulty for all gap queries

## Execution Steps

1. **Data Sufficiency Check** — Verify GSC data available. If Semrush available, confirm correct project/domain. Log gaps.

2. **Pull our keyword universe** — All GSC queries with impressions > 0 in last 90 days. Tag `[DATA]`.

3. **If Semrush available — Pull competitor gaps:**
   - Run keyword gap: our domain vs competitor domain(s)
   - Identify queries where: competitor ranks 1-10, we rank > 20 or don't rank
   - Identify queries where: competitor ranks 1-10, we rank 11-20 (opportunity)
   - Pull volume + difficulty for all gap queries. Tag `[DATA]`.

4. **If Semrush NOT available — Identify internal opportunities:**
   - Striking distance (position 8-20, impressions > 50/month): quick wins
   - Page 2-3 (position 11-30, impressions > 100/month): content optimization targets
   - Low CTR (position 1-10 but CTR < expected): title/meta optimization
   - Expected CTR by position: #1 ≈ 28%, #2 ≈ 15%, #3 ≈ 11%, #4 ≈ 8%, #5 ≈ 6%, #6-10 ≈ 2-4%

5. **Classify gaps by intent:**
   | Intent | Signals | Content Type |
   |--------|---------|-------------|
   | Informational | how, what, why, guide, tutorial | Blog post, guide, FAQ |
   | Transactional | buy, price, best, review, vs | Product page, comparison, landing page |
   | Navigational | brand name, specific product | Ensure we rank #1 for our own terms |
   | Commercial investigation | best X for Y, X vs Y, review | Comparison content, reviews |

6. **Prioritize gaps** — Score = (search volume or impressions) x (position gap) x (business relevance). Business relevance: does this query align with what the client sells? A high-volume gap for an irrelevant topic is noise.

7. **Build content action plan** — Group by: create new content, optimize existing, fix title/meta only.

## Output Template

```markdown
# Content Gap Analysis — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: biggest opportunity found, estimated traffic potential, top priority action}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC | HIGH/MED/LOW | {issues} |
| Semrush | HIGH/MED/LOW / NOT AVAILABLE | {issues} |
| Volume estimates | {actual or proxy} | |

## Analysis Mode
{GSC-only / GSC + Semrush} — {list competitors analyzed if Semrush mode}

## Opportunity Summary
- **Striking distance queries (pos 8-20):** {N} queries, ~{N} potential monthly clicks
- **Content gaps (competitor-only):** {N} queries, ~{N} monthly volume [DATA/INFERRED]
- **CTR optimization opportunities:** {N} queries

## Striking Distance Opportunities (Position 8-20)
| Query | Current Pos | Impressions | Clicks | CTR | Page URL | Action |
|-------|-----------|------------|--------|-----|----------|--------|
| | | | | | | Optimize / New section / Internal links |

## Content Gaps (Competitor ranks, we don't)
| Query | Competitor | Comp. Position | Our Position | Volume | Difficulty | Intent | Priority |
|-------|-----------|---------------|-------------|--------|-----------|--------|----------|
| | | | not ranking | | | | |

## CTR Optimization (Ranking well, clicking poorly)
| Query | Position | Expected CTR | Actual CTR | CTR Gap | Page | Fix |
|-------|---------|-------------|-----------|---------|------|-----|
| | | | | | | Title / Meta / Rich snippet |

## Content Action Plan
### Tier 1: Quick Wins (optimize existing pages)
| Page | Target Query | Current Pos | Action | Estimated Effort |
|------|-------------|-----------|--------|-----------------|

### Tier 2: New Content (create)
| Target Query Cluster | Intent | Suggested Format | Volume | Priority |
|---------------------|--------|-----------------|--------|----------|

### Tier 3: Technical/Meta (title + description fixes)
| Page | Issue | Fix |
|------|-------|-----|

## AMIT NEM TUDUNK (What We Don't Know)
- {Without Semrush: competitor keywords are invisible — we're working from our own data only}
- {Search volume estimates may differ from actual}
- {Business relevance scoring is [INFERRED] — client must validate priorities}
- {Keyword difficulty without Semrush is [UNKNOWN]}

## What Could Invalidate These Findings?
- {Competitor data may be stale (Semrush crawl lag)}
- {GSC query data is sampled for large sites}
- {Intent classification is [INFERRED] from query text}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-gaps-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **GSC-only is fully valid.** Striking distance analysis is often MORE actionable than competitor gap analysis because it shows what Google already considers you relevant for.
- **Business relevance is critical.** A 10,000-volume gap keyword that doesn't match what the client sells is worthless. Always validate with client context.
- **Pairs with:** `/competitor-monitor` (maintains `brand/COMPETITIVE_LANDSCAPE.md` and keeps competitor snapshots current — run it first on a new client), `/seo-cannibalize` (clean up before creating new content), `/seo-decay` (refresh decaying content before creating new), `/seo-diagnose` (gaps may explain why traffic dropped — competitor took the space), `/seo-narrative` (include gap findings in the monthly report)
- **Multi-language clients:** Run separately per language. A Hungarian gap analysis is different from an English one.
