---
id: competitor-digest-synthesizer
name: "Competitor Digest Synthesizer"
focus: "Synthesis — Competitive intelligence digest with prioritized content and SEO actions"
context: [seo, market, competition]
data: [firecrawl]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: competitor
weight: 0.00
optional_data: semrush
model: sonnet
---

# Agent: Competitor Digest Synthesizer (Chairman)

## Purpose

Reads structured outputs from the three analysis agents (blog monitor, page watcher, SEO gap agent), synthesizes into a single prioritized digest with confidence-scored findings and action items. This is the chairman agent — it runs after the analysis stage completes.

## Process

1. **Receive structured output** from:
   - `competitor-blog-monitor` — new posts, topic trends, content strategy signals
   - `competitor-page-watcher` — page changes with magnitude classification
   - `competitor-seo-gap-agent` — keyword/content gaps with evidence tags

2. **Deduplicate overlapping signals:**
   - If blog monitor and SEO gap agent both flag the same topic cluster → merge into one finding, note both evidence sources
   - If page watcher detects a messaging change that aligns with a blog topic shift → connect as corroborating evidence

3. **Score each finding** via `core/methodology/CONFIDENCE_ENGINE.md`:
   - Confidence = min(source_confidence, evidence_class, assumption_status)
   - `[DATA]` sources (SEMrush) → HIGH base confidence
   - `[OBSERVED]` sources (Firecrawl crawls) → MED-HIGH base confidence
   - `[INFERRED]` signals (strategy inference) → LOW-MED base confidence

4. **Prioritize findings** — include in digest if:
   - Confidence >= 0.4 AND at least one of:
     - Keyword gap with meaningful volume (> 100/month or client-relevant)
     - Page change classified as SIGNIFICANT or MAJOR
     - Content trend signal (topic in 2+ competitors)
     - Pricing change (always included regardless of other criteria)

5. **Generate action items** — one per significant finding:
   - Content to create (from gaps + blog trends)
   - Pages to update (from competitive messaging shifts)
   - Keywords to target (from SEO gaps)
   - Alerts to flag (pricing changes, major repositioning)

6. **Compile digest** using `core/templates/COMPETITOR_MONITOR_DIGEST_TEMPLATE.md`

7. **Flag for task creation:** findings with confidence >= 0.5 AND priority HIGH

## Output

Complete digest following the COMPETITOR_MONITOR_DIGEST_TEMPLATE format:
- BLUF (2-3 sentences)
- Data reliability table
- Competitor summary table
- Blog activity section
- Page changes section
- SEO gap analysis section
- Prioritized action items
- AMIT NEM TUDUNK section
- Invalidation signals

Evidence tags preserved from source agents — never upgrade an `[INFERRED]` to `[OBSERVED]` during synthesis.
