---
scope: shared
context: fork
argument-hint: client slug
---

# Skill: Competitor Monitor (`/competitor-monitor`)

## Architecture

This skill uses the competitor-monitor council (`core/agents/councils/competitor-monitor.yaml`).
Pipeline: 3 analysis agents parallel → digest synthesizer.

Agents:
- `competitor-blog-monitor` (Sonnet) — crawl competitor blogs, summarize posts, extract content strategy
- `competitor-page-watcher` (Sonnet) — scrape key pages, diff against stored snapshots, classify changes
- `competitor-seo-gap-agent` (Sonnet) — keyword/content gap analysis (Firecrawl or SEMrush)
- `competitor-digest-synthesizer` (Sonnet, chairman) — compile, deduplicate, score, prioritize

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

Monitor 3-5 configured competitors per client across three dimensions:
1. **Blog/content activity** — what are they publishing? What topics and keywords are they targeting?
2. **Key page changes** — did their homepage, pricing, services, or about page change? What shifted?
3. **SEO gaps** — what keywords do they rank for that we don't? Where should we create content?

Produces a prioritized digest with confidence-scored findings and actionable recommendations.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct competitor set per domain. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

## Trigger

Use this skill when:
- Weekly scheduled run (Friday 14:00 — see `core/skills/scheduled-workflows.md`)
- Client asks "what are competitors doing?"
- Before content strategy planning or quarterly review
- Competitor just launched a new product or campaign
- After `/seo-gaps` identifies competitor-dominated keywords
- New competitor enters the market

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context or argument |
| `brand/COMPETITIVE_LANDSCAPE.md` | Yes | Client directory — competitor list + monitored pages |
| `CLIENT_CONFIG.md` | Yes | Client directory — domain, context |
| `DOMAIN_CHANNEL_MAP.md` | If multi-domain | Client directory |
| Firecrawl MCP | Yes | Connected MCP server |
| SEMrush MCP | Optional | Connected MCP server — enriches gap analysis |

## Data Sources

### Firecrawl-Only Mode (Minimum)
Without SEMrush, the system still provides:
- **Blog monitoring:** Full capability — crawl, summarize, extract keyword themes
- **Page change detection:** Full capability — fingerprint-based diffing
- **SEO gaps:** Inferred from page content analysis — keyword themes competitors emphasize that we don't cover. Confidence: LOW-MED. Tagged `[INFERRED]`.

### Enriched Mode (+ SEMrush MCP)
- **SEO gaps:** Actual keyword ranking data — competitor ranks top 10, we don't. Search volume + difficulty. Confidence: HIGH. Tagged `[DATA]`.
- Blog monitoring and page change detection are identical in both modes (Firecrawl-powered).

## Execution Steps

1. **Pre-flight — Load config:**
   - Read `CLIENT_CONFIG.md` — get client domain, context
   - Read `brand/COMPETITIVE_LANDSCAPE.md` — get competitor list, monitored pages, schedule config
   - If `COMPETITIVE_LANDSCAPE.md` does NOT exist → **STOP.** Output: "Create `brand/COMPETITIVE_LANDSCAPE.md` using template: `core/templates/COMPETITIVE_LANDSCAPE_TEMPLATE.md`"
   - If multi-domain: load `DOMAIN_CHANNEL_MAP.md`, select correct competitor set

2. **Check MCP availability:**
   - Firecrawl MCP connected? → Required. If not: STOP with error.
   - SEMrush MCP connected? → Optional. Log mode: "Firecrawl-only" or "Firecrawl + SEMrush"

3. **Run competitor-monitor council** (3 agents in parallel):
   - Spawn `competitor-blog-monitor` (Sonnet) — pass competitor blog URLs + lookback window
   - Spawn `competitor-page-watcher` (Sonnet) — pass competitor page URLs + snapshot directory path
   - Spawn `competitor-seo-gap-agent` (Sonnet) — pass competitor domains + SEMrush availability flag

4. **Synthesis** — `competitor-digest-synthesizer` (Sonnet) compiles all three outputs into digest.

5. **Auto-save digest:**
   - Save to `clients/{slug}/data/competitor/digest-{YYYY-MM-DD}.md`
   - Open file: `core/scripts/ops/open-file.sh "{path}"`

6. **Task creation** — if synthesizer flags HIGH-priority findings (confidence >= 0.5):
   - Create task in `TASKS.md` with proper format
   - Sync to Todoist

7. **Append to monitoring log:**
   - Append run summary to `clients/{slug}/data/MONITOR_LOG.md`
   - Format: `| {date} | /competitor-monitor | {N} competitors | {N} findings | {notes} |`

## Output Template

Uses `core/templates/COMPETITOR_MONITOR_DIGEST_TEMPLATE.md`.

## Auto-Save

Save output to: `clients/{slug}/data/competitor/digest-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

Snapshots stored at: `clients/{slug}/data/competitor/snapshots/{competitor-slug}/{page-slug}.md`

## Graceful Degradation

| Condition | Behavior |
|-----------|---------|
| Firecrawl not connected | STOP — "Firecrawl MCP required. Connect it via .mcp.json." |
| SEMrush not connected | Continue in Firecrawl-only mode. Log mode. Gap analysis = `[INFERRED]`. |
| Competitor blocks crawler | Log `[OBSERVED: blocked, {date}]`. Skip that competitor. Continue with others. Note in digest. |
| No blog found at URL | Skip blog monitor for that competitor. Note in digest. |
| First run (no snapshots) | Write initial snapshots. No change report. Note: "Baselines established." |
| `COMPETITIVE_LANDSCAPE.md` missing | STOP — scaffold instruction. |
| `--competitor slug` argument | Run for single competitor only (useful for ad-hoc checks). |
| `--mode blog\|pages\|gaps` argument | Run only one analysis track (useful for focused checks). |

## Notes

- **Pairs with:** `/seo-gaps` (deep keyword gap analysis), `/seo-diagnose` (competitor gain hypothesis), `/seo-narrative` (include competitive findings in monthly report), `/client-report` (competitive section)
- **First run:** Always run manually once after setting up `COMPETITIVE_LANDSCAPE.md` to establish baseline snapshots. The scheduled agent picks it up after that.
- **Snapshot storage:** Snapshots accumulate but are overwritten per page (only latest state + change log). No unbounded growth.
- **Model routing:** All agents T2 Sonnet — content analysis and pattern recognition, not deep causal reasoning.
- **Web tool routing:** Firecrawl for all scraping. Never `firecrawl_search`. Research queries (if needed) use WebSearch.
