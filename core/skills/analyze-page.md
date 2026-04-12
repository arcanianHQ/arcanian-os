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
  - Agent
  - mcp__chrome-devtools__navigate_page
  - mcp__chrome-devtools__evaluate_script
  - mcp__chrome-devtools__take_snapshot
  - mcp__chrome-devtools__wait_for
  - mcp__chrome-devtools__take_screenshot
  - mcp__firecrawl__firecrawl_scrape
  - mcp__firecrawl__firecrawl_batch
  - mcp__firecrawl__firecrawl_batch_status
  - mcp__firecrawl__firecrawl_extract
  - mcp__firecrawl__firecrawl_map
---

> v2.0 — 2026-04-12
> Plugin architecture: 6 agents + page-analysis council. Derived from AI Content Analyzer patterns.
> v1.0 was monolithic — v2.0 uses composable agents via council runner.

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

## Architecture

This skill uses the **page-analysis council** (`core/agents/councils/page-analysis.yaml`) which orchestrates 6 specialized agents:

| Agent | Category | Weight | What it checks |
|---|---|---|---|
| `page-schema-checker` | technical | 15% | JSON-LD, structured data completeness |
| `page-meta-checker` | technical | 25% | Title, description, OG, Twitter Cards |
| `page-heading-checker` | semantic | 15% | H1-H6 hierarchy, nesting |
| `page-content-checker` | content | 20% | Word count, paragraph structure (also chairman) |
| `page-readability-checker` | content | 10% | Flesch-Kincaid, sentence length |
| `page-html-checker` | technical | 15% | Semantic HTML, images, links |

Scoring rubrics: `core/methodology/PAGE_ANALYSIS_SCORING.md`

## Process

### Step 1: Extract Page Data (with fallback)

Uses the `page-crawler` agent's fallback chain:

**Try Chrome DevTools first:**
```
navigate_page(type: "url", url: "<URL>")
wait_for(event: "networkIdle", timeout: 15000)
evaluate_script(extraction function from page-crawler agent)
```

**Check for bot-block signals:**
- Title is "Just a moment..." or contains "verify"
- Word count < 50
- No schema or meta tags extracted

**If bot-blocked → use Firecrawl MCP:**
```
firecrawl_scrape(url: "<URL>", formats: ["html", "markdown"])
```
Parse the returned HTML for schema, meta, headings, images, links. Use markdown for word count.

**For bulk analysis (multiple pages):**
```
firecrawl_map(url: "https://example.com")  → discover all URLs
firecrawl_batch(urls: [...], formats: ["html", "markdown"])  → scrape all at once
firecrawl_batch_status(id: "...")  → poll until complete
```

**If neither available → curl (last resort).**

### Step 2: Parse Extracted Data

Whether from Chrome DevTools or Firecrawl, parse into the unified extraction structure that all page-*-checker agents consume. See `page-crawler` agent for the extraction function and parsing logic.

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

### Step 3: Run Page Analysis Council

Spawn all 6 agents in parallel (single message, multiple Agent tool calls). Each agent:
1. Receives the extracted data relevant to its dimension
2. Scores using rubrics from `core/methodology/PAGE_ANALYSIS_SCORING.md`
3. Returns: score (0-100), issues found, recommendations

```
Agent(page-schema-checker, data: schema extraction)
Agent(page-meta-checker, data: meta extraction)
Agent(page-heading-checker, data: heading extraction)
Agent(page-content-checker, data: content extraction)  ← also chairman
Agent(page-readability-checker, data: content extraction)
Agent(page-html-checker, data: images + links + semantic extraction)
```

All 6 run in parallel. When done, the chairman (page-content-checker) synthesizes.

### Step 4: Synthesize (Chairman)

The chairman agent:
1. Collects all 6 scores
2. Applies weighted aggregation: `overall = technical(40%) + content(35%) + semantic(25%)`
3. If readability is N/A (non-English): redistributes weight proportionally
4. Generates BLUF (1-2 sentences: what's strong, what needs attention)
5. Compiles unified recommendation list sorted by priority (P0 → P3)
6. For each dimension scoring <70: generates a finding with evidence tag

### Step 5: Save Output

Auto-save to `clients/{slug}/docs/PAGE_ANALYSIS_{url-slug}_{date}.md`

If no `--client` specified, save to current project docs/ or print to conversation.

### Calling Individual Agents

Other skills can call a single agent without running the full council:
- `/seo-diagnose` → call `page-schema-checker` on affected URLs
- `/seo-decay` → call `page-content-checker` on decaying pages
- `/analyze-copy` → call `page-readability-checker` for metrics

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
