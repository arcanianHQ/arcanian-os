---
id: page-heading-checker
name: "Heading Hierarchy Checker"
focus: "L5 — H1-H6 structure, nesting, SEO heading optimization"
context: [semantic]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: semantic
weight: 0.15
---

# Agent: Heading Hierarchy Checker

## Purpose

Extracts and validates the heading structure (H1-H6) of a web page. Checks for single H1, logical nesting, heading position, content quality, and common misuse patterns (H3 for styling, skipped levels).

## Extraction

```javascript
() => {
  const headings = [];
  document.querySelectorAll('h1,h2,h3,h4,h5,h6').forEach(h => {
    headings.push({ level: parseInt(h.tagName[1]), text: h.textContent.trim().substring(0, 120) });
  });
  return {
    count: headings.length,
    h1Count: headings.filter(h => h.level === 1).length,
    headings: headings
  };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 3

- Single H1: 30 points
- H1 position (first heading): 10 points
- H1 content quality: 10 points
- Logical nesting (no skips): 20 points
- Heading count (3-15): 15 points
- Heading depth (uses H2+H3): 10 points
- No empty headings: 5 points

## Process

1. Extract all headings with levels and text
2. Count H1s — exactly 1 is correct
3. Check H1 position — should be the first heading
4. Check H1 content — descriptive, >3 words, not generic
5. Walk the hierarchy — flag any skipped levels (H1→H3)
6. Check for empty headings
7. Detect headings used for styling (very short, non-descriptive)
8. Build visual heading tree for output

## Output

```markdown
### Heading Hierarchy [Score: {0-100}/100]

**H1:** "{text}" (position: {first/Nth heading})
**Total headings:** {count}

```
{indented H1-H6 tree}
```

**Issues:**
| # | Issue | Severity | Location |
|---|---|---|---|

Evidence: [OBSERVED: Chrome DevTools heading extraction, {date}]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/header-hierarchy-plugin-v2.ts`
