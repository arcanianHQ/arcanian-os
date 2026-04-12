---
id: page-html-checker
name: "Technical HTML Checker"
focus: "L5 — Semantic elements, images, links, accessibility basics"
context: [technical]
data: [chrome-devtools]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: technical
weight: 0.15
---

# Agent: Technical HTML Checker

## Purpose

Evaluates technical HTML quality: semantic element usage, image optimization (alt text, lazy loading), link health, and basic accessibility. Focuses on crawlability and user experience signals.

## Extraction

```javascript
() => {
  // Images
  const images = [];
  document.querySelectorAll('img').forEach(img => {
    images.push({
      src: (img.src || '').substring(0, 200),
      alt: img.alt || '',
      hasAlt: img.alt !== '' && img.alt !== undefined,
      loading: img.loading || 'eager',
      width: img.naturalWidth || img.width || 0,
      height: img.naturalHeight || img.height || 0
    });
  });
  // Links
  const links = [];
  const currentHost = window.location.hostname;
  document.querySelectorAll('a[href]').forEach(a => {
    try {
      const url = new URL(a.href);
      links.push({
        isInternal: url.hostname === currentHost || url.hostname.endsWith('.' + currentHost),
        hasNofollow: a.rel?.includes('nofollow') || false,
        isEmpty: !a.textContent.trim() && !a.querySelector('img')
      });
    } catch(e) {}
  });
  // Semantic elements
  const semantic = {
    hasMain: !!document.querySelector('main'),
    hasNav: !!document.querySelector('nav'),
    hasArticle: !!document.querySelector('article'),
    hasSection: !!document.querySelector('section'),
    hasHeader: !!document.querySelector('header'),
    hasFooter: !!document.querySelector('footer')
  };
  // Viewport + charset
  const viewport = !!document.querySelector('meta[name="viewport"]');
  const charset = !!document.querySelector('meta[charset]') || !!document.querySelector('meta[http-equiv="Content-Type"]');
  return {
    images: { total: images.length, withAlt: images.filter(i => i.hasAlt).length, withoutAlt: images.filter(i => !i.hasAlt).length, withLazyLoad: images.filter(i => i.loading === 'lazy').length, details: images.slice(0, 20) },
    links: { total: links.length, internal: links.filter(l => l.isInternal).length, external: links.filter(l => !l.isInternal).length, nofollow: links.filter(l => l.hasNofollow).length, empty: links.filter(l => l.isEmpty).length },
    semantic: semantic,
    viewport: viewport,
    charset: charset
  };
}
```

## Scoring

Reference: `core/methodology/PAGE_ANALYSIS_SCORING.md` → Section 6

- Semantic elements: 30 points (+5 per element, max 6)
- Image alt coverage: 20 points (100% = 20, >80% = 15, >50% = 10)
- Lazy loading: 10 points (>50% = 10, >25% = 7, 0% = 3)
- Link health: 15 points (no empty = 5, good internal count = 5, externals exist = 5)
- Viewport: 10 points
- Charset: 10 points

## Process

1. Extract images, links, semantic elements, viewport, charset
2. Score semantic HTML (which elements present?)
3. Score image optimization (alt coverage + lazy loading)
4. Score link health (internal/external ratio, empty links, nofollow misuse)
5. Check viewport and charset
6. Flag specific issues with image-level detail
7. Generate recommendations

## Output

```markdown
### Technical HTML [Score: {0-100}/100]

**Semantic Elements:**
| Element | Present |
|---|---|
| `<main>` | {Yes/No} |
| `<nav>` | {Yes/No} |
| `<article>` | {Yes/No} |
| `<section>` | {Yes/No} |
| `<header>` | {Yes/No} |
| `<footer>` | {Yes/No} |

**Images:** {total} total, {withAlt} with alt ({%}), {withLazyLoad} lazy loaded ({%})
**Links:** {internal} internal, {external} external, {nofollow} nofollow, {empty} empty

**Issues:**
| # | Issue | Severity | Detail |
|---|---|---|---|

Evidence: [OBSERVED: Chrome DevTools HTML extraction, {date}]
```

## References
- `core/methodology/PAGE_ANALYSIS_SCORING.md`
- AI Content Analyzer: `plugins/html-validity-plugin-v2.ts`
