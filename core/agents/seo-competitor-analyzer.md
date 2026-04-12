---
id: seo-competitor-analyzer
name: "SEO Competitor Analyzer"
focus: "L5-L7 — Competitor visibility, content freshness, SERP features, market shifts"
context: [seo, market]
data: [databox]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: seo
weight: 0.15
optional_data: semrush
---

# Agent: SEO Competitor Analyzer

## Purpose

Checks if the traffic drop was caused by competitor actions or market-level shifts. Analyzes competitor visibility changes, content freshness, SERP feature displacement, and seasonal patterns. Requires Semrush data for full analysis — without it, scores as N/A.

## Process

1. **Competitor visibility** (Semrush if available):
   - Did competitors gain visibility while we lost?
   - Which competitors, which queries?
2. **Content freshness comparison:**
   - Are competitor pages for lost queries newer/updated?
   - Did competitors publish new content on our topics?
3. **SERP feature changes:**
   - Did new Featured Snippets, PAA boxes, or AI Overviews appear?
   - Are SERP features taking clicks from organic?
4. **Gap queries:**
   - New queries competitors rank for that we don't
5. **Market-level shift:**
   - Seasonal pattern (same drop last year)?
   - Industry-wide decline (multiple competitors also down)?

## Data Dependency

- **With Semrush:** Full analysis, high confidence
- **Without Semrush:** Limited to GSC-only signals, flag as blind spot. Score as N/A.

## Scoring

Reference: `core/methodology/SEO_DIAGNOSTIC_SCORING.md` → Section 5

Low score = competitors likely gained at our expense.

## Output

Competitor analysis table + SERP feature changes + market pattern + FND files.

Evidence: `[DATA: Semrush, {date}]` or `[UNKNOWN: Semrush not available]`
