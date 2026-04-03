> v1.0 — 2026-03-24

# Skill: Day Start (`/day-start`)

## Purpose

> **Output posture:** Present observations with questions. Help think, don't tell.

Morning routine: pull from Todoist, update local, show what needs attention. Run at the start of every work day.

## Trigger

- `/day-start` — run manually
- Session-start hook (auto-run when first session of the day opens)
- Scheduled: 8:00 AM on Mac mini

## Process

### 1. Sync ALL projects with Todoist (bidirectional pull)

**Every project syncs to Todoist.** Run from hub root.

For EACH project (hub → internal → all clients):
1. Read TASKS.md frontmatter → get `sync_id`
2. If `sync_id` empty → flag: "Project {name} not mapped to Todoist yet"
3. `todoist.find-tasks(projectId: sync_id, limit: 100)`
4. Compare timestamps: pull where Todoist is newer
5. Tasks completed in Todoist → move to TASKS_DONE.md locally
6. Tasks created in Todoist → pull to TASKS.md (ask for Layer + Impact before adding)
7. Tasks updated in Todoist → update local if Todoist is newer
8. Update `ext:` + `synced:` on all synced tasks
9. Rate limited: 10/batch, 3s delay between projects

### 2. Run /task-oversight

Cross-project task health scan (calls task-overseer agent):
- Overdue tasks (grouped by project, your tasks first)
- Missing Layer / format violations (per TASK_FORMAT_STANDARD.md)
- Stale @waiting (>7 days, grouped by who)
- Sync drift (ext: but synced > 3 days ago)
- Cross-project convergent issues

### 3. Run /morning-brief

Cross-project summary (uses task-oversight data):
- P0 tasks across ALL projects
- Overdue tasks (grouped by project)
- Quick wins available (effort ≤ 1h, impact ≥ lever)

### 4. Check inboxes

For each project:
- Count inbox/ files
- Count upd/ unprocessed items
- Flag aging items (>7 days)

### 5. Check meetings

Pull today's meetings from Fireflies (if any recorded since yesterday):
```
fireflies.get_transcripts(fromDate: yesterday, limit: 5)
```
- New meetings → route to client meetings/ (or flag for classification)
- Extract action items → show for confirmation

### 6. Check .registry-updates

Read `.registry-updates` file — any stale registries flagged by hooks?

### 7. Show Day Start Summary

```
☀️ DAY START — 2026-03-25

TODOIST SYNC:
  ExampleBrand: pulled 3 updates, 1 completed overnight
  ExampleRetail: no changes
  ExampleLocal: 2 new tasks from Todoist

P0 TASKS: 2
  ExampleBrand #77: Roivenue BigQuery billing (Due: today)
  ExampleLocal #9: Consent gating (ASAP)

OVERDUE: 3
  ExampleRetail #53: GTM message bus (3 days)
  ExampleBrand #60: IT requests (2 days)
  Arcanian #10: Euronics follow-up (26 days!)

@WAITING > 7 DAYS: 2
  [Name]: 2 tasks (BigQuery, Windsor)
  Attila (Euronics): 1 task (follow-up)

QUICK WINS: 3
  ExampleBrand #49: Wire Enhanced Conversions (15m, lever)
  ExampleLocal #20: Fix GAds priorities (15m, lever)
  ExampleBrand #22: Add SGTM to referral exclusion (15m, hygiene)

INBOX: 57 files in ExampleRetail, 4 in internal
UPD: nothing new
MEETINGS: 1 new transcript from yesterday

REGISTRIES: BRAND_INDEX needs update (brand/ changed in ExampleLocal)

What would you like to tackle first?
```

### 8. Log

Append to hub CAPTAINS_LOG:
```
## 2026-03-25 — Day start
- Synced: {N} projects, pulled {X} updates, {Y} completions
- P0: {count} | Overdue: {count} | Waiting: {count}
```
