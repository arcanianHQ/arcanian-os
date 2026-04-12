---
scope: shared
---

> v1.0 — 2026-04-12
> Scoring rubrics for SEO diagnostic agents.

# SEO Diagnostic Scoring Rubrics

## Purpose

When organic traffic drops, multiple analysis dimensions must be checked simultaneously. Each agent checks one dimension and scores the likelihood it explains the drop. The council synthesizes into a unified diagnosis.

## Status Thresholds

| Score | Status | Meaning |
|---|---|---|
| ≥80 | Healthy | This dimension is not the cause |
| 60-79 | Possible cause | Investigate further |
| <60 | Likely cause | Strong evidence this explains the drop |

**Note:** LOWER scores = MORE likely this is the problem. A "healthy" score means this dimension is fine, NOT that SEO performance is good.

---

## 1. Traffic Change Analyzer (seo-traffic-analyzer)

**Does NOT score health. Provides the baseline data all other agents use.**

Outputs:
- Total clicks/impressions/CTR/position change (current vs prior period)
- Top 20 query losers with delta
- Top 10 page losers with delta
- GA4 cross-validation (organic sessions)
- Data reliability rating

---

## 2. Decay Detector (seo-decay-detector)

| Check | Weight | Criteria |
|---|---|---|
| Pages with position decay (3+ spots in 3mo) | 30% | Count × severity |
| Pages with impression decay (>20% drop) | 25% | Count × magnitude |
| Pages with CTR decay (>20% drop) | 15% | Count × magnitude |
| Content age analysis | 15% | Avg months since update |
| Traffic value at risk | 15% | Clicks lost × estimated CPC |

**Score interpretation:** Low score (0-60) = significant content decay, likely contributor to traffic drop.

---

## 3. Cannibalization Detector (seo-cannibalization-detector)

| Check | Weight | Criteria |
|---|---|---|
| Cannibalizing pairs found | 40% | Count of query-page pairs |
| Position gap between competing pages | 25% | Avg gap × pairs |
| Click distribution skew | 20% | How unevenly clicks are split |
| High-value queries affected | 15% | Volume of affected queries |

**Score interpretation:** Low score (0-60) = significant cannibalization, Google confused about which page to rank.

---

## 4. Technical SEO Checker (seo-technical-checker)

| Check | Weight | Criteria |
|---|---|---|
| Indexation issues (noindex, robots.txt) | 25% | Pages blocked that shouldn't be |
| Sitemap health | 15% | Valid, includes key pages |
| Schema markup presence | 15% | JSON-LD on key pages (calls page-schema-checker) |
| Meta tags quality | 15% | Title/description optimization (calls page-meta-checker) |
| Heading hierarchy | 10% | H1 structure (calls page-heading-checker) |
| Mobile-friendliness signals | 10% | Viewport, responsive |
| HTTPS/security | 10% | SSL, mixed content |

**Score interpretation:** Low score = technical issues blocking crawling/indexing/rendering.

---

## 5. Competitor Analyzer (seo-competitor-analyzer)

| Check | Weight | Criteria |
|---|---|---|
| Competitor visibility change | 30% | Did competitors gain while we lost? |
| Competitor content freshness | 25% | Did competitors update content we didn't? |
| SERP feature changes | 20% | Did new features (PAA, snippets) push us down? |
| Competitor gap queries | 15% | New queries competitors rank for |
| Market-level shift | 10% | Seasonal or industry-wide pattern |

**Data dependency:** Requires Semrush MCP. Without it → score as N/A, flag as blind spot.

---

## Aggregation

The SEO diagnostic council does NOT produce a single "health score." Instead it produces:

1. **ACH table** — all 6 hypotheses scored against evidence
2. **Leading hypothesis** with confidence level
3. **Falsification indicator** — what evidence would change the diagnosis
4. **Action items** prioritized by hypothesis

The chairman (seo-diagnosis-synthesizer) runs the ACH methodology and writes the BLUF.

## Mandatory Hypotheses

Every SEO diagnosis MUST test these 6 hypotheses:

| # | Hypothesis | Agent that tests it |
|---|---|---|
| H1 | Algorithm update | seo-traffic-analyzer (pattern recognition) |
| H2 | Content decay | seo-decay-detector |
| H3 | Technical issue | seo-technical-checker |
| H4 | Competitor gain | seo-competitor-analyzer |
| H5 | Seasonal decline | seo-traffic-analyzer (YoY comparison) |
| H6 | Cannibalization | seo-cannibalization-detector |

## References
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`
- `core/methodology/DATA_SUFFICIENCY_CHECK.md`
