> v1.20.0 — 2026-04-14

# Arcanian OS — Changelog

All notable changes to the public repository.

---

## [1.20.0] — 2026-04-14

### Added
- **WEB_TOOL_ROUTING_RULE.md** — system guardrail: Firecrawl for scraping only, built-in WebSearch/WebFetch for web search — hard routing rule with agent instructions
- `.claude/rules/web-tool-routing.md` — path-scoped enforcement rule for web tool routing

---

## [1.19.0] — 2026-04-14

### Added
- **5 GEO/SEO skills** — `/geo-audit` (AI search readiness audit), `/geo-visibility` (AI brand perception check), `/geo-optimize` (GEO content optimization), `/seo-cluster` (content performance clustering), `/seo-schema` (schema & structured data analyzer)
- **AD_ACCOUNT_REGISTRY_STANDARD.md** — mandatory per-client ad account registry with 5-step pre-flight, 2-year lookback, currency handling, shared account isolation rules
- **AD_ACCOUNT_REGISTRY_TEMPLATE.md** — full template with account inventory, campaign prefix mapping, monthly spend history, data gaps table
- `.claude/commands/` entries for all 5 new skills

---

## [1.18.0] — 2026-04-14

### Added
- **EVENT_LOG system** — per-client operational event timeline (EVENT_LOG_RULE.md, EVENT_LOG_TEMPLATE.md)
- **EVT ontology node** — first-class Event object in ONTOLOGY_STANDARD.md with bidirectional edges
- **Path-scoped rule** — .claude/rules/event-log.md enforces pre-load before analysis, auto-extract after
- **Analysis pre-load** — analysis-frameworks.md Step 0b mandates EVENT_LOG.md load before any data query
- **Auto-extraction** — ONTOLOGY_ENRICHMENT_RULE.md sections 5-6: extract events from analysis + meetings
- **Scaffold integration** — scaffold-project Step 3d creates EVENT_LOG.md for every new project
- **Changelog enforcement** — CHANGELOG_ENFORCEMENT_RULE.md section 8 covers operational events

---

## [1.17.0] — 2026-04-14

### Date context hook — prevent day-of-week errors

#### Added
- **`core/scripts/ops/date-context.sh`** — Single source of truth for current date context. Outputs date, day-of-week, week number, quarter, working day status. Formats: `json`, `oneliner`, `summary`. Used by hooks, `/day-start`, `/day-end`, any date-aware skill.
- **`core/tools/hooks/templates/user-prompt-submit-date-context.sh`** — UserPromptSubmit hook that detects date-related keywords (EN + HU) and injects accurate date context (day-of-week, week, quarter). Prevents day name guessing errors in summaries and logs.

#### Updated
- **`.claude/settings.json`** — Wired `user-prompt-submit-date-context.sh` into UserPromptSubmit hooks.

---

## [1.16.0] — 2026-04-13

### Hungarian Grammar Checker agent

#### Added
- **`core/agents/hu-grammar-checker.md`** — Sonnet-tier agent for thorough Hungarian text quality review. 10-point checklist: accents (ékezetek), vowel harmony, case endings (vonzatok), sentence fragments, compound words, verb conjugation, AI-magyar patterns (from `/magyar-szoveg`), dangling references, keyword stuffing, consistency. Returns structured find→replace table with WHY explanations. Pairs with `/magyar-szoveg` skill.

---

## [1.15.0] — 2026-04-10

### Close aspirational gaps: auto day-start/end, knowledge enforcement, stage validation, auto-sync

#### Added
- **`session-start-day-start.sh`** (`core/tools/hooks/templates/`) — auto-triggers `/day-start` on first session of the day. Uses `.claude/last-session-date.local` to prevent duplicate runs.
- **`stop-hook.sh`** (`core/tools/hooks/templates/`) — unified Stop hook: handles Ralph loop continuation OR auto-triggers `/day-end` after 17:00 (once per day). Replaces two separate stop hooks.
- **`post-tool-use-knowledge-extraction-reminder.sh`** (`core/tools/hooks/templates/`) — reminds to run Phase 5 knowledge extraction after writing audit deliverables to `clients/*/audit/`. Checks KNOWN_PATTERNS.md freshness (7-day threshold).

#### Updated
- **`/council` skill** — Agent Output Validation: after each agent completes, coordinator verifies required sections (PRIMARY FINDING, OBSERVATIONS, confidence suffix, OVERALL CONFIDENCE). Re-invokes once if malformed. Passes `[AGENT FAILED]` rather than hallucinated output. Appends machine-readable `stage-result` block.
- **`/pipeline` skill** — Stage-Result Validation: after each stage, verifies required fields per stage type. User chooses rerun/skip/proceed on incomplete output. Missing data flagged in BLUF.
- **`/task-sync` skill** — Single Task Auto-Push: 1-4 tasks auto-push to Todoist immediately after creation (no confirmation prompt). 5+ tasks use existing plan-and-confirm flow. Determines correct projectId from TODOIST_ROUTING_MAP.md.
- **`/morning-brief` skill** — Step 5c Signal Detection: priority chain (AuthoredUp API → WebFetch LinkedIn → ask user → skip with note). Detected signals route to signal-routing SOP and update lead score in LEAD_STATUS.md.
- **`/save-deliverable` skill** — Step 7 streamlined: auto-extract tasks, auto-sync to Todoist, rename draft→sent, update ontology backlinks, one summary line. Quality rating prompt added post-finalization.

---

## [1.14.0] — 2026-04-11

### Auto-update system

#### Added
- **`/update` skill** — one-command system update. Pulls latest skills, agents, SOPs, guardrails from GitHub. Never touches client data, tasks, contacts, or `.mcp.json`.
- **Session-start update check** — automatically checks for new versions on every session start. Shows banner if updates available. Never blocks.
- **`core/tools/hooks/templates/session-start-update-check.sh`** — lightweight fetch + version compare hook

---

## [1.13.0] — 2026-04-11

### Rename demo clients — avoid real company names

#### Changed
- **Demo client `example-ecom`:** AquaLux → **SolarNook** (premium outdoor living, pergolas/shading)
- **Demo client `example-saas`:** CloudMetrics → **LoopForge** (B2B SaaS analytics)
- **Demo client `example-local`:** GreenScape → **MossTrail** (local landscaping, Denver)
- All domain references updated (`solarnook-us.com`, `loopforge.io`, `mosstrail-example.com`)
- Industry description updated: "wellness (hot tubs)" → "outdoor living (pergolas, shading systems)"
- Updated across: CLIENT_CONFIG, CONTACTS, TASKS, CLAUDE.md, DOMAIN_CHANNEL_MAP, CAPTAINS_LOG, README
- `core/methodology/TEMPORAL_AWARENESS_RULE.md` — example reference updated
- `core/skills/seo-narrative.md` — example query updated

---

## [1.12.1] — 2026-04-11

### Second Pass: tool scoping, per-finding confidence, blocker hooks

#### Updated
- **`skills/review.md`** — Added `allowed-tools` + `argument-hint` to frontmatter.
- **`skills/7layer.md`, `7layer-hu.md`, `council.md`, `pipeline.md`, `analyze-gtm.md`, `health-check.md`, `client-report.md`, `repair-roadmap.md`** — Added `allowed-tools` + `argument-hint` to frontmatter for tool scoping.
- **`skills/output-review.md`** — Added Step 5b dismissed pattern analysis.
- **`templates/RECOMMENDATION_LOG_TEMPLATE.md`** — Added `detected_pattern` + `dismissed_reason` columns for systematic false positive tracking.
- **`methodology/RECOMMENDATION_DEDUP_RULE.md`** — Added dismissal tracking section; feeds `/output-review` Step 5b pattern detection.

#### Added
- **`tools/hooks/templates/pre-tool-use-enrichment-gate.sh`** — Blocker hook: gates writes on enrichment completeness before deliverable save.
- **`tools/hooks/templates/pre-tool-use-deliverable-tone-check.sh`** — Blocker hook: validates tone register against CONTACTS.md before writing deliverables.
- **`tools/hooks/templates/post-tool-use-data-normalizer.sh`** — Post-write hook: normalizes currency and attribution window metadata in analysis files.

---

## [1.12.0] — 2026-04-10

### Architecture Upgrade: context:fork, few-shot examples, MCP error handling, /review skill

#### Added
- **`methodology/MCP_ERROR_HANDLING.md`** — Standardized MCP error classification and retry logic. 5 error classes (transient/auth/rate/schema/fatal), retry strategies per class, backoff formula, hook template reference.
- **`skills/review.md`** — New `/review` skill for monthly deliverable quality analysis. Scans output dirs, scores enrichment quality, cross-tabulates input_context × deliverable_type.
- **`tools/hooks/templates/post-tool-use-mcp-error-classifier.sh`** — Hook template that auto-classifies MCP errors on post-tool-use and logs to CAPTAINS_LOG.
- **`.claude/commands/review.md`** — Slash command wiring for `/review`.

#### Updated
- **`skills/7layer.md`, `7layer-hu.md`, `council.md`, `pipeline.md`, `analyze-gtm.md`, `health-check.md`, `client-report.md`, `repair-roadmap.md`** — Added `context: fork` to frontmatter. Skills now explicitly declare fork context for session routing.
- **`methodology/MCP_RATE_LIMITS.md`** — Updated with error handling references and retry guidance aligned with MCP_ERROR_HANDLING.md.
- **`skills/extract-contacts.md`, `extract-platforms.md`, `output-review.md`** — Added sanitized few-shot examples section to each skill. Example-brand.com / example-client placeholders only.

## [1.11.0] — 2026-04-10

### Added
- **GTM Intelligence Layer** — Signal-to-close pipeline with mathematical lead scoring, enrichment gates, and decision trees
- **`SIGNAL_DECAY_MODEL.md` v1.0** — Time-weighted lead scoring formula (`score = SUM(weight × 0.5^(days/half_life))`). 7 signal types with weights and half-lives. Hot/Warm/Cold thresholds. P0/P1/P2 boost mapping. Stage gate integration (Diagnosed→Pitched: ≥15, Pitched→Negotiating: ≥20). Daily recalculation via `/morning-brief`.
- **`ENRICHMENT_WATERFALL.md` v1.0** — Stage-gated intelligence requirements before lead advancement. Per-stage checklists (Signal→Discovery→Diagnosed→Pitched→Negotiating→Won). Formalizes 3-axis context load (TOPIC/PERSON/DOMAIN) as reusable primitive. Hard gates (score-based) vs soft gates (enrichment-based).
- **`/output-review` skill** — Monthly deliverable quality analysis. Scans ontology blocks across all deliverable types. Classifies by input_context (signal/meeting/task/brief/freeform). Computes quality metrics and cross-tabulates context × type. Identifies enrichment effect on quality. Saves to `internal/reviews/YYYY-MM_output-review.md`.
- **`sops/decision-trees/` directory** — 5 human-scannable Mermaid flowcharts for the most common routing decisions:
  - `signal-routing.md` — P0/P1/P2 priority routing, competitor handling, lead file creation
  - `lead-stage-transitions.md` — Full transition logic with score gates, follow-up timers, dormancy handling
  - `inbox-triage.md` — File type classification, routing destinations, task extraction
  - `deliverable-routing.md` — Save location by type and context, input_context and enrichment gate check
  - `sop-selection.md` — Keyword-to-SOP mapping with full decision tree and quick reference table
- **`.claude/commands/output-review.md`** — Slash command wiring for `/output-review`

### Changed
- **`LEAD_TRACKING_STANDARD.md`** — Added Scoring section (references SIGNAL_DECAY_MODEL), Signal Log template, Enrichment Gates section (references ENRICHMENT_WATERFALL). New stage: Signal (pre-Discovery).
- **`skills/morning-brief.md`** — Added Step 5b: Lead Score Refresh (daily recalculation of all active leads, threshold crossing alerts, declining trend flags). Added Lead Pipeline section to output format.
- **`skills/pipeline.md`** — Added Enrichment Gate check as Stage 0 of discovery pipeline. Updated `--client` example slugs to generic.
- **`skills/save-deliverable.md`** — Added `input_context`, `quality_rating`, and `engagement` fields to ontology block. Added Step 7b: Quality Rating Prompt. Integration with `/output-review` feedback loop.
- **`sops/SOP_INDEX.md`** — Added Decision Trees section (5 new entries). Updated stats table (31 written vs 26 previously).

---

## [1.10.0] — 2026-04-10

### Added
- **`/extract-contacts` skill** — Extracts contacts from emails, correspondence, and meeting transcripts into CONTACTS.md. Auto-classifies (client team / vendor / agency), deduplicates by email+name, enforces temporal columns (Active Since, Status). Integrates with `/inbox-process` and deliverable auto-save.
- **`/extract-platforms` skill** — Extracts domains, GTM containers, GA4 properties, Google Ads IDs, Meta pixels, sGTM domains, AC instances, and all platform identifiers from correspondence. Routes to DOMAIN_CHANNEL_MAP.md and CLIENT_CONFIG.md. 3-tier extraction (always/when found/flag only). Conflict detection, cross-reference gaps (domain without GA4, etc.).

---

## [1.9.0] — 2026-04-09

### Added
- **CHANGELOG_ENFORCEMENT_RULE.md v1.0** — System-wide rule: every tracked artifact (GTM, repo exports, configs, methodology, SOPs, schedules, MCP) must have a changelog entry. A change without a log entry is a change we can't debug.

---

## [1.8.0] — 2026-04-09

### Changed
- **CLAUDE.md v2.0** — Accurate skill/agent/SOP counts (43/14/20), clean structure, no stale references

---

## [1.7.0] — 2026-04-08

### Added
- **MODEL_ROUTING.md v1.0** — LLM cost optimization guardrail. 3-tier routing table (Haiku/Sonnet/Opus) mapped to 47 workflows. Decision flowchart, anti-patterns, rate limit budgeting. Verified with live A/B tests across all tier boundaries.

---

## [1.6.0] — 2026-04-07

### Added
- **CONTACT_REGISTRY_STANDARD.md v1.1** — `Active Since` and `Status` columns mandatory on all contact tables. Departed contacts stay in table with status — never delete history.

## [1.5.0] — 2026-04-07

### Added
- **DOMAIN_CHANNEL_MAP_TEMPLATE.md v1.3** — `Active Since` and `Status` columns on all 14 mapping tables. A mapping without dates is a mapping you can't trust.
- **MULTI_DOMAIN_ANALYSIS_RULE.md v2.1** — New "Temporal Awareness in Mappings" section: check whether mappings were valid for the analyzed period, treat blank dates as UNVERIFIED.
- **solarnook DOMAIN_CHANNEL_MAP.md v1.2** — Updated demo client map with date columns on all tables.

---

## [1.4.1] — 2026-04-05

### Fixed
- Bumped file versions on 7 files that were modified after v1.0 but still showed v1.0

## [1.4.0] — 2026-04-05

### Fixed
- **DATABOX_SETUP.md** — Removed incorrect npx/API token configuration. Databox MCP is a remote HTTP server authenticated via `/mcp` OAuth, not an npm package with an env token.
- **GETTING_STARTED.md** — Updated MCP connection table to reflect OAuth flow instead of API token.

### Added
- CHANGELOG.md — this file

---

## [1.1.0] — 2026-04-04

### Changed
- **CLAUDE.md** — Reframed as go-to-market diagnostic system
- **README.md** — Updated skill/agent counts
- **/os page** hero copy — GTM language, "View on GitHub" + "Getting Started Guide" buttons
- **DOMAIN_CHANNEL_MAP_TEMPLATE.md** — Added Business Units section as standard

### Added
- GTM Gap Analysis card in "What's inside"
- Roadmap section ("What's next") with Shipped / In progress / Coming next / Exploring
- GitHub link on /os page (repo went public)
- Partner signup link for Databox trials
- "Connect your data" section with Databox signup

---

## [1.0.0] — 2026-04-03

### Initial release
- 160 markdown files
- 37 skills, 14 agents, 4 council configs, 20+ SOPs
- 30+ methodology files (confidence engine, currency normalization, attribution windows, alarm calibration, recommendation tracking, domain isolation, evidence classification, data reliability)
- 28 templates (baselines, recommendation log, monitor log, dashboard, domain channel map, client config)
- 3 example clients (SaaS, multi-domain e-commerce, local services)
- docs/GETTING_STARTED.md + docs/DATABOX_SETUP.md
- .mcp.json.example for Databox connection
- MIT license

## [1.13.1] — 2026-04-11

### Add hook settings with portable paths

#### Added
- `.claude/settings.json` — hook configuration using `$CLAUDE_PROJECT_DIR` for portable paths
- `.gitignore` — exception for `.claude/settings.json` so hooks ship with the repo

