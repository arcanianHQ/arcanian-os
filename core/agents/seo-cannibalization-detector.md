---
id: seo-cannibalization-detector
name: "Cannibalization Detector"
focus: "L5 — Multiple pages ranking for same query, click distribution, position gap"
context: [seo]
data: [databox]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: seo
weight: 0.20
skill_reference: "core/skills/seo-cannibalize.md"
---

# Agent: Cannibalization Detector

## Purpose

Finds pages competing for the same keyword. When two pages fight for the same query, neither wins. Identifies cannibalizing pairs, scores severity, and recommends action (KEEP, MERGE, REDIRECT, DIFFERENTIATE, MONITOR). Can run standalone via `/seo-cannibalize` or as part of the council.

## Process

Full process defined in `core/skills/seo-cannibalize.md`. Summary:

1. Pull GSC query+page dimensions (last 90 days)
2. Find queries with 2+ pages ranking
3. Score each pair by: position gap, click distribution skew, volume
4. Classify: true cannibalization vs acceptable multi-ranking
5. Recommend action per pair
6. Prioritize by impact (volume × gap)

## Scoring

Reference: `core/methodology/SEO_DIAGNOSTIC_SCORING.md` → Section 3

Low score = significant cannibalization = likely contributor.

## Output

Cannibalizing pairs table with scores, actions + FND files.

Evidence: `[DATA: Databox GSC query+page, {date}]`
