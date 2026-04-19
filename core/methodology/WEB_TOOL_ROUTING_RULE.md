---
scope: shared
---

# Web Tool Routing: Firecrawl vs Built-in

> v1.0 — 2026-04-14

## Rule

**Firecrawl = scraping. Built-in WebSearch/WebFetch = searching. No crossover.**

This is a HARD routing rule — not a suggestion.

## Why

Firecrawl is a scraping/crawling engine optimized for extracting content from known URLs. Using it for web search wastes an MCP round-trip and produces worse results than the built-in search. Conversely, built-in WebFetch can fetch pages but Firecrawl handles complex sites (JS-rendered, paginated, structured extraction) far better.

Clear separation prevents tool confusion, reduces latency, and keeps MCP budget for what each tool does best.

## Routing Table

| Intent | Tool | Examples |
|--------|------|---------|
| **Find information on the web** | `WebSearch` | "what is X", research a topic, find competitors, look up documentation |
| **Fetch a known URL for reading** | `WebFetch` | Read a specific docs page, check a known blog post, verify a URL |
| **Scrape page content / extract structured data** | `firecrawl_scrape` | Pull article text, extract product data, get page HTML |
| **Crawl a site (multiple pages)** | `firecrawl_crawl` | Map a site structure, pull all blog posts, index all product pages |
| **Extract structured data from a page** | `firecrawl_extract` | Pull pricing tables, contact info, specific data fields |
| **Map all URLs on a site** | `firecrawl_map` | Discover all pages, build a sitemap, find all product URLs |
| **Search + scrape combo** | `WebSearch` then `firecrawl_scrape` | Find a page via search, then scrape its content deeply |

## Behavior

### When you need to SEARCH (find pages, research, discover):
1. Use `WebSearch` — this is the built-in web search tool
2. If you need to read a result in detail, use `WebFetch` for simple pages or `firecrawl_scrape` for complex/JS-rendered pages
3. **NEVER** use `firecrawl_search` as a substitute for `WebSearch`

### When you need to SCRAPE (extract content from a known URL):
1. Use `firecrawl_scrape` for single pages
2. Use `firecrawl_crawl` for multi-page extraction
3. Use `firecrawl_extract` for structured data extraction
4. Use `firecrawl_map` to discover URLs before crawling
5. **NEVER** use `WebFetch` for JS-rendered or complex pages that Firecrawl handles better

### When spawning agents:
- Agents doing **research** (competitor analysis, market research, documentation lookup) → instruct them to use `WebSearch`/`WebFetch`
- Agents doing **site analysis** (SEO audit, content extraction, site mapping) → instruct them to use Firecrawl tools
- **Always specify which tools** in the agent prompt — don't let agents default

## Applies To

All skills, agents, and manual operations that touch the web:
- `/seo-diagnose`, `/seo-gaps`, `/seo-decay`, `/seo-cannibalize`, `/seo-anomaly`, `/seo-narrative`
- `/client-explorer`, `/extract-platforms`, `/extract-contacts`
- `/analyze-gtm`, `/build-brand`, copy-analysis runs
- `/competitor-monitor`
- `/validate-idea`, `/plan-gtm`, `/verify-pmf`
- All channel-analyst agents, client-explorer agent
- Any ad-hoc web research or scraping task
