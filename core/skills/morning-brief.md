---
scope: shared
---

# Skill: Morning Brief (`/morning-brief`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Daily cross-project summary for the founder. Scans all projects for urgent items, overdue tasks, stale dependencies, and quick wins — in one compact view.

> **Multi-domain prerequisite:** When pulling metrics for multi-domain clients, load `DOMAIN_CHANNEL_MAP.md` and report KPIs per domain — not account-level aggregates. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data confidence ≠ causal confidence. GA4 alone is insufficient for causal diagnosis — always check platform-side data (Meta Ads Manager, Google Ads, etc.). See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

## Trigger

Use when: user says `/morning-brief`, "what's on today", "daily summary", "morning overview", or at session start across the hub.

## Input

None. Scans all projects automatically.

## Execution Steps

### Step 1: Discover projects
1. Scan `_arcanian-ops/clients/*/TASKS.md` for all client projects
2. Also read `_arcanian-ops/internal/TASKS.md` if it exists
3. Build project list with display names from each `CLAUDE.md`

### Step 2: Collect P0 tasks
For each project with a TASKS.md:
1. Parse all tasks under `## P0`
2. Collect task number, description, owner, due date

### Step 3: Collect overdue tasks
For each project:
1. Find all open tasks (`- [ ]`) with `Due:` date before today
2. Group by project
3. Sort by how many days overdue (worst first)

### Step 4: Collect stale @waiting
For each project:
1. Find tasks with `@waiting` label
2. Check `Updated:` date — flag if > 7 days ago
3. Extract who we're waiting on from task notes or edges
4. Group by person/entity we're waiting on

### Step 5: Collect quick wins
For each project:
1. Find open `@next` tasks where `Effort:` ≤ 1h AND `Impact:` ∈ {lever, unlock, breakthrough}
2. Sort by effort ascending

### Step 5b: Lead Score Refresh
For each active lead in `internal/leads/*/LEAD_STATUS.md` (not Won/Lost):
1. Read the lead's Signal Log
2. Recalculate `lead_score` per `core/methodology/SIGNAL_DECAY_MODEL.md` formula
3. Update `Lead Score`, `Last Scored`, and `Score Trend` fields
4. Flag any lead whose score crossed a threshold boundary since last calculation:
   - Hot → Warm or Warm → Cold = "going cold" warning
   - Cold → Warm or Warm → Hot = "heating up" notification
5. Flag leads with score declining > 5 pts/week (trend = ↓)
6. Include in brief under `## Lead Pipeline` section

```
── LEAD PIPELINE ──────────────
[ExampleRetail] Score: 12.3 → Warm ↓ (was 22.4) — Stage: Pitched — Next: follow-up by 04-15
[ExamplePress] Score: 31.7 → Hot ↑ — Stage: Discovery — Next: schedule call
[Acme Corp] Score: 4.1 → Cold ↓ — Stage: Dormant — Last signal: 68 days ago
```

### Step 5c: Signal Detection
1. Check if AuthoredUp API is connected in this session
2. Follow the priority chain in `core/methodology/SIGNAL_DETECTION_RULE.md`:
   - AuthoredUp available → pull saved posts, check for tracked profile activity
   - AuthoredUp unavailable → WebFetch LinkedIn profiles of P0 contacts
   - WebFetch fails → ask user about tracked profile posts
3. For any detected signals: run signal routing per `core/sops/decision-trees/signal-routing.md`
4. If signals match a lead → update Signal Log + recalculate score (Step 5b)

### Step 6: Format brief

## Output Format

```
MORNING BRIEF — YYYY-MM-DD
═══════════════════════════

P0s: {count} across {N} projects
Overdue: {count} across {N} projects
Stale @waiting: {count} ({N} contacts)
Quick wins: {count} available

── P0 TASKS ──────────────────
[Diego] #53 Fix GA4 consent mode — Due: today — Owner: László
[Arcanian] #1 Ship ExampleRetail Prism — Due: 03-25 — Owner: László

── OVERDUE ────────────────────
[Diego] #41 Feed audit (3 days) — Owner: Éva
[Mancsbázis] #12 Meta pixel fix (1 day) — Owner: László
[Wellis] #28 Email flow review (5 days) — Owner: Dóra

── STALE @WAITING ─────────────
Bacsa Gábor (2 tasks):
  [Diego] #8 GTM access — 12 days
  [Diego] #19 Feed URL — 9 days
ITG Jenő (1 task):
  [Mancsbázis] #5 Server access — 14 days

── QUICK WINS ─────────────────
[Deluxe] #7 Update .gitignore (15m, lever)
[Diego] #44 Tag audit export (30m, unlock)
[Arcanian] #22 LinkedIn post draft (45m, lever)
[Wellis] #31 CRM field cleanup (1h, lever)

═══════════════════════════════
```

### Step 6b: Metric Anomalies (if Databox MCP connected)
For each client with `data/BASELINES.md`:
1. Load baselines and `alarm_sensitivity` from `CLIENT_CONFIG.md` (default: `normal`)
2. Pull key metrics via Databox MCP
3. **Before flagging:** check sync lag from `DOMAIN_CHANNEL_MAP.md` `Typical Lag` column. If data source lag exceeds freshness window, note "awaiting sync" — do NOT flag as anomaly
4. Apply threshold: `baseline_avg ± (std_dev × sensitivity_multiplier)` per `core/methodology/ALARM_CALIBRATION.md`
5. Score via `core/methodology/CONFIDENCE_ENGINE.md`
6. Include in brief only if confidence ≥ 0.4 AND outside threshold

```
── METRIC ALERTS ──────────────
[Wellis] Google Ads ROAS (wellis.hu): 4.2 — baseline 6.8, threshold 5.6 [Confidence: MEDIUM]
[Diego] GA4 sessions: awaiting sync (Shopify lag ~48h) — not flagging yet
```

## Notes

- This skill is **read-only**. It never modifies files.
- Keep output scannable — the goal is a 60-second morning orientation.
- If a project has no TASKS.md or it's empty, skip it silently.
- Hub path: `/Users/endre/Sites/_arcanian-ops/` — adjust if hub location changes.
- For deeper project context, follow up with `/preflight` in the specific project directory.
