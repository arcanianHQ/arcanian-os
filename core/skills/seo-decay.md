---
scope: shared
argument-hint: client slug or URL
---

# Skill: Decaying Content Alerts (`/seo-decay`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

Flag pages losing rankings BEFORE they fall off page 1, not after months of invisible bleed. Content decay is the silent killer of organic traffic — this skill catches it early.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct GSC property. Decay analysis is per-domain. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Data sufficiency:** Before analysis, run `core/methodology/DATA_SUFFICIENCY_CHECK.md`. Minimum: GSC data for current + 3 months ago. Optimal: GSC 6-month history + Semrush.

## Trigger

Use this skill when:
- Monthly/quarterly SEO review — always check for decay
- `/seo-diagnose` identified content decay as a hypothesis
- Client hasn't updated blog/content in 3+ months
- Proactive health check before traffic actually drops
- Planning content refresh priorities

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| GSC data (3+ months) | Yes | Databox MCP (Google Search Console) |
| GSC data (6 months) | Recommended | Databox MCP — better trend detection |
| Semrush keyword data | Optional | Semrush MCP — adds CPC for traffic value |
| BASELINES.md | Optional | Client directory — if exists, compare against baseline |
| DOMAIN_CHANNEL_MAP.md | If multi-domain | Client directory |

## Data Sources

### GSC-Only Mode (Minimum)
- Page-level data: clicks, impressions, CTR, avg position — compare 3 periods:
  - Current month
  - 3 months ago
  - 6 months ago (if available)

### Enriched Mode (+ Semrush MCP)
- CPC data for traffic value estimation (clicks x CPC = traffic value at risk)
- Keyword difficulty to assess if decay is from increased competition

## Execution Steps

1. **Data Sufficiency Check** — Need GSC page-level data for at least 2 periods (current + 3 months ago). If only 1 period: STOP, explain that trend detection requires historical data.

2. **Pull page-level GSC data for all periods** — For each page: clicks, impressions, CTR, avg position. Tag `[DATA]`.

3. **Identify decaying pages** — Apply three decay detection filters:

   | Decay Type | Detection Rule | Severity |
   |-----------|---------------|----------|
   | **Position decay** | Avg position worsened by 3+ spots over 3 months | HIGH if was page 1, MED otherwise |
   | **Impression decay** | Impressions dropped 20%+ while position held (±2) | MED — search volume declining for topic |
   | **CTR decay** | Position held but CTR dropped 20%+ | LOW-MED — SERP features or competitor snippets |
   | **Combined decay** | Position + impressions both declining | CRITICAL — active loss |

4. **For each decaying page — drill into queries:**
   - Pull top 5 queries driving this page
   - Which queries lost position? Which lost impressions?
   - Is the decay concentrated on one query or spread across many? Tag `[DATA]`.

5. **Prioritize by traffic value at risk:**
   - If Semrush available: traffic value = monthly clicks x avg CPC. Tag `[DATA]`.
   - If Semrush NOT available: traffic value = monthly clicks (raw). Tag as `[INFERRED]` value.
   - Sort by traffic value descending.

6. **Classify recommended action per page:**

   | Situation | Action | Urgency |
   |-----------|--------|---------|
   | Content is outdated (dates, stats, links) | **REFRESH** — update facts, keep structure | This month |
   | Page lacks depth vs current SERP | **EXPAND** — add sections, FAQs, examples | This quarter |
   | Internal link structure weak | **LINK** — add internal links from strong pages | This week |
   | Title/meta outdated or weak CTR | **REWRITE META** — new title + description | This week |
   | Stronger page exists on same topic | **MERGE** — consolidate into the stronger page | Use `/seo-cannibalize` |
   | Topic search volume genuinely declining | **ACCEPT** — seasonal or permanent trend shift | Monitor only |

7. **Build refresh calendar** — Order by urgency x traffic value. Assign to content calendar.

## Output Template

```markdown
# Content Decay Report — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: how many pages decaying, total traffic at risk, most urgent action}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| GSC (current) | HIGH/MED/LOW | {period: date range} |
| GSC (3mo ago) | HIGH/MED/LOW | {period: date range} |
| GSC (6mo ago) | HIGH/MED/LOW / NOT AVAILABLE | |
| Semrush CPC | HIGH/MED/LOW / NOT AVAILABLE | |

## Decay Summary
| Decay Type | Pages Affected | Est. Monthly Clicks at Risk |
|-----------|---------------|---------------------------|
| Position decay | {N} | {N} |
| Impression decay | {N} | {N} |
| CTR decay | {N} | {N} |
| Combined (critical) | {N} | {N} |
| **Total** | **{N}** | **{N}** |

## Decaying Pages (by traffic value at risk)
| # | Page | Decay Type | Pos Now → 3mo → 6mo | Clicks Now → 3mo | Traffic Value | Priority |
|---|------|-----------|---------------------|-----------------|--------------|----------|
| 1 | | | | | | CRITICAL/HIGH/MED/LOW |

## Detailed Decay Analysis (Top 10)
### Page 1: {URL}
- **Decay type:** {position/impression/CTR/combined}
- **Position trend:** {now} ← {3mo} ← {6mo} `[DATA]`
- **Click trend:** {now} ← {3mo} ← {6mo} `[DATA]`
- **Top queries affected:**
  | Query | Position Δ | Clicks Δ |
  |-------|-----------|---------|
  | | | |
- **Likely cause:** {what's happening} [Confidence: HIGH/MED/LOW]
- **Recommended action:** {specific action}

## Content Refresh Calendar
| Month | Page | Action | Effort | Expected Impact |
|-------|------|--------|--------|----------------|
| {current} | | REWRITE META / LINK | Low | Quick CTR recovery |
| {current} | | REFRESH | Medium | Position recovery in 4-8 weeks |
| {next} | | EXPAND | High | New ranking potential |

## AMIT NEM TUDUNK (What We Don't Know)
- {Seasonal patterns: is this cyclical decline? Need YoY data to confirm}
- {Competitor content: did a competitor publish better content? [UNKNOWN] without Semrush}
- {SERP feature changes: did a featured snippet or People Also Ask take clicks?}
- {Content last-updated dates: when was this page actually last edited?}

## What Could Invalidate These Findings?
- {Seasonal patterns (compare YoY if data available)}
- {GSC position averaging hides daily volatility}
- {Site migration or URL changes in the period}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-decay-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **Run monthly.** Decay is gradual — catching a 3-position drop early prevents a 15-position drop later.
- **BASELINES.md:** If the client has `data/seo/BASELINES.md` with target positions per query, compare against baselines instead of just historical data.
- **Pairs with:** `/seo-diagnose` (decay as root cause of traffic drop), `/seo-cannibalize` (internal competition accelerates decay), `/seo-gaps` (after refreshing decayed content, check for new gaps), `/seo-narrative` (include decay findings in monthly report)
- **Content age matters but isn't the only signal.** A 3-year-old evergreen page that still ranks well is NOT decaying. Only flag pages where DATA shows declining performance.
