---
scope: shared
---

> v1.1 — 2026-04-22 — §Source applicability by question category + SEMrush removed from campaign-performance base ratings

# Dynamic Reliability Scoring

> **Canonical rule** — when multiple data sources report on the same metric, reliability scores are computed **from the observed variance**, not from pushed/stored matrices. Static per-source ratings exist as a *base prior*; the dynamic agreement factor is what makes the score responsive to current data reality.

---

## Why dynamic, not stored

A pushed Reliability Matrix dataset has two structural problems:
1. **Stale** — reflects the reliability state when someone pushed it, not today's. If consent mode crashed GA4 yesterday, the stored matrix doesn't know.
2. **Opinion, not evidence** — pushed scores are someone's assessment. Dynamic scores emerge from **what the sources actually said** about the same question.

Dynamic scoring works whether the client has:
- Static canonical ratings only (new integration)
- Partial reliability history (some metrics corroborate, some don't)
- Rich multi-source data (full variance signal)

It also works **without any pushed reliability dataset at all** — which is how the skill behaves on a real client account that hasn't been bootstrapped with synthetic data.

---

## Source applicability (pointer)

Reliability scoring is step THREE in the data-answering pipeline. Before any scoring, the question is classified into a category and routed to applicable sources — see `core/methodology/QUESTION_ROUTING.md` for the canonical rule.

Sources **outside** a question's applicable-sources list (per QUESTION_ROUTING) MUST have `base_rating = 0` in that context. They are not scored, not rendered in the matrix, not queried. This prevents the failure mode where a wrong-tool source is displayed as a "low-reliability peer" when it's actually a category error.

The base rating tables below are scoped to the **campaign-performance** category (the one `/nexus-answer` serves). Other categories have their own base ratings expressed against their applicable sources.

---

## The algorithm

### Inputs

For each metric of interest (Revenue, Conversions, Sessions, ROAS, Spend, etc.):

- Observations from N sources that measure it (some sources don't measure every metric)
- The window the question is asking about

### Step 1 — Look up the base prior per (metric × source)

Base ratings encode *intrinsic* source trustworthiness for each metric type. They come from data-platform knowledge, not from any specific client's data.

```
BASE_RATINGS (0.0–1.0 scale) — ratings below are for the **campaign-performance question category** (see §Source applicability). Other categories use their own base ratings; don't cross-apply.

metric \ source  | GoogleAds | GA4  | MetaAds | SEMrush | Shopify | GSC
─────────────────┼───────────┼──────┼─────────┼─────────┼─────────┼──────
Revenue          |   0.75    | 0.90 |  0.55   |  0.00   |  0.95   | 0.00
Conversions      |   0.85    | 0.88 |  0.60   |  0.00   |  0.90   | 0.00
Sessions         |   0.30    | 0.92 |  0.25   |  0.00   |  0.00   | 0.40
ROAS             |   0.80    | 0.65 |  0.58   |  0.00   |  0.00   | 0.00
Spend            |   1.00    | 0.00 |  1.00   |  0.00   |  0.00   | 0.00
Impressions      |   0.95    | 0.00 |  0.95   |  0.00   |  0.00   | 0.85
Clicks           |   0.95    | 0.70 |  0.95   |  0.00   |  0.00   | 0.85
Visibility/Rank  |   0.00    | 0.00 |  0.00   |  0.75   |  0.00   | 0.80
```

The **Visibility/Rank** row is kept in the table to document that SEMrush has a legitimate domain (organic-context, ranking, AIO) — but that domain is served by different skills (e.g. `/seo-diagnose`, `/geo-audit`), each using the applicable-sources list from their own question category. In a campaign-performance answer, the Visibility row is not rendered; the SEMrush column is dropped entirely.

Rationale:
- **Shopify Revenue = 0.95** — direct payment record, source of truth when present
- **GA4 Revenue = 0.90** — first-party e-commerce tracking, known consent-mode undercounts
- **Google Ads Revenue = 0.75** — ad-click-attributed, attribution window distorts
- **Meta Ads Revenue = 0.55** — Meta-pixel + 7-day-click + 1-day-view is known overcounter
- **SEMrush Revenue = 0.00** — not a campaign-performance source; third-party organic-traffic estimation is not a peer of paid/first-party measurement for this question category
- **GA4 Sessions = 0.92** — first-party, GA4 literally measures sessions
- **GA4 ROAS = 0.65** — needs cross-source spend reconciliation (GA4 doesn't know spend)
- **Google Ads Spend = 1.00** — the ad platform is definitional for its own spend
- **0.00** = source is either (a) structurally unable to measure this metric, or (b) outside the applicable-sources list for this question category. Either way: ignore the cell, drop the column if all its cells are 0.

### Step 2 — Compute the cross-source agreement factor

For a given metric, collect all source observations:

```
observations = {
  "GoogleAds": 67_118,
  "GA4":       95_150,
  "MetaAds":   60_890,
  "SEMrush":   null,     # doesn't measure Revenue directly
}
```

Compute the **median** of non-null observations. Median (not mean) because one outlier shouldn't drag the consensus.

```
median = 67_118   # middle of three values
```

For each source with an observation, compute the deviation and its agreement factor:

```
deviation_pct = abs(observation - median) / median

agreement_factor:
  if deviation_pct <= 0.20      →  1.00            # within 20% = fully trusted
  elif deviation_pct <= 0.50    →  1.0 - ((deviation_pct - 0.20) / 0.30) * 0.30
                                    # linear decay from 1.00 down to 0.70 at 50% deviation
  elif deviation_pct <= 1.00    →  0.70 - ((deviation_pct - 0.50) / 0.50) * 0.40
                                    # steep decay from 0.70 down to 0.30 at 100% deviation
  else                           →  0.30            # beyond 2× median — clearly unreliable

# Floor at 0.10, ceiling at 1.00
```

### Step 3 — Final reliability score per cell

```
reliability_score = base_rating × agreement_factor × 100

# Maps cleanly to Confidence Engine scale:
#   > 70  →  HIGH    (Confidence 0.9)
#   40–70 →  MEDIUM  (Confidence 0.6)
#   < 40  →  LOW     (Confidence 0.3)
```

### Step 4 — Surface the disagreement

For each metric, find the **largest variance** across sources:

```
variance = max(scores) - min(scores)
```

If variance > 40 points → flag this metric as the "disagreement row" — append warning + action in Block 3.

Example:
- Sessions row: GA4=94, GoogleAds=28, MetaAds=26, SEMrush=55 → variance = 68 → flag
- Warning: *"Sessions: GA4 vs Google Ads/Meta disagree (variance 68). Organic + direct measurement far higher than paid-side attribution."*
- Action: *"Trust GA4 for Sessions. The ad-platform session counts are sessions-after-ad-click, not total."*

---

## Worked example — DEMO data, promo window 2026-03-19 to 2026-04-01

**Observed metrics (from ask_genie on each dataset):**

```
Revenue:
  GA4:       957,900
  Shopify:   unset on this DEMO config (GA4 Revenue is the proxy)
  GoogleAds: Conv.Value 67,118  → treat as Revenue-adjacent
  MetaAds:   Revenue 14,400

Conversions:
  GA4:       135
  GoogleAds: 106
  MetaAds:   59 (Meta-pixel count, 7d-click + 1d-view)

Sessions:
  GA4:       23,215
  GoogleAds: (paid-click sessions only, not total) ~1,500 estimated
  SEMrush:   estimated organic ~10,500

Spend:
  GoogleAds: 7,454
  MetaAds:   5,615
```

**Compute medians + scores:**

*Revenue:*
median = 67,118 (between 14,400, 67,118, 957,900 — middle is 67,118)
- GA4 observation 957,900: deviation = 13.3× median → way beyond range → agreement 0.10
  BUT wait — GA4 Revenue is likely in a different unit or context than Google Ads Conv.Value. This is a **unit mismatch flag**, not a real reliability problem.
- *Lesson: before computing agreement, normalize units or mark as "not comparable."*

This is a real-data subtlety. The algorithm must distinguish:
1. Sources measuring the same thing that disagree (real reliability signal)
2. Sources measuring different things that look similar (units problem)

**Rule:** only compute agreement within the same metric + same unit + same period definition.

For the DEMO case: GA4 Revenue (total site revenue) ≠ Google Ads Conv.Value (ad-attributed revenue). These are different ground truths. Each has its own base rating:
- GA4 total Revenue for "total business revenue" → 0.90 (nearly definitional)
- Google Ads Conv.Value for "total business revenue" → 0.20 (only covers ad-click part)
- BUT Google Ads Conv.Value for "ad-attributed revenue" → 0.95 (its own definition)

**Disambiguation**: use the USER's question intent to pick the right comparison set. *"Hogyan teljesített a kampány?"* → business-performance view → use Revenue from GA4 or Shopify as source of truth, Meta/Google as ad-side views.

### Simpler worked example — Conversions

All three sources report "Conversions" but with different definitions, and it's the same direction of measurement:

```
GoogleAds:  106  (ad-click-attributed conversions, 30-day)
GA4:        135  (first-party events meeting conversion criteria)
MetaAds:     59  (Meta-pixel-attributed, 7d-click + 1d-view)
```

Median = 106

deviations:
- GoogleAds |106-106|/106 = 0.00 → agreement 1.00
- GA4       |135-106|/106 = 0.27 → agreement ~0.93
- MetaAds   | 59-106|/106 = 0.44 → agreement ~0.76

Base ratings:
- GoogleAds Conversions: 0.85
- GA4 Conversions:       0.88
- MetaAds Conversions:   0.60

Final scores:
- GoogleAds: 0.85 × 1.00 × 100 = **85** 🟢
- GA4:       0.88 × 0.93 × 100 = **82** 🟢
- MetaAds:   0.60 × 0.76 × 100 = **46** 🟡

variance = 85 − 46 = 39 → *just below flag threshold*

Interpretation: all three sources broadly agree on Conversions, with Meta Ads showing the typical Meta-pixel inflation but not catastrophically. No urgent cross-check needed.

---

## Integration with `/nexus-answer`

Block 3 (Megbízhatóság) rendering now comes from this algorithm:

1. Gather the same core-metric observations already pulled for Block 1
2. For each (metric × source) cell: base × agreement × 100
3. Build the matrix on the fly
4. Flag largest-variance row
5. Render

The pushed `Reliability Matrix Weekly` dataset is no longer authoritative — it serves only as:
- Historical cache (track reliability over time)
- Demo visualization on the dashboard (where dynamic compute isn't possible in a static Databox panel)
- Fallback if the skill can't pull core metrics fresh

---

## When to trust dynamic scoring

| Situation | Scoring quality | Notes |
|---|---|---|
| ≥3 sources per metric, all fresh | HIGH | Median is stable, variance meaningful |
| 2 sources per metric, fresh | MEDIUM | No median — use midpoint; agreement factor applies symmetrically |
| 1 source per metric | LOW signal | Use base rating only; note "single-source" flag |
| All sources stale (same ingestion lag) | MEDIUM | Reliability still comparable across sources |
| One source vastly newer than others | **FLAG** | Apparent "disagreement" may be a time-lag artefact — note before scoring |
| Sources measure different definitions of the metric | **DO NOT SCORE TOGETHER** | Partition into separate (metric × definition) comparison sets |

---

## Anti-patterns

1. **Comparing incomparable definitions** — GA4 total Revenue vs Google Ads Conv.Value without noting they measure different things
2. **Weighting by source volume** — don't scale agreement by how much spend goes through each source; reliability is not traffic-weighted
3. **Treating old stored scores as gospel** — always compute fresh unless explicit cache-usage decision
4. **Hiding single-source metrics** — if SEMrush is the only source for organic-visibility, surface that single-source flag, don't pretend it's corroborated

---

## Confidence Engine integration

The dynamic score feeds directly into the Confidence Engine Source Confidence dimension:

```
Source Confidence =
  reliability_score / 100    # normalized to 0.0–1.0

Overall answer confidence =
  min(Source Confidence,
      Evidence Class,         # typically 0.9 for Databox-sourced DATA
      Assumption Status)      # typically 0.9 unless flagged
```

Skills surface both:
- Per-metric confidence (inline [Conf: 0.8 HIGH] tag in Block 1)
- Overall answer confidence (in Block 2 footer, Block 4 gating)

---

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — dynamic cross-source variance-based scoring. Base ratings per (metric × source). Agreement factor from deviation from median. Worked example on DEMO data. Integrates with CONFIDENCE_ENGINE.md Source Confidence dimension. |
| v1.1 | 2026-04-22 | **Source applicability extracted to `QUESTION_ROUTING.md`** — the question-category → applicable-sources logic was initially added here but belongs at the top of the pipeline, not inside the scoring rule. This doc now carries a short pointer section referencing QUESTION_ROUTING. Base rating table scoped to the campaign-performance category: SEMrush × {Revenue, Conversions, ROAS, Sessions, Impressions, Clicks} → 0.00 (SEMrush is not a campaign-performance source; its legitimate domain — SEO / competitive / AIO — is handled by different skills). Kept SEMrush × Visibility/Rank = 0.75 as documentation that the source has a domain, just not this one. Caught during `/nexus-answer` test where the Block 3 matrix rendered SEMrush as 🔴 10 / 🔴 15 on Revenue / Conversions — category error masquerading as a reliability issue. |
