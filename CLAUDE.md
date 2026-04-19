> v2.2 — 2026-04-14 — Updated counts (50 skills, 13 agents, 25 SOPs, 41 methodology rules)

# Arcanian OS — System Instructions

> This is the kernel. Claude Code reads this file on session start and loads everything below.
> Customize this for your agency. The structure is the operating system; your modifications are the configuration.

## What This Is

Marketing operations system: skills (slash commands), agents (subagents), SOPs (procedures), methodology (guardrails), and templates (scaffolds) — all orchestrated by Claude Code with live data from Databox MCP.

## Architecture

```
arcanian-os/
├── CLAUDE.md                ← YOU ARE HERE — the kernel
├── core/
│   ├── skills/              ← 48 slash commands
│   ├── agents/              ← 14 agents + 4 council configs
│   ├── sops/                ← 20 standard operating procedures
│   ├── methodology/         ← 35 rules, standards, guardrails
│   ├── templates/           ← Scaffolds for client files
│   ├── infrastructure/      ← DATA_RULES, SECURITY_BLOCKLIST
│   └── reference-implementations/
├── clients/                 ← Per-client working directories
│   └── {slug}/              ← Each client is its own workspace
├── docs/                    ← Getting started, Databox setup
└── .mcp.json                ← MCP connections (Databox, task manager, etc.)
```

## Session Model

Two session types:
1. **Hub session** (`cd arcanian-os && claude`) — cross-project: /morning-brief, /health-check
2. **Client session** (`cd arcanian-os/clients/{slug} && claude`) — deep client work

**MCP is frozen at session start.** After editing `.mcp.json`, restart Claude Code.

## Task System
- **Format:** `core/methodology/TASK_FORMAT_STANDARD.md`
- Each client has `TASKS.md` (active) + `TASKS_DONE.md` (archive)
- GTD labels: @next @waiting @someday @reminder @monitor @decision @reference @milestone
- Impact: noise → hygiene → lever → unlock → breakthrough
- Layers: L0-L7

## Ontology Layer (knowledge graph)
Tasks are NODES with typed EDGES to other objects. All edges are bidirectional.
- Task ↔ Finding (FND), Recommendation (REC), SOP, Goal, Layer, Meeting, Email, Lead, Person
- `/query FND-039` — traverse the graph from any node
- Standard: `core/methodology/ONTOLOGY_STANDARD.md`
- **Enrichment:** `core/methodology/ONTOLOGY_ENRICHMENT_RULE.md` — auto-detect edges, auto-create backlinks

## Agents (core/agents/)

14 agents:
- `audit-checker.md` — measurement/tracking issue detection
- `report-reviewer.md` — quality check before client delivery
- `pii-scanner.md` — PII/secrets detection
- `data-rules-checker.md` — project compliance with DATA_RULES
- `project-architect.md` — structure validation against scaffold standard
- `client-explorer.md` — new client digital presence reconnaissance
- `knowledge-extractor.md` — post-audit pattern extraction
- `channel-analyst.md` — L4-L7 market diagnosis (generic)
- `channel-analyst-google-ads.md` — Smart Bidding, PMAX, Shopping, search terms
- `channel-analyst-meta.md` — Advantage+, creative fatigue, frequency, CAPI
- `channel-analyst-shopify.md` — GA4 discrepancy, checkout funnel, discount tracking
- `outcome-tracker.md` — weekly REC verification, closed-loop feedback

Plus 4 council configs: `councils/diagnostic.yaml`, `councils/measurement.yaml`, `councils/delivery.yaml`, `councils/discovery.yaml`

## Skills (50 slash commands)

Ops: /tasks, /scaffold-project, /validate, /preflight, /delivery-phase, /client-report, /morning-brief, /health-check, /onboard-client, /onboard-agency, /inbox-process, /task-oversight, /pipeline, /meeting-sync, /save-deliverable, /day-start, /day-end, /query, /manage-client, /extract-contacts, /extract-platforms
Diagnostic: /7layer, /7layer-hu, /council, /sales-pulse, /verify-pmf
Strategy: /build-brand, /validate-idea, /analyze-gtm, /plan-gtm
SEO & GEO: /seo-diagnose, /seo-cannibalize, /seo-gaps, /seo-decay, /seo-narrative, /seo-anomaly, /seo-cluster, /seo-schema, /geo-audit, /geo-visibility, /geo-optimize
Content: /magyar-szoveg
Platform: /arcos, /connect, /frontend-design, /okr-bluf-dokumentum, /claude-code-guide, /scheduled-workflows

## SOP Auto-Surface (ALWAYS-ON BEHAVIOR)
**Before executing any task, check if a relevant SOP exists and LOAD it.**
- email/newsletter/automation → `marketing-ops/06-email-automation.md`
- agency coordination → `marketing-ops/01-agency-coordination.md`
- tracking/measurement → `marketing-ops/04-measurement-reporting.md`
- campaign/launch/UTM → `marketing-ops/05-campaign-management.md`
- lead/contact/scoring → `marketing-ops/02-lead-lifecycle.md`
- budget/spend → `marketing-ops/03-financial-controls.md`
- access/vendor → `marketing-ops/07-vendor-access.md`
- onboard client → `arcanian/01-client-onboarding.md`

## Delivery Phases (client engagement lifecycle)
1. EXPLORE — Discovery, /7layer, First Signal
2. PLAN — Constraint classification, repair sequencing, brand intelligence
3. ARCHITECT — Strategy, SOP adaptation, dashboards
4. IMPLEMENT — Execute tasks, run audits, agency coordination
5. REVIEW — Knowledge extraction, pattern checking, quality
6. MONITOR — @monitor tasks, compliance, performance

## Temporal Awareness (SYSTEM-WIDE — MANDATORY)
**Every analysis must identify EXACT dates, check for holidays/seasonality, and distinguish anomalies from calendar effects.**
- Always state exact period (not "last 90 days" but "Jan 6 – Apr 6, 2026")
- Check: holiday week? Season change? Black Friday? School break?
- A 40% drop during Easter is not an anomaly — it's the calendar
- Never compare periods without checking seasonal context match
- Rule: `core/methodology/TEMPORAL_AWARENESS_RULE.md`

## Data Sufficiency Check (SYSTEM-WIDE — MANDATORY)
**Before ANY analysis: classify data axes as AVAILABLE / PARTIAL / MISSING.**
- If a REQUIRED axis is MISSING → STOP, don't analyze
- If 3+ axes PARTIAL/MISSING → proceed with DATA SUFFICIENCY WARNING at top
- Every finding tagged: `[DATA]`, `[INFERRED]`, or `[UNKNOWN]` — never upgrade a tag
- "What We Don't Know" section MANDATORY in every analysis output
- Rule: `core/methodology/DATA_SUFFICIENCY_CHECK.md`

## Confidence Engine (SYSTEM-WIDE — MANDATORY)
**Every finding and recommendation gets a unified confidence score.**
Score = min(Source Confidence, Evidence Class, Assumption Status) — weakest link wins.
- ≥ 0.7 = act on it. 0.4–0.69 = investigate. 0.2–0.39 = note only. < 0.2 = internal hypothesis only.
- Rule: `core/methodology/CONFIDENCE_ENGINE.md`

## Evidence Classification (MANDATORY)
Every evidence item must be tagged: `[DATA]` (system number), `[OBSERVED]` (we verified), `[STATED]` (client said), `[NARRATIVE]` (repeated story), `[INFERRED]` (we concluded), `[HEARSAY]` (second-hand).
- Only DATA and OBSERVED can be CC in ACH. A narrative repeated in 5 documents is NOT stronger evidence.
- Rule: `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`

## Currency Normalization (MANDATORY for multi-market)
**Never sum currencies without conversion. Never compare ROAS across currencies without normalization.**
- Each client has a `reporting_currency` in CLIENT_CONFIG.md
- Rule: `core/methodology/CURRENCY_NORMALIZATION.md`

## Attribution Window Awareness (MANDATORY for cross-platform)
**Google Ads "conversions" and Meta "conversions" are different numbers measuring different things.**
- Google: 30d click. Meta: 7d click. GA4: data-driven. Shopify: session-based.
- Never sum platform conversions. Flag window mismatches.
- Rule: `core/methodology/ATTRIBUTION_WINDOWS.md`

## Alarm Calibration (Anomaly Detection)
**Not every metric drop is a crisis. Calibrate per client.**
- `alarm_sensitivity` in CLIENT_CONFIG.md: `low` (2x std dev), `normal` (1.5x), `high` (1.0x)
- Requires `data/BASELINES.md` per client (refreshed weekly)
- Check sync lag from DOMAIN_CHANNEL_MAP before flagging
- Rule: `core/methodology/ALARM_CALIBRATION.md`

## Recommendation Tracking (Closed-Loop Feedback)
**Check if advice was given before. If it didn't work last time, say so.**
- Every REC logged to `clients/{slug}/RECOMMENDATION_LOG.md`
- `outcome-tracker` agent verifies weekly whether RECs moved the target metric
- Rule: `core/methodology/RECOMMENDATION_DEDUP_RULE.md`

## Multi-Domain & Business Unit Isolation (MANDATORY)
**Before ANY query on a multi-domain client — load `DOMAIN_CHANNEL_MAP.md` and answer "which domain?" AND "which business unit?" FIRST.**
- Business units ≠ domains. Different units = different P&L, market, currency, economics. NEVER blend.
- ALWAYS query shared data sources with dimension filters
- Non-target domain data must be EXCLUDED, not flagged
- Rule: `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`

## Data Analysis Output Standard (ALWAYS-ON)
**Every data analysis MUST use analytical frameworks — a table of numbers is NOT analysis.**
- **Minimum:** BLUF (conclusion first + confidence) → data table → OODA → Data Reliability
- **On anomalies (>15% change):** add ACH (3-6 competing hypotheses scored against evidence)
- Template: `core/templates/BLUF_OODA_TEMPLATE.md`

## Guardrail: Discovery, Not Pronouncement (MOST IMPORTANT)
**The system helps people THINK, not tells them what's TRUE.**
- Present findings as observations with questions, not conclusions
- Show ALL calculations
- End every output with "What did we get wrong? What's missing?"
- Rule: `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`

## Guardrail: Unverified Assumptions
**"Not mentioned" ≠ "Doesn't exist."**
- Distinguish stated/observed vs inferred/not-mentioned
- Rate inferred constraints as UNVERIFIED
- Rule: `core/methodology/UNVERIFIED_ASSUMPTIONS_RULE.md`

## Data Reliability Framework (MANDATORY)
**Every data analysis must include confidence ratings and measurement error impact.**
- Data Reliability summary table per deliverable
- Inline `[Confidence: HIGH/MED/LOW — reason]` on every major finding
- "What Could Invalidate These Findings?" at end
- Rule: `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`

## Model Routing (COST OPTIMIZATION)
**Not every task needs Opus. Route by cognitive complexity.**
- **T1 Haiku:** file routing, PII scanning, task validation, format checks, scaffold ops
- **T2 Sonnet:** content writing, single-skill analysis, SEO, copy, channel analysis, email drafts
- **T3 Opus:** 7-layer diagnosis, councils, complex deliverables, client strategy, ACH
- Rule: when spawning ad-hoc agents, ALWAYS set `model:` explicitly
- Rule: `core/methodology/MODEL_ROUTING.md`

## Databox is Mandatory for Data Analysis (HARD BLOCK)
**Without a live Databox MCP connection, NEVER analyze data. This is a show-stopper.**
- If Databox MCP is not connected → STOP. Tell the user: "Databox MCP is not connected. I cannot analyze data without it. Please connect Databox before proceeding."
- Do NOT fall back to local files, cached data, or guessing from file contents
- Do NOT say "Databox isn't available, let me check local files" — that silently degrades analysis quality
- Every metric claim MUST come from a live Databox query, not from memory or local markdown files
- Rule: `core/methodology/DATABOX_MANDATORY_RULE.md`

## Web Tool Routing (GUARDRAIL — HARD RULE)
**Firecrawl = scraping. Built-in WebSearch/WebFetch = searching. No crossover.**
- Web search/research/discovery → `WebSearch`, `WebFetch`. NEVER `firecrawl_search`.
- Scraping known URLs / extracting content → `firecrawl_scrape`, `firecrawl_crawl`, `firecrawl_extract`, `firecrawl_map`.
- When spawning agents: always specify which tools in the prompt — research agents get WebSearch, site-analysis agents get Firecrawl.
- Rule: `core/methodology/WEB_TOOL_ROUTING_RULE.md`

## MCP Scope Isolation (GUARDRAIL)
**NEVER query external services without a project scope filter.**
- Task manager queries MUST include `projectId` — unfiltered queries return ALL projects across ALL accounts, leaking real client data into the wrong environment.
- Only sync projects that exist in THIS repo's `clients/` directory.
- If a client's `sync_id` is empty → read local TASKS.md only, do NOT query the task manager for that project.

## MCP Rate Limits
**Never send bulk MCP operations without batching.**
- Task manager: max 10/call + 3s delay. Databox: 5 metrics/batch + 2s. On 429: wait, halve batch, retry.
- Rule: `core/methodology/MCP_RATE_LIMITS.md`

## Auto-Save Deliverables (ALWAYS-ON)
When generating any deliverable (email, memo, report, analysis):
1. Load recipient tone from PROJECT_GLOSSARY.md or CONTACTS.md
2. Load topic context (prior correspondence, tasks, audit findings, meetings)
3. Save as .md with ontology edges + version
4. Check glossary for banned terms

## File Intake (ALWAYS-ON)
When user references a file from outside the project:
1. Identify: what is it, which client, which domain, who sent it
2. Route to correct location per naming conventions
3. Extract tasks → create in TASKS.md
4. Log to CAPTAINS_LOG.md

## App Preferences (ALWAYS-ON)
- **Config:** `core/infrastructure/APP_DEFAULTS.md` — single source of truth for file extension → app mapping
- **Script:** `core/scripts/ops/open-file.sh "{path}"` — resolves app from config, use everywhere
- Never hardcode app names in skills or rules. Change the app? Edit one config file.

## Ad Account Registry
- Standard: `core/methodology/AD_ACCOUNT_REGISTRY_STANDARD.md`
- Template: `core/templates/AD_ACCOUNT_REGISTRY_TEMPLATE.md`
- Every client with paid media MUST have `AD_ACCOUNT_REGISTRY.md`. 5-step pre-flight before any paid analysis.

## Templates
- `core/templates/` — CLAUDE.md, TASKS, CLIENT_CONFIG, DOMAIN_CHANNEL_MAP, BASELINES, RECOMMENDATION_LOG, MONITOR_LOG, AD_ACCOUNT_REGISTRY, and more
- Use `/scaffold-project` to create a new client with full structure

## Getting Started
See `docs/GETTING_STARTED.md` for setup instructions.
See `docs/DATABOX_SETUP.md` for Databox MCP connection guide.
