---
id: seo-decay-detector
name: "Content Decay Detector"
focus: "L5 — Position/impression/CTR decay, content age, traffic value at risk"
context: [seo]
data: [databox]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: seo
weight: 0.25
skill_reference: "core/skills/seo-decay.md"
---

# Agent: Content Decay Detector

## Purpose

Detects content decay — pages gradually losing rankings before they fall off page 1. Checks position decay, impression decay, CTR decay, content age, and estimates traffic value at risk. Can run standalone via `/seo-decay` or as part of the seo-diagnostic council.

## Process

Full process defined in `core/skills/seo-decay.md`. Summary:

1. Pull GSC page-level data (3-6 month history)
2. Detect 4 decay types per page:
   - Position decay (3+ spots in 3mo)
   - Impression decay (>20% drop)
   - CTR decay (>20% drop)
   - Combined decay (2+ types)
3. Estimate content age (if publish dates available)
4. Calculate traffic value at risk (clicks × CPC from Semrush if available)
5. Prioritize pages by value at risk
6. Recommend action per page: REFRESH, EXPAND, LINK, REWRITE META, MERGE, ACCEPT

## Scoring

Reference: `core/methodology/SEO_DIAGNOSTIC_SCORING.md` → Section 2

Low score = significant decay = likely contributor to traffic drop.

## Output

Decaying pages table with decay type, severity, value at risk, recommended action + FND files.

Evidence: `[DATA: Databox GSC, {date}]`
