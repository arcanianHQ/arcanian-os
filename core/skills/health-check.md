---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
argument-hint: [scope] — all, clients, mcp, git, core
---

# Skill: System Health Check (`/health-check`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

> **Evidence classification:** Every finding MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data ≠ causal. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

Verifies system-wide health — project integrity, MCP connections, symlinks, git status, and core methodology files. Catches drift before it causes problems.

## Architecture

> v2.1 — 2026-04-16 — Added: fix commands, context freshness, data bloat, CLI version drift, CHANGELOG freshness.

This skill uses the **health-check council** (`core/agents/councils/health-check.yaml`) which orchestrates 6 agents:

| Agent | Weight | What it checks |
|---|---|---|
| `health-project-checker` | 25% | CLAUDE.md, TASKS.md, CONTACTS.md, symlinks, brand files |
| `health-mcp-checker` | 20% | MCP connectivity, Databox mandatory check |
| `health-git-checker` | 15% | Uncommitted changes, unpushed commits, submodules |
| `health-hooks-checker` | 10% | Claude Code hooks configuration |
| `health-core-checker` | 15% | Methodology rules, SOPs, skills, templates |
| `health-warning-intel` | 15% | Cross-client patterns, blind spots (Grabo method) |

Scoring rubrics: `core/methodology/HEALTH_CHECK_SCORING.md`

Pipeline: collect (5 agents parallel) → warning intel → synthesis

## Trigger

Use when: user says `/health-check`, "check system health", "is everything working", or as a periodic maintenance check.

## Input

| Input | Required | Default |
|---|---|---|
| `scope` | No | `all` — options: `all`, `clients`, `mcp`, `git`, `core` |

## Execution Steps

> Each step maps to an agent. Steps 1-5 run in parallel. Step 6 runs after, consuming their output.
> Individual agents can be called standalone by other skills (e.g., `/validate` calls only `health-project-checker`).

### Step 0: Load Previous Health State (pre-agent, automatic)

Before running any agents, check for a previous health state snapshot:

1. Read `memory/HEALTH_STATE.json` in the hub root (`_arcanian-ops/`)
2. If it exists → store as `PREV_STATE` for delta comparison in Step 7
3. If it does not exist → note "First run — baseline will be established" and proceed

This step is read-only and fast. Do not block on it.

### Step 1: Project integrity (scope: all, clients) → `health-project-checker`
For each directory in `_arcanian-ops/clients/` and `_arcanian-ops/internal/`:
1. Check `CLAUDE.md` exists and is under 80 lines → Fix: `/scaffold-project {slug}`
2. Check `TASKS.md` exists with YAML frontmatter and priority sections → Fix: `/scaffold-project {slug}`
3. Check `CAPTAINS_LOG.md` exists with at least one dated entry → Fix: `/scaffold-project {slug}`
4. Check `CONTACTS.md` exists (MANDATORY — see `core/methodology/CONTACT_REGISTRY_STANDARD.md`) → Fix: `/extract-contacts {slug}`
5. Check `brand/` directory — count how many of the 7 standard files exist → Fix: `/build-brand {slug}`
6. Check `skills/` symlink exists and resolves to `core/skills/` → Fix: `ln -s ../../core/skills/ clients/{slug}/skills`
7. Check `sops/` symlink exists and resolves to `core/sops/` → Fix: `ln -s ../../core/sops/ clients/{slug}/sops`
8. Check `.gitignore` exists and blocks `.env` → Fix: `/scaffold-project {slug}`
9. **Multi-domain check:** If `CLIENT_CONFIG.md` lists 2+ domains, check `DOMAIN_CHANNEL_MAP.md` exists (MANDATORY). Flag as **CRITICAL**. → Fix: create `DOMAIN_CHANNEL_MAP.md` per `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`

### Step 1b: Context freshness (scope: all, clients) → `health-project-checker`
For each client project, check for stale context:
1. **CAPTAINS_LOG.md** — parse the most recent `## YYYY-MM-DD` header. If >14 days old → WARN ("stale — no logged activity in {N} days"). If >30 days → CRITICAL. → Fix: open a client session and log recent work
2. **TASKS.md** — check `updated:` field in frontmatter. If >30 days old → WARN ("task list may be outdated"). → Fix: `/task-sync`
3. **inbox/** — count files. If any file >7 days old → WARN. >14 days → flag. >30 days → CRITICAL ("archive or process"). → Fix: `/inbox-process`
4. **memory/ files** — in hub `memory/` directory, check file modification dates. Files >90 days old → INFO ("may be stale — verify still accurate")

### Step 1c: Data bloat (scope: all, clients) → `health-project-checker`
For each client project, check directory sizes:
1. `audit/evidence/` — if >500MB → WARN ("evidence directory growing large — consider archiving old audits")
2. `data/` — if >200MB → WARN ("data directory bloated — check for stale exports")
3. `data/gtm-exports/` — if >10 JSON files → INFO ("consider archiving old GTM exports")
4. Total project directory — if >1GB → WARN ("project exceeding 1GB threshold")
Use `du -sh` for size checks. These are advisory thresholds, not blocks.

### Step 2: MCP connections (scope: all, mcp) → `health-mcp-checker`
For each project with `.claude/settings.json` or `.mcp.json`:
1. List configured MCP servers
2. Attempt a minimal query per server type:
   - Todoist: `get-overview` or `user-info`
   - Asana: `asana_list_workspaces`
   - GA4/Ads/Meta: note as configured (no simple ping available)
3. Record: connected, auth error (401/403), not configured, or timeout
4. Fix commands per failure type:
   - Auth error → "Rotate token in ~/.claude.json, then restart ALL sessions"
   - Not configured → "Add server to .mcp.json per `core/infrastructure/it-systems/SYSTEMS.md`"
   - Timeout → "Check network/VPN, verify server endpoint in .mcp.json"

### Step 3: Git status (scope: all, git) → `health-git-checker`
For each project directory that contains `.git/`:
1. Run `git status --porcelain`
2. Flag repos with uncommitted changes
3. Flag repos with unpushed commits (`git log @{u}..HEAD` if upstream exists)

### Step 4: Hooks (scope: all, clients) → `health-hooks-checker`
For each project:
1. Check `.claude/settings.json` exists
2. Check if hooks are configured (preflight, session start, etc.)

### Step 4b: Baseline & Anomaly Detection (scope: all, clients)
For each client project:
1. Check if `data/BASELINES.md` exists. If not: flag as INFO ("no baselines yet — anomaly detection disabled for this client")
2. If baselines exist: check `Last Updated` column. Baselines older than 30 days = WARN ("stale baselines")
3. Load `CLIENT_CONFIG.md` → `alarm_sensitivity` (default: `normal`). See `core/methodology/ALARM_CALIBRATION.md`
4. For each baselined metric: pull current value via Databox MCP (if connected)
5. **Before flagging:** check sync lag from `DOMAIN_CHANNEL_MAP.md` `Typical Lag` column. If data source lag > metric freshness window, do NOT flag — log as "awaiting sync" instead
6. Apply threshold: `baseline_avg ± (std_dev × sensitivity_multiplier)`
7. Score anomaly confidence via `core/methodology/CONFIDENCE_ENGINE.md`
8. Only create task if confidence ≥ 0.4 AND metric is outside threshold

### Step 5: Core methodology (scope: all, core) → `health-core-checker`
Check `_arcanian-ops/core/` for required files:
1. `methodology/TASK_SYSTEM_RULES.md` exists
2. `methodology/KNOWN_PATTERNS.md` exists
3. `methodology/PROJECT_REGISTRY.md` exists
4. `sops/SOP_INDEX.md` exists (or equivalent)
5. `skills/` contains expected skill files
6. `VERSION.json` exists and `version` field matches CHANGELOG.md top `## [X.Y.Z]` entry → Fix: update VERSION.json or CHANGELOG.md to match

### Step 5b: CLI version drift (scope: all, core) → `health-core-checker`
Check if the Claude Code CLI is current:
1. Run `claude --version` to get local version
2. Run `npm view @anthropic-ai/claude-code version 2>/dev/null` to get latest published version
3. Compare: if local < latest → WARN ("Claude Code {local} is behind latest {latest}") → Fix: `npm update -g @anthropic-ai/claude-code`
4. If npm check fails (offline, no npm) → INFO ("could not check CLI version — skipping")

### Step 5c: CHANGELOG freshness (scope: all, core) → `health-core-checker`
1. Check hub `CHANGELOG.md` — compare top version date against most recent git commit date in `core/`
2. If core/ has commits newer than the CHANGELOG top entry → WARN ("core/ modified since last changelog entry — bump version") → Fix: update CHANGELOG.md and VERSION.json

### Step 6: Warning Intelligence — Cross-Client Pattern Detection (scope: all, clients) → `health-warning-intel`

> Source: Cynthia Grabo / Pentagon warning intelligence framework.
> Adapted from Marketing Council v12.

When checking multiple clients (scope: all or clients), analyze findings across ALL projects for intelligence signals:

#### 6a: Convergent Signals
Look for the same issue appearing in 2+ client projects independently:

```
CONVERGENT SIGNALS:
| Signal | Clients Affected | Confidence | Implication |
|--------|-----------------|------------|-------------|
| [e.g., "GTM consent mode misconfigured"] | [diego, wellis] | HIGH | Systemic SOP gap |
| [e.g., "TASKS.md stale >30 days"] | [mancsbazis, deluxe] | MED | Process drift |
```

When the same issue appears independently across clients, it points to a **systemic gap** in core/ (SOPs, templates, methodology) rather than a client-specific problem.

#### 6b: Weak Signal Clusters
Look for individually minor issues that together predict a bigger problem:

```
WEAK SIGNAL CLUSTERS:
[Observation 1] + [Observation 2] + [Observation 3]
→ Predicted outcome: [what these signals together suggest]
→ Action: [what to investigate or prevent]
```

Example: "3 clients have inbox >7 days" + "CAPTAINS_LOG not updated this week" + "2 MCP connections failing" → team capacity may be stretched.

#### 6c: Blind Spots
Flag critical areas that NO client project currently addresses:

```
BLIND SPOTS:
- [Area no project covers — e.g., "No client has sGTM monitoring"]
- [Missing capability — e.g., "No project tracks competitor changes"]
```

#### 6d: Contradictions
Where data from different sources or clients conflicts:

```
CONTRADICTIONS:
| Source A | Source B | Conflict | Investigation needed |
|----------|---------|----------|---------------------|
| [what one source says] | [what another says] | [the conflict] | [how to resolve] |
```

### Step 7: Persist State and Compute Delta (post-synthesis, automatic)

After generating the human-readable output from Step 6:

**7a — Persist current state:**
1. If `memory/HEALTH_STATE.json` already exists → rename to `memory/HEALTH_STATE_PREV.json` (overwrite any existing _PREV)
2. Write current run's scores, flags, warnings, and convergent signals to `memory/HEALTH_STATE.json`
3. Schema: `core/templates/HEALTH_STATE_TEMPLATE.json`

**7b — Compute delta (if PREV_STATE exists from Step 0):**
1. For each dimension in `scores`: compute `new_score - old_score`
2. For `critical_flags`: diff the arrays (new flags, resolved flags)
3. For `convergent_signals`: diff (new signals, signals that disappeared)
4. Output the `── TREND ──` section (see Output Format below)

If no previous state existed (first run), skip 7b and output "Baseline established — trend data available from next run."

## Output Format

```
HEALTH CHECK — YYYY-MM-DD
═══════════════════════════

── PROJECTS ───────────────────
Clients: {N}/{total} have CLAUDE.md ✓
TASKS.md: {N}/{total} valid ✓
CONTACTS.md: {N}/{total} exist ✓ ({missing list})
  ✗ {slug}: CONTACTS.md missing → Fix: /extract-contacts {slug}
Domain maps: {N}/{multi-domain total} have DOMAIN_CHANNEL_MAP.md ✓ ({missing list})
Symlinks: {N}/{total} resolve ✓
Brand profiles: {N}/{total} complete ({incomplete list})
  ✗ {slug}: 2/7 brand files → Fix: /build-brand {slug}

── CONTEXT FRESHNESS ──────────
CAPTAINS_LOG: {N}/{total} current (<14 days)
  ⚠ {slug}: last entry 23 days ago → open session, log recent work
TASKS.md: {N}/{total} synced (<30 days)
  ⚠ {slug}: last sync 45 days ago → Fix: /task-sync
Inbox: {N} files overdue (>7 days)
  ✗ {slug}: 3 files in inbox >14 days → Fix: /inbox-process

── DATA BLOAT ─────────────────
{slug}: audit/evidence/ 620MB ⚠ → archive old audits
{slug}: data/ 180MB ✓
All others under threshold ✓

── MCP CONNECTIONS ────────────
Todoist ✓ | Asana ✗ (401 → rotate token, restart sessions) | GA4 ✓

── GIT STATUS ─────────────────
Clean: {N} repos
Dirty: {list} → commit or stash
Unpushed: {list} → git push

── HOOKS ──────────────────────
Configured: {N}/{total} projects
  ✗ {slug}: no hooks → Fix: bash core/tools/hooks/deploy-hooks.sh

── CORE FILES ─────────────────
TASK_SYSTEM_RULES.md ✓
KNOWN_PATTERNS.md ✓
PROJECT_REGISTRY.md ✓
SOP_INDEX.md ✗ → create per core/sops/ directory
VERSION.json ↔ CHANGELOG.md ✓ (v1.3.0)
Claude Code: v1.0.20 (latest: v1.0.22 ⚠ → npm update -g @anthropic-ai/claude-code)
CHANGELOG: ✓ current (or ⚠ core/ modified since last entry → bump version)

── WARNING INTELLIGENCE ───────
Convergent signals: {N} (issues appearing in 2+ clients)
  {signal 1}: {clients} — {implication}
  {signal 2}: {clients} — {implication}
Weak signal clusters: {N}
  {cluster description → predicted outcome}
Blind spots: {N}
  {area not covered by any project}
Contradictions: {N}
  {conflict description}

── TREND (vs previous run) ────
Previous: {PREV_STATE.generated} (v{PREV_STATE.version})
  project_integrity: {old} → {new} ({delta}) {✓/⚠/CRITICAL}
  mcp_connections:   {old} → {new} ({delta}) {✓/⚠/CRITICAL}
  git_status:        {old} → {new} ({delta}) {✓/⚠/CRITICAL}
  hooks:             {old} → {new} ({delta}) {✓/⚠/CRITICAL}
  core_methodology:  {old} → {new} ({delta}) {✓/⚠/CRITICAL}
  warning_intel:     {old} → {new} ({delta}) {✓/⚠/CRITICAL}
New flags: {list or "none"}
Resolved: {list or "none"}
(If first run: "Baseline established — trend data available from next run.")

── SUMMARY ────────────────────
{total_pass} pass | {total_fail} fail | {total_warn} warnings
{Action items if any failures}
═══════════════════════════════
```

## Notes

- This skill writes **one file**: `memory/HEALTH_STATE.json` (runtime state for trend tracking). All other operations are read-only.
- Use `scope` parameter to run a subset of checks when debugging a specific area.
- Run weekly or after major changes (new client onboarded, MCP reconfigured, etc.).
- Pairs with `/validate` — this skill checks the whole system, `/validate` checks one project in depth.
