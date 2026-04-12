---
id: page-readability-checker
name: "Readability Checker"
focus: "L5 — Flesch-Kincaid, sentence complexity, language-aware scoring"
context: [content]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: content
weight: 0.10
---

# Agent: Readability Checker

## Purpose

Measures page text readability using Flesch-Kincaid (English) and sentence-length metrics (all languages). Language-aware — detects page language and adjusts scoring accordingly. For non-English pages, falls back to sentence-length-only scoring.

## Extraction

```javascript
() => {
  const text = document.body.innerText || '';
  const lang = document.documentElement.lang || '';
  const words = text.split(/\s+/).filter(w => w.length > 0);
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const avgSentenceLength = sentences.length > 0 ? words.length / sentences.length : 0;
  // Syllable count (English approximation — vowel groups)
  const syllables = words.reduce((sum, w) => sum + (w.match(/[aeiouy]+/gi) || []).length, 0);
  const fleschKincaid = words.length > 0 && sentences.length > 0 ? 206.835 - 1.015 * (words.length / sentences.length) - 84.6 * (syllables / words.length) : 0;
  // Sentence length distribution
  const sentenceLengths = text.split(/[.!?]+/).filter(s => s.trim().length > 0).map(s => s.trim().split(/\s+/).length);
  const shortSentences = sentenceLengths.filter(l => l < 10).length;
  const longSentences = sentenceLengths.filter(l => l > 25).length;
  return {
    lang: lang,
    isEnglish: /^en/i.test(lang),
    wordCount: words.length,
    sentenceCount: sentences.length,
    avgSentenceLength: Math.round(avgSentenceLength * 10) / 10,
    fleschKincaid: Math.round(fleschKincaid * 10) / 10,
    shortSentences: shortSentences,
    longSentences: longSentences,
    sentenceLengthVariety: sentenceLengths.length > 0 ? Math.round((new Set(sentenceLengths.map(l => Math.floor(l / 5) * 5))).size / Math.max(sentenceLengths.length, 1) * 100) : 0
  };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 5

**English pages:** Use Flesch-Kincaid mapping (FK 60-80 = score 80-90)

**Non-English pages:** Score as N/A for FK, use sentence length only:
- Avg sentence length <15: 85
- 15-20: 80
- 20-25: 65
- >25: 50
- Sentence variety bonus: good mix of short+long = +10
- >30% long sentences (>25 words): -10

## Process

1. Extract text and language
2. Detect if English (from `<html lang="">`)
3. If English: calculate FK score, map to analysis score
4. If non-English: calculate sentence-length-only score
5. Assess sentence variety (mix of short/medium/long)
6. Flag very long sentences (>30 words)
7. Note language limitation in output

## Output

```markdown
### Readability [Score: {0-100}/100 or N/A]

| Metric | Value | Note |
|---|---|---|
| Language | {lang} | {English / Non-English} |
| Flesch-Kincaid | {score or N/A} | {grade level or "Not applicable for {lang}"} |
| Avg sentence length | {N} words | {<20 ideal} |
| Short sentences (<10 words) | {N} ({%}) | — |
| Long sentences (>25 words) | {N} ({%}) | {flag if >30%} |
| Sentence variety | {low/medium/high} | — |

Evidence: [OBSERVED: Chrome DevTools text extraction, {date}]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/readability-plugin-v2.ts`
