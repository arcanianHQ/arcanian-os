> v1.2 — 2026-04-04 — Added Data Sufficiency Check guardrail, .claude/commands wiring, MCP config fix, Drupal/Todoist/Arcflux removed, Business Unit Isolation v2.0

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
│   ├── skills/              ← 37 slash commands
│   ├── agents/              ← 14 agents + 4 council configs
│   ├── sops/                ← 20+ standard operating procedures
│   ├── methodology/         ← Rules, standards, guardrails
│   ├── templates/           ← Scaffolds for client files
│   ├── reference-implementations/
│   └── infrastructure/      ← DATA_RULES, SECURITY_BLOCKLIST
├── clients/                 ← Per-client working directories
│   └── {slug}/              ← Each client is its own workspace
├── docs/                    ← Getting started, Databox setup
└── .mcp.json                ← MCP connections (Databox, Todoist, etc.)
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
- `belief-analyst.md` — L0-L2 owner beliefs, identity patterns
- `copy-analyst.md` — messaging effectiveness, voice consistency
- `outcome-tracker.md` — weekly REC verification, closed-loop feedback

Plus 4 council configs: `councils/diagnostic.yaml`, `councils/measurement.yaml`, `councils/delivery.yaml`, `councils/discovery.yaml`

## Skills (38 slash commands)

Ops: /tasks, /scaffold-project, /validate, /preflight, /delivery-phase, /client-report, /morning-brief, /health-check, /onboard-client, /onboard-agency
Diagnostic: /7layer, /7layer-hu, /repair-roadmap, /map-results, /measurement-audit, /council
JTBD: /jtbd, /jtbd-map, /jtbd-hire, /jtbd-outcomes, /jtbd-switch
Strategy: /build-brand, /craft-offer, /validate-idea, /analyze-gtm, /plan-gtm
Content: /linkedin-comment, /substack-post, /magyar-szoveg, /conversion-story
Platform: /arcos, /connect, /frontend-design, , /memory-bank, /claude-code-guide
Other: /analyze-copy, /manage-client, /sales-pulse, /verify-pmf

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

## Data Sufficiency Check (SYSTEM-WIDE — MANDATORY)
**Before ANY analysis: classify data axes as AVAILABLE / PARTIAL / MISSING.**
- If a REQUIRED axis (traffic, conversions, prior period) is MISSING → STOP, don't analyze
- If 3+ axes PARTIAL/MISSING → proceed with DATA SUFFICIENCY WARNING at top
- Every finding tagged: `[DATA]`, `[INFERRED]`, or `[UNKNOWN]` — never upgrade a tag
- "What We Don't Know" section MANDATORY in every analysis output
- One data point ≠ pattern. Absence ≠ zero. Platform gap IS data, its cause is INFERRED.
- Rule: `core/methodology/DATA_SUFFICIENCY_CHECK.md`
- Applies to: ALL analytical skills and freeform data queries

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
**Never sum HUF and EUR. Never compare USD ROAS to HUF ROAS without conversion.**
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

## MCP Rate Limits
**Never send bulk MCP operations without batching.**
- Todoist: max 10/call + 3s delay. Databox: 5 metrics/batch + 2s. On 429: wait, halve batch, retry.
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

## Templates
- `core/templates/` — CLAUDE.md, TASKS, CLIENT_CONFIG, DOMAIN_CHANNEL_MAP, BASELINES, RECOMMENDATION_LOG, MONITOR_LOG, RECOMMENDATION_DASHBOARD, and more
- Use `/scaffold-project` to create a new client with full structure

## Getting Started
See `docs/GETTING_STARTED.md` for setup instructions.
See `docs/DATABOX_SETUP.md` for Databox MCP connection guide.
