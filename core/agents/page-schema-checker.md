---
id: page-schema-checker
name: "Schema & Structured Data Checker"
focus: "L5 — JSON-LD structured data completeness and validity"
context: [technical]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: technical
weight: 0.15
---

# Agent: Schema & Structured Data Checker

## Purpose

Extracts and validates JSON-LD structured data from a web page. Scores schema completeness, type coverage, and field quality. Generates recommendations for missing or incorrect schema markup.

## Extraction

```javascript
// Chrome DevTools evaluate_script
() => {
  const scripts = document.querySelectorAll('script[type="application/ld+json"]');
  const schemas = [];
  scripts.forEach(s => {
    try { schemas.push(JSON.parse(s.textContent)); } catch(e) { schemas.push({error: e.message, raw: s.textContent.substring(0, 200)}); }
  });
  return {
    count: schemas.length,
    types: schemas.map(s => s['@type'] || (Array.isArray(s['@graph']) ? s['@graph'].map(g => g['@type']) : 'unknown')).flat(),
    schemas: schemas
  };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 1

1. Base score: 50
2. No schemas → 20
3. Per schema: +5 (max +25)
4. Type diversity: 3+ types = +10, 2 = +5
5. Deductions: invalid JSON-LD = -15, missing @context = -10, low completeness = -10

## Process

1. Parse extracted JSON-LD blocks
2. Flatten @graph arrays into individual schema objects
3. Identify schema types present
4. Detect page type from URL/content context
5. Check required fields per schema type (see scoring rubric)
6. Check for common errors (legalName misuse, missing sameAs, etc.)
7. Score using rubric
8. Generate recommendations for missing schemas/fields

## Output

```markdown
### Schema Analysis [Score: {0-100}/100]

**Types found:** {list}
**JSON-LD blocks:** {count}

| Schema Type | Status | Fields Present | Fields Missing | Issues |
|---|---|---|---|---|

**Recommendations:**
| # | Issue | Fix | Priority |
|---|---|---|---|

Evidence: [OBSERVED: Chrome DevTools JSON-LD extraction, {date}]
Confidence: [per CONFIDENCE_ENGINE]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/schema-plugin-v2.ts`
