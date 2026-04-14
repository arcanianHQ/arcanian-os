# Web Tool Routing (GUARDRAIL — HARD RULE)

## When USING any web-facing tool (WebSearch, WebFetch, firecrawl_*):

**Firecrawl = scraping/crawling known URLs. Built-in WebSearch/WebFetch = web search and discovery.**

### SEARCH (find info, research, discover pages):
- USE: `WebSearch`, `WebFetch`
- NEVER: `firecrawl_search`

### SCRAPE (extract content from known URLs):
- USE: `firecrawl_scrape`, `firecrawl_crawl`, `firecrawl_extract`, `firecrawl_map`
- For JS-rendered or complex pages, prefer Firecrawl over `WebFetch`

### AGENTS:
- Research agents → instruct to use `WebSearch`/`WebFetch`
- Site analysis agents → instruct to use Firecrawl tools
- Always specify tool choice in agent prompt — never let agents default

Rule: `core/methodology/WEB_TOOL_ROUTING_RULE.md`
