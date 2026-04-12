---
id: page-content-checker
name: "Content Quality Checker"
focus: "L5 — Word count, paragraph structure, content depth by page type"
context: [content]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: content
weight: 0.20
---

# Agent: Content Quality Checker

## Purpose

Extracts and evaluates page content quality. Assesses word count against page-type benchmarks, paragraph structure, sentence variety, and content depth. Also serves as **chairman** for the page-analysis council — synthesizes all agent scores into the final report.

## Extraction

```javascript
() => {
  const text = document.body.innerText || '';
  const words = text.split(/\s+/).filter(w => w.length > 0);
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const paragraphs = document.querySelectorAll('p');
  const lists = document.querySelectorAll('ul, ol');
  const tables = document.querySelectorAll('table');
  const avgSentenceLength = sentences.length > 0 ? words.length / sentences.length : 0;
  // Detect page type from URL
  const url = window.location.pathname;
  let pageType = 'landing';
  if (url === '/' || url === '/home') pageType = 'homepage';
  else if (/\/(product|p|termek)\//i.test(url)) pageType = 'product';
  else if (/\/(blog|article|cikk|hirek|news)\//i.test(url)) pageType = 'article';
  else if (/\/(category|collection|kategoria)\//i.test(url)) pageType = 'category';
  else if (/\/(faq|gyakran)/i.test(url)) pageType = 'faq';
  return {
    wordCount: words.length,
    sentenceCount: sentences.length,
    paragraphCount: paragraphs.length,
    listCount: lists.length,
    tableCount: tables.length,
    avgSentenceLength: Math.round(avgSentenceLength * 10) / 10,
    readingTimeMinutes: Math.ceil(words.length / 200),
    pageType: pageType
  };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 4

- Word count in optimal range for page type: 30 points
- Paragraph structure (>5 = 15, >10 = 20): 20 points
- Sentence variety (mix of lengths): 15 points
- Content depth (lists, tables, structured elements): 20 points
- No boilerplate dominance: 15 points

## Process

1. Extract content metrics
2. Detect page type from URL patterns
3. Compare word count against benchmarks for that page type
4. Assess paragraph structure (enough paragraphs for the content length?)
5. Check for content depth indicators (lists, tables)
6. Estimate boilerplate ratio (nav/footer text vs main content)
7. Score using rubric
8. Generate recommendations for thin/excessive content

## Chairman Role

When acting as chairman for the page-analysis council:
1. Collect all 6 agent scores
2. Apply weights from `PAGE_ANALYSIS_SCORING.md` aggregation formula
3. Calculate overall score
4. Identify the weakest dimension
5. Generate the BLUF (1-2 sentences: what's strong, what needs attention)
6. Compile unified recommendation list sorted by priority

## Output

```markdown
### Content Quality [Score: {0-100}/100]

| Metric | Value | Benchmark ({pageType}) |
|---|---|---|
| Word count | {N} | {optimal range} |
| Paragraphs | {N} | >5 recommended |
| Lists | {N} | — |
| Tables | {N} | — |
| Avg sentence length | {N} words | <20 ideal |
| Reading time | {N} min | — |
| Page type (detected) | {type} | — |

Evidence: [OBSERVED: Chrome DevTools content extraction, {date}]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/content-quality-plugin-v2.ts`
