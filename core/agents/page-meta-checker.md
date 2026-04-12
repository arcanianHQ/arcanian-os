---
id: page-meta-checker
name: "Meta Tags Checker"
focus: "L5 — Title, description, OG, Twitter Cards, canonical"
context: [technical]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: technical
weight: 0.25
---

# Agent: Meta Tags Checker

## Purpose

Extracts and evaluates all meta tags from a web page. Scores title optimization, description quality, OpenGraph completeness, Twitter Card presence, and technical meta tags (canonical, viewport, charset, language, robots).

## Extraction

```javascript
() => {
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
  return { title, titleLength: title.length, desc, descLength: desc.length, canonical, robots, lang, og, twitter, viewport, charset };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 2

- Title: 25 points (exists + optimal length)
- Description: 20 points (exists + optimal length)
- OpenGraph: 20 points (proportional to tags present)
- Twitter Cards: 15 points (card + title + description + image)
- Canonical: 5 points
- Viewport: 5 points
- Charset: 5 points
- Language: 3 points
- Robots: 2 points

## Process

1. Extract all meta data
2. Check title: exists, length 50-60 chars, not generic
3. Check description: exists, length 150-160 chars, not truncated
4. Check OG tags: og:title, og:description, og:image, og:url, og:type
5. Check Twitter: twitter:card, twitter:title, twitter:description, twitter:image
6. Check technical: canonical, viewport, charset, lang, robots
7. Score each component
8. Generate recommendations for missing/poor tags

## Output

```markdown
### Meta Tags [Score: {0-100}/100]

| Tag | Value | Status |
|---|---|---|
| Title | "{value}" ({length} chars) | {OK/Too short/Too long/Missing} |
| Description | "{value}" ({length} chars) | {status} |
| Canonical | {value} | {status} |
| OG Tags | {count}/{expected} | {status} |
| Twitter Cards | {present/missing} | {status} |
| Viewport | {present/missing} | {status} |
| Language | {value} | {status} |

Evidence: [OBSERVED: Chrome DevTools meta extraction, {date}]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/meta-tags-plugin-v2.ts`
