---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
  - mcp__chrome-devtools__navigate_page
  - mcp__chrome-devtools__evaluate_script
  - mcp__chrome-devtools__take_snapshot
  - mcp__chrome-devtools__wait_for
  - mcp__chrome-devtools__take_screenshot
---

> v1.0 — 2026-04-12
> Derived from AI Content Analyzer (ArcanianAi/ai-content-analyzer) extraction + scoring patterns

# Skill: Analyze Page (`/analyze-page`)

## Purpose

Page-level content and technical analysis using Chrome DevTools MCP. Extracts schema markup, meta tags, heading hierarchy, readability, content quality, and link structure from any URL. Scores each dimension 0-100 and generates prioritized recommendations.

**This fills the gap between "your traffic dropped" (SEO skills) and "here's what's wrong with the page" (content analysis).**

## Trigger

Use when:
- Running SEO diagnosis and need to check affected pages
- Auditing a client's website for technical SEO
- Checking schema/structured data completeness
- Analyzing content quality before/after updates
- Comparing own page vs competitor page
- User says `/analyze-page <URL>`

## Input

| Input | Required | Example | Default |
|---|---|---|---|
| `url` | Yes | `https://example.com/product/123` | — |
| `--client` | No | `solarnook` | Current project slug |
| `--focus` | No | `schema`, `meta`, `content`, `all` | `all` |

## Prerequisites

1. **Chrome DevTools MCP must be connected.** If not → STOP. Tell the user.
2. If `--client` specified, load `CLIENT_CONFIG.md` and `DOMAIN_CHANNEL_MAP.md` for context.

## Process

### Step 1: Navigate & Load Page

```
navigate_page(type: "url", url: "<URL>")
wait_for(event: "networkIdle", timeout: 15000)
```

If navigation fails → report error, suggest checking URL validity.

### Step 2: Extract Page Data

Run all extractions via `evaluate_script`. Each extraction is a single JavaScript expression.

#### 2a. Schema / JSON-LD

```javascript
evaluate_script: `
(() => {
  const scripts = document.querySelectorAll('script[type="application/ld+json"]');
  const schemas = [];
  scripts.forEach(s => {
    try { schemas.push(JSON.parse(s.textContent)); } catch(e) { schemas.push({error: e.message, raw: s.textContent.substring(0, 200)}); }
  });
  return JSON.stringify({
    count: schemas.length,
    types: schemas.map(s => s['@type'] || (Array.isArray(s['@graph']) ? s['@graph'].map(g => g['@type']) : 'unknown')).flat(),
    schemas: schemas
  });
})()
`
```

#### 2b. Meta Tags

```javascript
evaluate_script: `
(() => {
  const title = document.title || '';
  const desc = document.querySelector('meta[name="description"]')?.content || '';
  const canonical = document.querySelector('link[rel="canonical"]')?.href || '';
  const robots = document.querySelector('meta[name="robots"]')?.content || '';
  const lang = document.documentElement.lang || '';
  const og = {};
  document.querySelectorAll('meta[property^="og:"]').forEach(m => og[m.getAttribute('property')] = m.content);
  const twitter = {};
  document.querySelectorAll('meta[name^="twitter:"]').forEach(m => twitter[m.getAttribute('name')] = m.content);
  const viewport = document.querySelector('meta[name="viewport"]')?.content || '';
  const charset = document.querySelector('meta[charset]')?.getAttribute('charset') || document.querySelector('meta[http-equiv="Content-Type"]')?.content || '';
  return JSON.stringify({ title, titleLength: title.length, desc, descLength: desc.length, canonical, robots, lang, og, twitter, viewport, charset });
})()
`
```

#### 2c. Heading Hierarchy

```javascript
evaluate_script: `
(() => {
  const headings = [];
  document.querySelectorAll('h1,h2,h3,h4,h5,h6').forEach(h => {
    headings.push({ level: parseInt(h.tagName[1]), text: h.textContent.trim().substring(0, 120) });
  });
  return JSON.stringify({
    count: headings.length,
    h1Count: headings.filter(h => h.level === 1).length,
    headings: headings
  });
})()
`
```

#### 2d. Content Metrics

```javascript
evaluate_script: `
(() => {
  const text = document.body.innerText || '';
  const words = text.split(/\s+/).filter(w => w.length > 0);
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const paragraphs = document.querySelectorAll('p');
  const avgSentenceLength = sentences.length > 0 ? words.length / sentences.length : 0;
  const avgWordLength = words.length > 0 ? words.join('').length / words.length : 0;
  // Flesch-Kincaid approximation (syllables ≈ vowel groups)
  const syllables = words.reduce((sum, w) => sum + (w.match(/[aeiouy]+/gi) || []).length, 0);
  const fleschKincaid = words.length > 0 && sentences.length > 0 ? 206.835 - 1.015 * (words.length / sentences.length) - 84.6 * (syllables / words.length) : 0;
  return JSON.stringify({
    wordCount: words.length,
    sentenceCount: sentences.length,
    paragraphCount: paragraphs.length,
    avgSentenceLength: Math.round(avgSentenceLength * 10) / 10,
    avgWordLength: Math.round(avgWordLength * 10) / 10,
    readingTimeMinutes: Math.ceil(words.length / 200),
    fleschKincaid: Math.round(fleschKincaid * 10) / 10
  });
})()
`
```

#### 2e. Links

```javascript
evaluate_script: `
(() => {
  const links = [];
  const currentHost = window.location.hostname;
  document.querySelectorAll('a[href]').forEach(a => {
    const href = a.href;
    try {
      const url = new URL(href);
      links.push({
        href: href.substring(0, 200),
        text: a.textContent.trim().substring(0, 80),
        isInternal: url.hostname === currentHost || url.hostname.endsWith('.' + currentHost),
        hasNofollow: a.rel?.includes('nofollow') || false,
        isNewTab: a.target === '_blank'
      });
    } catch(e) {}
  });
  const internal = links.filter(l => l.isInternal).length;
  const external = links.filter(l => !l.isInternal).length;
  return JSON.stringify({ total: links.length, internal, external, nofollow: links.filter(l => l.hasNofollow).length, links: links.slice(0, 50) });
})()
`
```

#### 2f. Images

```javascript
evaluate_script: `
(() => {
  const images = [];
  document.querySelectorAll('img').forEach(img => {
    images.push({
      src: (img.src || '').substring(0, 200),
      alt: img.alt || '',
      hasAlt: img.alt !== '',
      width: img.naturalWidth || img.width || 0,
      height: img.naturalHeight || img.height || 0,
      loading: img.loading || 'eager'
    });
  });
  const withAlt = images.filter(i => i.hasAlt).length;
  const withLazyLoad = images.filter(i => i.loading === 'lazy').length;
  return JSON.stringify({ total: images.length, withAlt, withoutAlt: images.length - withAlt, withLazyLoad, images: images.slice(0, 30) });
})()
`
```

### Step 3: Score Each Dimension

#### Schema Score (0-100)
Based on AI Content Analyzer `schema-plugin-v2.ts` scoring:
- **No schemas found:** 20/100
- **Base:** 50 + (schema_count × 5, max 25)
- **Type diversity bonus:** 3+ types = +10, 2+ types = +5
- **Required types for page context:**
  - Product page → needs `Product` schema
  - Article/blog → needs `Article` or `BlogPosting`
  - FAQ page → needs `FAQPage`
  - Homepage → needs `Organization` or `WebSite`
  - Any page → `BreadcrumbList` is a bonus
- **Deductions:** Invalid JSON-LD = -15, missing `@context` = -10

#### Meta Tags Score (0-100)
Based on AI Content Analyzer `meta-tags-plugin-v2.ts` scoring:
- **Title (0-25):** exists = +15, length 50-60 chars = +10
- **Description (0-20):** exists = +10, length 150-160 chars = +10
- **OpenGraph (0-20):** og:title + og:description + og:image = full score
- **Twitter Card (0-15):** twitter:card + twitter:title = full score
- **Canonical (0-5):** exists = +5
- **Language (0-3):** exists + valid = +3
- **Robots (0-2):** exists = +2
- **Viewport (0-5):** exists = +5
- **Charset (0-5):** exists = +5

#### Heading Hierarchy Score (0-100)
- **Single H1:** exactly 1 = +30, 0 = 0, >1 = +10 (penalty)
- **H1 content quality:** >3 words = +10, contains likely keyword = +5
- **Logical nesting:** no skipped levels (H1→H3 without H2) = +20, each skip = -10
- **Heading count:** 3-15 = +15, too few (<3) = +5, too many (>20) = +5
- **Heading depth:** uses H2+H3 = +10, only H1+H2 = +5
- **No empty headings:** all have text = +10

#### Content Quality Score (0-100)
- **Word count:**
  - Product page: 300-1000 = optimal (+30)
  - Blog/article: 800-2500 = optimal (+30)
  - Landing page: 500-1500 = optimal (+30)
  - Too thin (<200): +5
  - Too long (>5000): +20
- **Paragraph structure:** >5 paragraphs = +15, >10 = +20
- **Content-to-code ratio:** estimated from word count vs page weight

#### Readability Score (0-100)
Based on Flesch-Kincaid:
- **FK 60-80 (easy to read):** 90-100
- **FK 50-60 (fairly easy):** 70-90
- **FK 30-50 (difficult):** 50-70
- **FK <30 (very difficult):** 30-50
- **Sentence length adjustment:** avg <20 words = +5, >25 words = -10
- **Reading time:** shown but not scored

#### Technical HTML Score (0-100)
- **Semantic elements:** uses `<main>`, `<nav>`, `<article>`, `<section>`, `<header>`, `<footer>` = +5 each (max 30)
- **Image alt coverage:** 100% = +20, >80% = +15, >50% = +10
- **Lazy loading:** images use `loading="lazy"` = +10
- **Link health:** no empty hrefs = +10, reasonable internal/external ratio = +10
- **Viewport meta:** exists = +10
- **Charset:** defined = +10

### Step 4: Generate Findings

For each dimension scoring below 70, generate a finding with:
- Evidence tag: `[OBSERVED: Chrome DevTools, {date}]`
- Specific issue description
- Recommended fix
- Priority: P0 (score <30), P1 (score <50), P2 (score <70)

### Step 5: Save Output

Auto-save to `clients/{slug}/docs/PAGE_ANALYSIS_{url-slug}_{date}.md`

If no `--client` specified, save to current project docs/ or print to conversation.

## Output Format

```markdown
---
type: page-analysis
url: "{URL}"
date: "YYYY-MM-DD"
client: "{slug}"
confidence: {overall confidence}
---

# Page Analysis: {URL}

> v1.0 — {date}

## BLUF

{1-2 sentence summary. What's strong, what needs attention, overall grade.}

## Scores

| Dimension | Score | Status | Key Issue |
|---|---|---|---|
| Schema / Structured Data | {0-100} | {Good/Needs work/Critical} | {one-liner} |
| Meta Tags | {0-100} | {status} | {one-liner} |
| Heading Hierarchy | {0-100} | {status} | {one-liner} |
| Content Quality | {0-100} | {status} | {one-liner} |
| Readability | {0-100} | {status} | {one-liner} |
| Technical HTML | {0-100} | {status} | {one-liner} |
| **Overall** | **{weighted avg}** | **{status}** | |

Status thresholds: ≥80 Good, ≥60 Needs work, <60 Critical

## Schema Analysis

**Types found:** {list}
**JSON-LD blocks:** {count}

{Details per schema: type, fields present, fields missing, validity}

Evidence: [OBSERVED: Chrome DevTools JSON-LD extraction, {date}]

## Meta Tags

| Tag | Value | Status |
|---|---|---|
| Title | "{value}" ({length} chars) | {OK / Too short / Too long / Missing} |
| Description | "{value}" ({length} chars) | {status} |
| Canonical | {value} | {status} |
| OG Tags | {count present}/{count expected} | {status} |
| Twitter Cards | {present/missing} | {status} |
| Viewport | {present/missing} | {status} |
| Language | {value} | {status} |

## Heading Structure

```
{H1-H6 tree displayed as indented list}
```

Issues: {list any problems — multiple H1s, skipped levels, empty headings}

## Content Metrics

| Metric | Value | Benchmark |
|---|---|---|
| Word count | {N} | {range for page type} |
| Sentences | {N} | — |
| Paragraphs | {N} | — |
| Avg sentence length | {N} words | <20 ideal |
| Reading time | {N} min | — |
| Flesch-Kincaid | {score} | 60-80 ideal |
| Readability grade | {grade level} | — |

## Link Analysis

| Type | Count |
|---|---|
| Internal links | {N} |
| External links | {N} |
| Nofollow links | {N} |

## Image Analysis

| Metric | Value |
|---|---|
| Total images | {N} |
| With alt text | {N} ({%}) |
| Without alt text | {N} ({%}) |
| Lazy loaded | {N} ({%}) |

## Recommendations

| # | Category | Issue | Fix | Priority | Evidence |
|---|---|---|---|---|---|
| 1 | {category} | {what's wrong} | {how to fix} | {P0/P1/P2} | [OBSERVED: {source}] |

## Ontology

- Client: {slug}
- Domain: {domain}
- Layer: L5 (Channels — content/technical)
- Skill: /analyze-page
```

## Scoring Weights (Overall Score)

| Dimension | Weight | Why |
|---|---|---|
| Schema | 15% | Important for rich results but not all pages need it |
| Meta Tags | 25% | Critical for CTR and social sharing |
| Heading Hierarchy | 15% | Important for SEO and accessibility |
| Content Quality | 20% | Core page value |
| Readability | 10% | User experience |
| Technical HTML | 15% | Accessibility and crawlability |

## Integration with Other Skills

- `/seo-diagnose` → after identifying affected pages, run `/analyze-page` on top URLs
- `/seo-decay` → check content quality on decaying pages
- `/seo-gaps` → analyze competitor pages for gap queries
- `/measurement-audit` Phase 0 → validate schema markup
- `/analyze-copy` → add readability metrics to belief marker analysis

## What NOT to Do

- Don't use Firecrawl — Chrome DevTools MCP is more powerful and free
- Don't analyze pages without Chrome MCP connected
- Don't score pages without context (product page ≠ blog post thresholds)
- Don't generate recommendations without evidence tags
