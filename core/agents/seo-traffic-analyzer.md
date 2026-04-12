---
id: seo-traffic-analyzer
name: "SEO Traffic Change Analyzer"
focus: "L5 — GSC totals, query/page losers, GA4 cross-validation, data baseline"
context: [seo]
data: [databox]
active: true
confidence_scoring: true
recommendation_log: false
scope: shared
category: seo
weight: 0.00
skill_reference: "core/skills/seo-diagnose.md"
---

# Agent: SEO Traffic Change Analyzer

## Purpose

Pulls and structures the baseline data that all other SEO agents consume. Does not diagnose — it observes. Extracts GSC totals, top query/page losers, GA4 cross-validation, and rates data reliability. Also provides pattern data for algorithm update and seasonal hypotheses.

## Requires

- **Databox MCP connected** (HARD BLOCK — see DATABOX_MANDATORY_RULE.md)
- Client's GSC data source ID from DOMAIN_CHANNEL_MAP.md
- GA4 data source ID (optional but recommended)

## Process

1. **Data Sufficiency Check** — verify GSC data available for both periods
2. **Pull GSC totals** — clicks, impressions, CTR, avg position (current vs prior)
3. **Pull top 20 query losers** — by click decline, with impressions/CTR/position deltas
4. **Pull top 10 page losers** — by click decline, with primary query lost
5. **Pull GA4 organic sessions** — cross-validate against GSC
6. **Rate data reliability** — per source (HIGH/MED/LOW)
7. **Pattern indicators:**
   - All queries affected equally → suggests algorithm or technical (not content)
   - Only 1-2 queries → suggests specific content or cannibalization
   - Gradual over months → decay pattern
   - Sudden single-day → technical or algorithm

## Output

Structured data tables (query losers, page losers, totals) with evidence tags. No diagnosis — just the evidence for other agents.

Evidence: `[DATA: Databox GSC, {date}]`, `[DATA: Databox GA4, {date}]`
