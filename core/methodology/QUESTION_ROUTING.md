---
scope: shared
type: methodology
version: 1.0
created: 2026-04-22
---

> v1.0 — 2026-04-22

# Question Routing

> **Canonical rule** — every data question is first CLASSIFIED into a category, then ROUTED to the applicable MCP tools and data sources, and ONLY THEN queried. Routing precedes scoring. Scoring only applies to sources the routing step selected.

## Why this is its own rule

Three separate concerns were previously tangled inside data-answering skills:

1. **"What kind of question is this?"** — campaign performance, SEO, competitive, AIO, environment, task-status, etc.
2. **"Which tools / sources can actually answer it?"** — Databox accounts, SEMrush, web search, custom MCPs
3. **"How reliable are the answers once pulled?"** — variance + base ratings, per `DYNAMIC_RELIABILITY_SCORING.md`

When routing (1+2) is mixed into scoring (3), you get the failure mode where a wrong-tool source gets scored LOW instead of being excluded — suggesting it's a weak peer when it's actually a category error. This rule isolates (1) and (2) so (3) only operates on peers.

## The layered architecture

```
┌─────────────────────────────────────────────────────────┐
│  QUESTION_ROUTING.md (this rule)                        │
│  Question → Category → Applicable MCP tools + sources   │
│                       + Applicable skill owner          │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴────────────┐
         ▼                        ▼
┌──────────────────┐    ┌───────────────────┐
│ DATABOX_QUERY_   │    │ WEB_TOOL_ROUTING_ │
│ ROUTING.md       │    │ RULE.md           │
│ (within Databox: │    │ (scrape vs search │
│  ask_genie vs    │    │  vs fetch)        │
│  load_metric_    │    │                   │
│  data)           │    │                   │
└────────┬─────────┘    └─────────┬─────────┘
         │                        │
         └───────────┬────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│  DYNAMIC_RELIABILITY_SCORING.md                          │
│  After data pull: variance + base ratings → scores       │
│  (ONLY for sources the routing step selected)            │
└─────────────────────────────────────────────────────────┘
```

Routing is step ONE. Query-mechanics is step TWO (within the selected tool). Scoring is step THREE (after data arrives). Never invert the order.

## Question categories

Each category has: applicable MCP tools, applicable data sources (if Databox), the primary skill that owns it, and key question patterns.

### 1. Campaign performance

- **Patterns**: *"hogyan teljesített a kampány?"*, *"mennyit hozott az akció?"*, ad-attributed revenue, paid conversions, ROAS, spend efficiency
- **MCP tools**: `databox` (primary)
- **Data sources** (within Databox): Google Ads, GA4 (ecommerce), Meta Ads, Shopify (if present)
- **NOT applicable**: SEMrush, Google Search Console (organic-only), web scraping
- **Primary skill**: `/nexus-answer`
- **Related skills**: `/campaign` (CRUD registry), `/sales-pulse`

### 2. Organic / SEO

- **Patterns**: *"hogy áll az organikus forgalom?"*, keyword rankings, organic sessions, landing-page performance, indexation, crawl issues
- **MCP tools**: `databox` (SEMrush, GSC integrations), `firecrawl` (on-page checks)
- **Data sources**: GA4 (organic segment), SEMrush, Google Search Console
- **NOT applicable**: Google Ads / Meta Ads (paid-only)
- **Primary skills**: `/seo-diagnose`, `/seo-anomaly`, `/seo-decay`, `/seo-cluster`, `/seo-cannibalize`, `/seo-narrative`, `/seo-schema`, `/seo-gaps`

### 3. Competitive / market

- **Patterns**: *"mit csinálnak a versenytársak?"*, market share, SOV, competitor traffic, category trends
- **MCP tools**: `databox` (SEMrush competitive integrations), `WebSearch` (research)
- **Data sources**: SEMrush (primary), Similarweb (if integrated), Google Trends
- **NOT applicable**: internal paid / analytics platforms (they only see your own data)
- **Primary skills**: `/seo-diagnose` (with competitor scope), future `/competitive-scan`

### 4. AI visibility (AIO / GEO)

- **Patterns**: *"megjelenünk-e az AI Overview-ban?"*, LLM citation tracking, AI-answer presence, prompt-based visibility checks
- **MCP tools**: `databox` (if SEMrush AIO tracker configured), `WebSearch` (validation queries), custom LLM-check tools (if implemented)
- **Data sources**: SEMrush AIO module, GSC (AI-Overview impressions), custom prompt-test logs
- **NOT applicable**: traditional paid/analytics platforms
- **Primary skills**: `/geo-audit`, `/geo-visibility`, `/geo-optimize`

### 5. Environment / context

- **Patterns**: seasonality, industry benchmarks, calendar effects, regulatory context, competitive spend context
- **MCP tools**: `WebSearch`, `databox` (SEMrush environmental data)
- **Data sources**: SEMrush, Google Trends, industry-benchmark services, news sources
- **NOT applicable**: internal platforms for external context
- **Primary skill**: usually a context-layer inside another skill (e.g. Nexus Block 2 narrative mentions seasonality; no dedicated skill yet)

### 6. Task / workflow state

- **Patterns**: *"hol tartunk?"*, *"mi van TODO-n?"*, project status, deliverable progress
- **MCP tools**: `todoist`, internal TASKS.md
- **Data sources**: task manager, client-dir TASKS.md, CAPTAINS_LOG.md
- **NOT applicable**: any analytical data source
- **Primary skills**: `/tasks`, `/task-oversight`, `/pipeline`, `/day-start`, `/morning-brief`

### 7. Meta / system

- **Patterns**: *"hogy működik ez a skill?"*, *"mi van a configban?"*, system introspection, documentation lookup
- **MCP tools**: `Read`, `Grep` (local filesystem only, no external calls)
- **Primary skill**: plain chat (not a data-querying skill)

## Routing algorithm

```
1. Classify the question into exactly ONE category
   - If ambiguous between 2 categories → ask the user ONE disambiguation
   - If clearly cross-category → delegate to the broader skill that handles the primary category,
     letting it optionally reference context from the secondary

2. Look up the category's applicable MCP tools + data sources

3. Query ONLY those tools/sources
   - Sources outside the applicable list: do NOT query, do NOT score, do NOT render in result matrix

4. Hand off to the query-mechanics layer (DATABOX_QUERY_ROUTING for Databox sources,
   WEB_TOOL_ROUTING_RULE for web)

5. After data pulled: DYNAMIC_RELIABILITY_SCORING applies, but ONLY to the selected sources
```

## Hard rules

- **No autonomous cross-category queries.** A campaign-performance question does not silently trigger an SEO query just because SEMrush happens to be connected.
- **Out-of-category sources get `base_rating = 0`** and are dropped from any rendered matrix (not rendered as "low-scoring peers"). See `DYNAMIC_RELIABILITY_SCORING.md §Source applicability`.
- **Skill delegation over multi-querying.** If a question truly spans categories (e.g. *"miért esett a forgalom, csökkent az akciós teljesítményünk, és mit csinál a konkurencia?"*), the primary skill should EITHER focus on its own category and reference the others as separate follow-ups, OR call the other skills explicitly — never silently pull cross-category data and pretend it's one answer.
- **Context is not a column.** A Nexus Block 2 narrative sentence like *"SEMrush visibility -6% in the window"* is fine as context IF it was queried deliberately as context (clearly labelled). It is NEVER rendered as a peer in the Block 3 reliability matrix.

## What happens when routing fails

- **Cannot classify** (question fits no category) → the skill asks a disambiguation, does NOT default to "query everything".
- **Category has no applicable source for this client** (e.g., no SEMrush integration) → answer "this category not wired for this client", suggest next step (`/onboard-client` or specific setup).
- **Question is clearly cross-category** → name the two categories, ask the user which one they want first (not both).

## Relationship to existing routing docs

- **`DATABOX_QUERY_ROUTING.md`** — applies WITHIN Databox after routing says "query Databox". Decides `ask_genie` vs `load_metric_data` based on source type.
- **`WEB_TOOL_ROUTING_RULE.md`** — applies WITHIN web tools after routing says "query web". Decides Firecrawl (scrape known URLs) vs WebSearch/WebFetch (search/discover).
- **`DYNAMIC_RELIABILITY_SCORING.md §Source applicability`** — short pointer-section that references THIS doc. The full routing logic lives here; the scoring doc only needs to know "which sources to score".

## When to update

| Trigger | Action |
|---|---|
| New question category discovered | Add a new `§` here with patterns, tools, sources, skills |
| New MCP tool integrated | Add it to the applicable-tool list of relevant categories |
| New data source wired per client | Update the per-client DOMAIN_CHANNEL_MAP + note category applicability in client's `.nexus-config.md` |
| New skill created | Update the "Primary skill" line in the relevant category |
| Category split (e.g., "Competitive" → "Competitive-paid" + "Competitive-organic") | Rewrite the category, migrate skills |

## Related rules

- `core/methodology/DYNAMIC_RELIABILITY_SCORING.md` — downstream scoring once routing has selected sources
- `core/methodology/DATABOX_QUERY_ROUTING.md` — within-Databox query mechanics
- `core/methodology/WEB_TOOL_ROUTING_RULE.md` — Firecrawl vs WebSearch
- `core/methodology/NEXUS_CLIENT_CONFIG.md` — per-client entity/account mapping (used by routing to find applicable sources for a given client)
- `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md` — multi-domain routing (a different axis: which domain, not which category)

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-22 | Initial — extracted the "question → category → applicable sources" layer out of DYNAMIC_RELIABILITY_SCORING.md into its own canonical rule. Seven categories defined (campaign-performance, organic/SEO, competitive, AIO/GEO, environment, task/workflow, meta/system). Hard rules against autonomous cross-category queries. Positioned as the TOP routing layer with DATABOX_QUERY_ROUTING and WEB_TOOL_ROUTING as within-tool mechanics below. Caught during `/nexus-answer` test where SEMrush was scored as a low-reliability peer on Revenue / Conversions — category error masquerading as a reliability issue. |
