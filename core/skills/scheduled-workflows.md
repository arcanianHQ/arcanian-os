# Scheduled Workflows

> Reference doc for all recurring automated workflows.
> Managed via `/schedule` (Claude Code triggers) or dedicated server cron.
> Updated: 2026-03-26

## Active Schedules

### 1. Morning Brief — Weekdays 07:00

**Purpose:** Start every workday with full visibility across all projects.
**Frequency:** Monday–Friday, 07:00
**Machine:** dedicated server (always-on)

```
/schedule create --name "morning-brief" \
  --cron "0 7 * * 1-5" \
  --prompt "
    Read ~/.claude/user.json for session user.
    Run /task-sync all (pull from [Task Manager]/Asana, rate-limited).
    Run /task-oversight (scan all projects, flag issues).
    Run /morning-brief (P0s, overdue, quick wins).
    Save combined output to internal/briefs/BRIEF_{date}.md.
    Open in Typora.
  "
```

**Output:** `internal/briefs/BRIEF_2026-03-26.md`

**What it produces:**
- [Task Manager] sync status (what changed overnight)
- Task oversight report (overdue, missing Layer, stale @waiting, sync drift)
- Morning brief (P0s across all projects, quick wins)
- Cross-project warning intelligence (Grabo-lite)

### 2. Weekly Health Check — Monday 08:00

**Purpose:** Full system health scan with Grabo warning intelligence.
**Frequency:** Monday, 08:00
**Machine:** dedicated server

```
/schedule create --name "weekly-health" \
  --cron "0 8 * * 1" \
  --prompt "
    Run /health-check scope:all.
    Include Step 6 Grabo warning intelligence (convergent signals, blind spots).
    Run /task-oversight with cross-project analysis.
    Save to internal/briefs/HEALTH_{date}.md.
    Open in Typora.
  "
```

**Output:** `internal/briefs/HEALTH_2026-03-31.md`

### 3. Daily Inbox Scan — Weekdays 09:00

**Purpose:** Catch unprocessed files before they age past 7 days.
**Frequency:** Monday–Friday, 09:00
**Machine:** dedicated server

```
/schedule create --name "inbox-scan" \
  --cron "0 9 * * 1-5" \
  --prompt "
    Scan all inbox/ directories across clients/ and internal/.
    Count files per project.
    Flag files older than 7 days.
    Alert files older than 14 days (SOP violation).
    Save to internal/briefs/INBOX_{date}.md only if issues found.
  "
```

### 4. Weekly [Task Manager] Full Sync — Sunday 20:00

**Purpose:** Ensure all projects are in sync before the week starts.
**Frequency:** Sunday, 20:00
**Machine:** dedicated server

```
/schedule create --name "weekly-sync" \
  --cron "0 20 * * 0" \
  --prompt "
    Run /task-sync all (bidirectional, all projects).
    Log sync results to internal/briefs/SYNC_{date}.md.
    Flag conflicts for Monday morning review.
  "
```

### 5. Monthly Diagnostic Reminder — 1st of month, 09:00

**Purpose:** Prompt quarterly/monthly diagnostics for active clients.
**Frequency:** 1st of each month, 09:00
**Machine:** dedicated server

```
/schedule create --name "monthly-diagnostic-check" \
  --cron "0 9 1 * *" \
  --prompt "
    For each active client (examplebrand, exampleretail, ExamplePress):
      Check when last /7layer or /council diagnostic was run
      (look for *DIAGNOSTIC* or *COUNCIL* files in docs/).
      If >90 days → flag: 'Client {slug}: no diagnostic in {N} days.
        Consider: /pipeline diagnostic --client {slug} --council'
    Save reminders to internal/briefs/DIAGNOSTIC_REMINDER_{date}.md.
  "
```

### 6. Daily Metric Monitoring — Weekdays 10:00

**Purpose:** Check baselines for active clients, flag anomalies, create tasks for confirmed issues.
**Frequency:** Monday–Friday, 10:00 (after morning brief settles)
**Machine:** dedicated server

```
/schedule create --name "metric-monitor" \
  --cron "0 10 * * 1-5" \
  --prompt "
    For each active client with data/BASELINES.md:
      Load CLIENT_CONFIG.md (alarm_sensitivity).
      Load DOMAIN_CHANNEL_MAP.md (sync lag per source).
      Pull key metrics via Databox MCP.
      Check sync lag BEFORE flagging — skip stale sources.
      Apply thresholds per ALARM_CALIBRATION.md.
      Score confidence per CONFIDENCE_ENGINE.md.
      If confidence >= 0.4 AND outside threshold:
        Create task in TASKS.md with ontology edges.
        Auto-sync to [Task Manager].
      Log all results to data/MONITOR_LOG.md.
    Save summary to internal/briefs/MONITOR_{date}.md.
  "
```

**Output:** `internal/briefs/MONITOR_2026-04-03.md` + per-client `data/MONITOR_LOG.md`

### 7. Weekly Baseline Refresh — Sunday 21:00

**Purpose:** Keep baselines current so anomaly detection stays calibrated.
**Frequency:** Sunday, 21:00 (after weekly sync)
**Machine:** dedicated server

```
/schedule create --name "baseline-refresh" \
  --cron "0 21 * * 0" \
  --prompt "
    For each active client with data/BASELINES.md:
      Pull last 30 days of data for each baselined metric via Databox MCP.
      Recalculate avg and std dev.
      Update Last Updated column.
      Flag metrics where std dev changed >50% (volatility shift).
    Log to internal/briefs/BASELINE_REFRESH_{date}.md.
  "
```

### 8. Weekly Outcome Tracker — Friday 16:00

**Purpose:** Check whether executed recommendations actually moved the metrics.
**Frequency:** Friday, 16:00
**Machine:** dedicated server

```
/schedule create --name "outcome-tracker" \
  --cron "0 16 * * 5" \
  --prompt "
    For each active client with RECOMMENDATION_LOG.md:
      Run outcome-tracker agent (core/agents/outcome-tracker.md).
      Update REC statuses: confirmed / no effect / too early / invalidated.
      Update baselines if confirmed RECs shifted metrics sustainably.
      Log to data/MONITOR_LOG.md.
    Save summary to internal/briefs/OUTCOMES_{date}.md.
  "
```

---

## How to Manage Schedules

### List all schedules
```
/schedule list
```

### Create a new schedule
```
/schedule create --name "{name}" --cron "{cron}" --prompt "{what to do}"
```

### Update a schedule
```
/schedule update --name "{name}" --cron "{new_cron}"
```

### Delete a schedule
```
/schedule delete --name "{name}"
```

### Run a schedule manually (test)
```
/schedule run --name "morning-brief"
```

---

## Prerequisites

1. **dedicated server always-on** — schedules run on the dedicated server via Remote Control
2. **MCP servers configured** — [Task Manager], Asana, Databox, Fireflies must be connected
3. **`~/.claude/user.json`** on the dedicated server — identifies the default user for scheduled runs
4. **Claude Code installed** on dedicated server with valid auth token
5. **Remote Control** — `/schedule` uses Claude Code's built-in trigger system

## Output Locations

All scheduled outputs save to `internal/briefs/`:

```
internal/briefs/
├── BRIEF_2026-03-26.md          ← daily morning brief
├── BRIEF_2026-03-27.md
├── HEALTH_2026-03-31.md         ← weekly health check
├── INBOX_2026-03-26.md          ← daily inbox scan (only if issues)
├── SYNC_2026-03-30.md           ← weekly full sync log
├── MONITOR_2026-04-03.md        ← daily metric monitoring
├── BASELINE_REFRESH_2026-04-06.md ← weekly baseline refresh
├── OUTCOMES_2026-04-04.md       ← weekly outcome tracker
└── DIAGNOSTIC_REMINDER_2026-04-01.md  ← monthly diagnostic prompt
```

## Error Handling

- **MCP not connected:** Log "MCP {server} unavailable" in brief, continue with available data
- **TASKS.md not parseable:** Log "Parse error in {project}/TASKS.md" and skip that project
- **Rate limit hit:** Back off per MCP_RATE_LIMITS.md, retry in next batch
- **dedicated server offline:** Schedules queue and run when back online (if using Claude Code triggers)

## Integration with Slack (Future)

When `_claude-slack` bridge is operational:
- Morning brief summary → Slack #arcanian-daily channel
- Overdue alerts → DM to task owner
- Health check warnings → Slack #arcanian-ops channel
