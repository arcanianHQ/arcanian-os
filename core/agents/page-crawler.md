---
id: page-crawler
name: "Page Crawler"
focus: "L5 — Page content extraction with bot-protection bypass"
context: [technical]
data: [chrome-devtools, firecrawl]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.00
---

# Agent: Page Crawler

## Purpose

Extracts page content for analysis. Tries Chrome DevTools MCP first (fastest, free). If blocked by Cloudflare/bot protection (detected by "Just a moment..." or empty content), falls back to Firecrawl API.

This agent is NOT a scorer — it's the extraction layer that feeds data to page analysis agents.

## Detection: Is the page bot-blocked?

After Chrome DevTools extraction, check for these signals:
- Title is "Just a moment..." or "Attention Required"
- H1 contains "verify" or "connection needs to be verified"
- Word count < 50 (page didn't render)
- No schema/meta tags extracted (Cloudflare intercept page has none)
- Body text contains "Enable JavaScript and cookies" or "Checking your browser"

If ANY of these are true → page is bot-blocked → use Firecrawl.

## Method 1: Chrome DevTools MCP (default)

```
navigate_page(url, timeout: 15000)
wait_for(event: "networkIdle", timeout: 10000)
evaluate_script(extraction function)
```

Extraction function — all-in-one for all page analysis agents:

```javascript
() => {
  // Schema
  const scripts = document.querySelectorAll('script[type="application/ld+json"]');
  const schemas = [];
  scripts.forEach(s => { try { schemas.push(JSON.parse(s.textContent)); } catch(e) {} });
  // Meta
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
  const charset = document.querySelector('meta[charset]')?.getAttribute('charset') || '';
  // Headings
  const headings = [];
  document.querySelectorAll('h1,h2,h3,h4,h5,h6').forEach(h => {
    headings.push({ level: parseInt(h.tagName[1]), text: h.textContent.trim().substring(0, 120) });
  });
  // Content
  const text = document.body.innerText || '';
  const words = text.split(/\s+/).filter(w => w.length > 0);
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const paragraphs = document.querySelectorAll('p');
  // Links
  const currentHost = window.location.hostname;
  let internalLinks = 0, externalLinks = 0, nofollowLinks = 0;
  document.querySelectorAll('a[href]').forEach(a => {
    try {
      const url = new URL(a.href);
      if (url.hostname === currentHost || url.hostname.endsWith('.' + currentHost)) internalLinks++;
      else externalLinks++;
      if (a.rel?.includes('nofollow')) nofollowLinks++;
    } catch(e) {}
  });
  // Images
  const imgs = document.querySelectorAll('img');
  let imgTotal = imgs.length, imgWithAlt = 0, imgLazy = 0;
  imgs.forEach(i => { if (i.alt) imgWithAlt++; if (i.loading === 'lazy') imgLazy++; });
  // Semantic
  const semantic = {
    main: !!document.querySelector('main'), nav: !!document.querySelector('nav'),
    article: !!document.querySelector('article'), section: !!document.querySelector('section'),
    header: !!document.querySelector('header'), footer: !!document.querySelector('footer')
  };
  return {
    source: 'chrome-devtools',
    schema: { count: schemas.length, types: schemas.map(s => s['@type'] || 'unknown'), schemas },
    meta: { title, titleLength: title.length, desc, descLength: desc.length, canonical, robots, lang, og, twitter, viewport, charset },
    headings: { count: headings.length, h1Count: headings.filter(h => h.level === 1).length, list: headings },
    content: { wordCount: words.length, sentenceCount: sentences.length, paragraphCount: paragraphs.length,
      avgSentenceLength: sentences.length > 0 ? Math.round(words.length / sentences.length * 10) / 10 : 0 },
    links: { internal: internalLinks, external: externalLinks, nofollow: nofollowLinks },
    images: { total: imgTotal, withAlt: imgWithAlt, withoutAlt: imgTotal - imgWithAlt, lazy: imgLazy },
    semantic
  };
}
```

## Method 2: Firecrawl MCP (fallback)

When Chrome DevTools is bot-blocked, use Firecrawl MCP tools. Firecrawl renders JavaScript, bypasses bot protection (Cloudflare, etc.), and returns full page content.

**Setup:** Add to `.mcp.json` (session restart required):
```json
{
  "firecrawl": {
    "command": "npx",
    "args": ["-y", "firecrawl-mcp"],
    "env": {
      "FIRECRAWL_API_KEY": "fc-YOUR_KEY"
    }
  }
}
```

### Single page: `firecrawl_scrape`

```
firecrawl_scrape(url: "<URL>", formats: ["html", "markdown"])
```

Returns: `{ html, markdown, metadata }`. Parse the HTML for:
- JSON-LD: extract all `<script type="application/ld+json">` blocks
- Meta tags: title, description, OG, Twitter from `metadata` object
- Headings: regex or parse `<h1>` through `<h6>` from HTML
- Images: parse `<img>` tags for alt, src, loading attributes
- Links: parse `<a>` tags for href, rel attributes
- Word count: from markdown (cleaner text)

### Bulk pages: `firecrawl_batch`

For analyzing multiple pages (e.g., all product pages):

```
firecrawl_batch(urls: ["<URL1>", "<URL2>", ...], formats: ["html", "markdown"])
```

Returns a job ID. Poll with `firecrawl_batch_status(id)` until complete. Perfect for analyzing all product/category pages in one call.

### Structured extraction: `firecrawl_extract`

For pulling specific structured data with a schema:

```
firecrawl_extract(url: "<URL>", schema: {
  "title": "string",
  "price": "string",
  "description": "string",
  "features": ["string"],
  "images_count": "number"
})
```

Returns structured data matching the schema. Good for product page comparison.

### Full site map: `firecrawl_map`

Discover all URLs on a site without scraping:

```
firecrawl_map(url: "https://example.com")
```

Returns sitemap of all discovered URLs. Use before batch to get the full URL list.

## Fallback Chain

```
1. Chrome DevTools MCP (best: full JS rendering, DOM access, free)
   ↓ if bot-blocked (Cloudflare, Shopify protection, etc.)
2. Firecrawl MCP (good: renders JS, bypasses protection, costs credits)
   ↓ if Firecrawl MCP not connected
3. curl + user-agent (minimal: static HTML only, misses dynamic content)
```

### curl (last resort)

```bash
curl -sL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" "<URL>"
```

Parse raw HTML with grep. Won't execute JavaScript — misses dynamic content. Use only when both Chrome DevTools and Firecrawl are unavailable.

## Output

All three methods produce the same output structure — the unified extraction object consumed by all page-*-checker agents. The `source` field indicates which method was used:
- `source: 'chrome-devtools'`
- `source: 'firecrawl'`
- `source: 'curl'`

Downstream agents adjust confidence based on source:
- Chrome DevTools: full confidence
- Firecrawl: full confidence (renders JS)
- curl: reduced confidence (may miss dynamic content)

## Integration

Update `/analyze-page` skill Step 1:
```
1. Try Chrome DevTools → extract
2. Check for bot-block signals
3. If blocked → try Firecrawl → extract
4. If no API key → try curl → extract
5. Pass extraction to page analysis council
```

## References
- Firecrawl API: https://docs.firecrawl.dev/api-reference/endpoint/scrape
- AI Content Analyzer: `services/enhanced-firecrawl-service.ts`
