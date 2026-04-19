---
scope: shared
argument-hint: keyword list or client slug
---

# Skill: Content Performance Clustering (`/seo-cluster`)

> v1.0 — 2026-04-14

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

"What's working? Give me more like it." — Analyzes blog/content performance, clusters posts by topic and performance tier, identifies the winning patterns (format, topic, length, freshness), and recommends what to create next based on what's already proven.

This is the content strategist skill — it turns raw performance data into a repeatable content playbook.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`.

## Trigger

Use this skill when:
- Client asks "what content is working?" or "what should we write next?"
- Account manager needs quick blog performance overview without opening GA4/Semrush
- Quarterly content strategy review
- After `/seo-gaps` identifies opportunities — this skill validates which topic areas already have traction
- Agency team member needs to present content ROI to client

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Target domain | Yes | DOMAIN_CHANNEL_MAP.md or user |
| GSC page data (last 90 days) | Yes | Databox MCP (Google Search Console) |
| GA4 page data (sessions, engagement) | Recommended | Databox MCP (GA4) |
| Semrush organic pages | Optional | Semrush MCP |
| Blog URL pattern | Recommended | User specifies (e.g., `/blog/`, `/resources/`) |
| Time period | Optional | Default: last 90 days |

## Execution Steps

1. **Data Sufficiency Check** — Verify GSC page-level data available. If GA4 available, pull engagement metrics. Log gaps.

2. **Pull content performance data:**
   - **GSC:** All pages matching blog pattern — clicks, impressions, CTR, avg position (last 90 days). Tag `[DATA]`.
   - **GA4 (if available):** Sessions, avg engagement time, bounce rate, conversions per page. Tag `[DATA]`.
   - **Semrush (if available):** Organic traffic estimate, keyword count per page, traffic trend (up/down/stable). Tag `[DATA]`.

3. **Tier content by performance:**

   | Tier | Criteria | Label |
   |------|----------|-------|
   | A — Stars | Top 10% by clicks AND position < 10 | High traffic, high rank — protect and expand |
   | B — Risers | Position 5-15 AND impressions trending up | Growing momentum — optimize to break through |
   | C — Workhorses | Steady traffic, position 1-5, no growth | Reliable but plateaued — refresh or expand |
   | D — Underperformers | High impressions, low clicks (CTR < expected) | Visibility without clicks — title/meta fix |
   | E — Dormant | Low traffic AND declining position | Candidates for refresh, consolidation, or retirement |

4. **Cluster by topic** — Group pages by semantic topic clusters:
   - Extract primary topic from page URL, title, and top GSC queries
   - Group related pages into clusters (e.g., "hot tub maintenance", "hot tub buying guide", "hot tub accessories")
   - Score each cluster: total clicks, total impressions, avg position, page count, trend (growing/stable/declining)

5. **Identify winning patterns** — Across Tier A and B content, analyze:
   - **Topic patterns:** Which topics consistently perform? `[DATA]`
   - **Format patterns:** Listicles vs guides vs how-tos vs comparisons? `[INFERRED]` from titles/URLs
   - **Length patterns:** Long-form vs short-form correlation with performance? `[INFERRED]` if no word count data
   - **Freshness patterns:** Recently updated vs old content performance? `[DATA]` from GSC date ranges
   - **Query patterns:** Informational vs transactional queries driving traffic? `[DATA]`

6. **Generate "more like this" recommendations** — For each high-performing cluster:
   - Identify subtopics not yet covered (cross-reference with `/seo-gaps` if available)
   - Suggest specific article titles/topics that extend the winning cluster
   - Recommend format based on what works in that cluster
   - Prioritize by: cluster momentum x topic gap x business relevance

7. **Identify consolidation opportunities** — Flag clusters where:
   - Multiple Tier D/E pages cover similar topics (merge candidates)
   - Thin content pages could be consolidated into one comprehensive piece
   - Old posts cannibalize newer, better posts

## Output Template

```markdown
# Content Performance Clusters — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: top performing cluster, biggest content opportunity, recommended next 3 pieces to create}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC | HIGH/MED/LOW | {issues} |
| GA4 | HIGH/MED/LOW / NOT AVAILABLE | {issues} |
| Semrush | HIGH/MED/LOW / NOT AVAILABLE | {issues} |

## Performance Overview
- **Total blog pages analyzed:** {N}
- **Period:** {date range}
- **Total organic clicks:** {N}
- **Total organic impressions:** {N}

### Tier Distribution
| Tier | Count | % of Pages | % of Traffic | Trend |
|------|-------|-----------|-------------|-------|
| A — Stars | | | | |
| B — Risers | | | | |
| C — Workhorses | | | | |
| D — Underperformers | | | | |
| E — Dormant | | | | |

## Top Performing Content (Tier A)
| # | Page | Clicks (90d) | Impressions | Avg Pos | Top Query | Cluster |
|---|------|-------------|------------|---------|-----------|---------|
| 1 | | | | | | |

## Topic Clusters
### Cluster: {Topic Name}
- **Pages:** {N}
- **Total clicks:** {N}
- **Avg position:** {N}
- **Trend:** Growing / Stable / Declining
- **Dominant tier:** A/B/C/D/E
- **Winning format:** {listicle / guide / how-to / comparison}

| Page | Tier | Clicks | Position | Query | Notes |
|------|------|--------|---------|-------|-------|
| | | | | | |

{Repeat for each cluster}

## Cluster Performance Comparison
| Cluster | Pages | Total Clicks | Avg Position | Trend | Coverage | Priority |
|---------|-------|-------------|-------------|-------|----------|----------|
| | | | | | Thin/Adequate/Deep | Expand/Maintain/Consolidate |

## Winning Patterns
| Pattern | Observation | Confidence | Evidence |
|---------|------------|-----------|----------|
| Topic | {which topics win} | | [DATA] |
| Format | {which formats win} | | [INFERRED] |
| Query type | {info vs transactional} | | [DATA] |
| Freshness | {new vs old content} | | [DATA] |

## "More Like This" — Recommended New Content
| # | Suggested Topic | Based On (winning content) | Cluster | Format | Est. Potential | Priority |
|---|----------------|--------------------------|---------|--------|---------------|----------|
| 1 | | | | | | P1 |
| 2 | | | | | | P1 |
| 3 | | | | | | P2 |

## Consolidation Candidates
| Pages to Merge | Current Combined Clicks | Reason | Recommended Action |
|---------------|------------------------|--------|-------------------|
| {URL1} + {URL2} | | Thin + overlapping topic | Merge into single comprehensive guide |

## Refresh Candidates (Tier C — Plateaued)
| Page | Current Clicks | Last Updated | Refresh Action |
|------|---------------|-------------|---------------|
| | | | Update stats, add sections, refresh title |

## AMIT NEM TUDUNK (What We Don't Know)
- {Content format/length analysis is [INFERRED] from titles/URLs — no word count data from GSC}
- {Conversion attribution per page requires GA4 data — without it, we optimize for traffic, not revenue}
- {Topic clustering is [INFERRED] from URL/title/query patterns — manual validation recommended}
- {Competitor content strategy is [UNKNOWN] without Semrush competitor analysis}

## What Could Invalidate These Findings?
- {90-day window may miss seasonal patterns — compare YoY if data available}
- {A "dormant" post may serve a high-value conversion path not visible in GSC}
- {Traffic ≠ business value — a low-traffic page may drive the most leads}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-cluster-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **This is the "show me what works" skill.** Non-technical team members (account managers) can use the output directly in client meetings.
- **Traffic ≠ value.** Always flag that the highest-traffic content isn't necessarily the most valuable. If GA4 conversion data is available, weight by conversions, not just clicks.
- **Pairs with:** `/seo-gaps` (what competitors have that we don't), `/seo-decay` (which existing content is bleeding), `/seo-cannibalize` (which posts compete with each other), `/geo-optimize` (apply GEO tactics to the winners), `/seo-narrative` (include cluster insights in monthly report)
- **Semrush enrichment:** If available, Semrush adds keyword count per page and traffic trend direction, which improves tier assignment confidence.
- **Blog URL patterns vary:** Always confirm the blog path pattern with user (`/blog/`, `/resources/`, `/news/`, `/articles/`, custom paths).
