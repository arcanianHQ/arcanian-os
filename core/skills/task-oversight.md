> v1.0 — 2026-04-03

# Skill: Task Oversight (`/task-oversight`)

## Purpose

Cross-project task monitoring. Scans ALL TASKS.md files, finds problems, reports in one view. Run from hub session.

## Trigger

- `/task-oversight` — full scan
- `/task-oversight {client}` — single client
- Part of `/day-start` and `/morning-brief` (called automatically)
- Scheduled: can run on cron via Mac mini

## Process

### Step 1: Discover all TASKS.md files

```bash
find _arcanian-ops/clients -name "TASKS.md" -not -name "TASKS_DONE.md"
# plus: internal/TASKS.md
```

### Step 2: For each project, parse and check

Use the Task Overseer agent (`.claude/agents/task-overseer.md`) or parse directly:

For each open task (`- [ ]`), extract:
- Task number, title
- GTD tag (@next, @waiting, etc.)
- Priority (P0-P3)
- Owner
- Due date
- Layer (L0-L7)
- SOP reference
- ext: / synced: (external sync status)
- Updated: date
- From: (task origin — who/what requested it)
- Inform: (who to notify on completion)

Flag per `core/methodology/TASK_FORMAT_STANDARD.md`:
- **OVERDUE:** Due date < today
- **MISSING LAYER:** No `Layer:` field (MANDATORY)
- **MISSING PRIORITY:** No P0-P3
- **@WAITING HEALTH:**
  - Missing `Waiting on:` field (WHO + WHAT — mandatory for @waiting)
  - Missing `Waiting since:` field (mandatory for @waiting)
  - Missing `Follow-up:` field (mandatory for @waiting)
  - Stale: Waiting since > 7 days without update
  - Overdue follow-up: Follow-up date passed but task still @waiting
- **DEPENDENCY CHAINS:**
  - `Depends on:` task is overdue → flag both tasks
  - `Depends on:` task is done → this task should move to @next
  - Multi-level chains: show full A→B→C chain with root blocker
- **SYNC DRIFT:** ext: present but synced: > 3 days ago
- **NO OWNER:** Missing Owner field
- **FORMAT VIOLATION:** Doesn't match gold standard (ExampleBrand format)

### Step 3: Detect user and highlight their tasks

Read `~/.claude/user.json` → get current user name.
Highlight their overdue and P0 tasks first.
Also highlight tasks where THEY are in the `Waiting on:` field (someone is waiting for them).

### Step 4: Cross-project analysis (Grabo-lite)

After scanning all projects:
- **Convergent issues:** Same problem in 2+ projects (e.g., "3 projects have stale @waiting >14 days")
- **Capacity signal:** Total P0 + overdue across all projects. If > 20 → flag capacity risk.
- **Waiting bottleneck:** Person who appears most in `Waiting on:` fields across all projects. If one person is blocking 5+ tasks → flag.
- **Dependency depth:** Longest chain (A→B→C→D). If >3 deep → flag as risk.
- **Sync health:** Projects where synced: is more than 3 days old.
- **Stakeholder load:** Person appearing most in `From:` fields across all projects. If one person originates 10+ open tasks → flag as single-source risk.
- **Notification queue:** Tasks completed today where `Inform:` includes people. List who needs to be notified and about what.

### Step 5: Output

```
TASK OVERSIGHT — {date}
User: {name} (from ~/.claude/user.json)
═══════════════════════════════════════

SUMMARY:
  Projects scanned: {N}
  Total open tasks: {N}
  Your P0s: {N} | Your overdue: {N}
  System overdue: {N} | Missing Layer: {N}
  Stale @waiting: {N} | Sync drift: {N}

── YOUR OVERDUE ──────────────────
{your_name}'s overdue tasks, sorted by days:
  [{project}] #{N} {title} — {N} days overdue

── ALL OVERDUE ({count}) ─────────
{project}: {count}
  #{N} {title} — due {date} — Owner: {who}

── MISSING LAYER ({count}) ───────
{project}: {count}
  #{N} {title}

── STALE @WAITING ({count}) ──────
{project}: #{N} {title} — waiting {N} days on {who}

── SYNC DRIFT ({count}) ──────────
{project}: last synced {date} ({N} days ago)

── CROSS-PROJECT SIGNALS ─────────
{convergent issues, capacity warnings}

── QUICK WINS ({count}) ──────────
{project}: #{N} {title} — {effort} — {impact}

═══════════════════════════════════
Actions:  to push |  all to sync everything
```

### Step 6: Auto-save

Save to `internal/briefs/TASK_OVERSIGHT_{date}.md`.
If run as part of /morning-brief, include in the morning brief output.

## Integration

```
/day-start calls:
  1.  all (pull from [Task Manager]/Asana)
  2. /task-oversight (scan + report)
  3. /morning-brief (uses oversight data)

/schedule (future):
  - Daily 07:00: /task-oversight → save → notify
  - Weekly Monday 08:00: /task-oversight + /health-check → combined report
```
