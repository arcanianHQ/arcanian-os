---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Skill: System Health Check (`/health-check`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

> **Evidence classification:** Every finding MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data ≠ causal. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

Verifies system-wide health — project integrity, MCP connections, symlinks, git status, and core methodology files. Catches drift before it causes problems.

## Architecture

> v2.0 — 2026-04-12 — Refactored from monolithic to council pattern.

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
1. Check `CLAUDE.md` exists and is under 80 lines
2. Check `TASKS.md` exists with YAML frontmatter and priority sections
3. Check `CAPTAINS_LOG.md` exists with at least one dated entry
4. Check `CONTACTS.md` exists (MANDATORY for all clients — see `core/methodology/CONTACT_REGISTRY_STANDARD.md`)
5. Check `brand/` directory — count how many of the 7 standard files exist
6. Check `skills/` symlink exists and resolves to `core/skills/`
7. Check `sops/` symlink exists and resolves to `core/sops/`
8. Check `.gitignore` exists and blocks `.env`
9. **Multi-domain check:** If `CLIENT_CONFIG.md` lists 2+ domains, check `DOMAIN_CHANNEL_MAP.md` exists (MANDATORY — see `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`). Flag as **CRITICAL** if missing — any analysis on this client risks cross-domain data contamination.

### Step 2: MCP connections (scope: all, mcp) → `health-mcp-checker`
For each project with `.claude/settings.json` or `.mcp.json`:
1. List configured MCP servers
2. Attempt a minimal query per server type:
   - Todoist: `get-overview` or `user-info`
   - Asana: `asana_list_workspaces`
   - GA4/Ads/Meta: note as configured (no simple ping available)
3. Record: connected, auth error (401/403), not configured, or timeout

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
6. `VERSION.json` exists and `version` field matches CHANGELOG.md top `## [X.Y.Z]` entry

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
Domain maps: {N}/{multi-domain total} have DOMAIN_CHANNEL_MAP.md ✓ ({missing list})
Symlinks: {N}/{total} resolve ✓
Brand profiles: {N}/{total} complete ({incomplete list})

── MCP CONNECTIONS ────────────
Todoist ✓ | Asana ✗ (401) | GA4 ✓ | Meta ✗ (not configured)

── GIT STATUS ─────────────────
Clean: {N} repos
Dirty: {list of repos with uncommitted changes}
Unpushed: {list of repos with local-only commits}

── HOOKS ──────────────────────
Configured: {N}/{total} projects

── CORE FILES ─────────────────
TASK_SYSTEM_RULES.md ✓
KNOWN_PATTERNS.md ✓
PROJECT_REGISTRY.md ✓
SOP_INDEX.md ✗ (missing)

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
