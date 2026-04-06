> v1.0 — 2026-03-24

# Skill: Day End (`/day-end`)

## Purpose

> **Output posture:** Present observations with questions. Help reflect, don't judge.

End-of-day routine: push local changes to [Task Manager], process inboxes, capture what happened, prepare for tomorrow.

## Trigger

- `/day-end` — run manually
- Before closing the last session of the day

## Process

### 1. Push ALL projects to [Task Manager] (bidirectional push)

**Every project syncs to [Task Manager].** Run from hub root.

For EACH project (hub → internal → all clients):
1. Read TASKS.md → find tasks with `Updated > synced` (local is newer)
2. Tasks created locally (no `ext:`) → create in [Task Manager] with enriched description (Layer/FND/SOP/Goal)
3. Tasks updated locally → push to [Task Manager]
4. Tasks completed locally → complete in [Task Manager]
5. Store new `ext:` IDs + update `synced:` timestamps
6. Rate limited: 10/batch, 3s delay between projects
7. If `sync_id` empty → "Project {name} not mapped — run  {name} first"

### 2. Process unextracted deliverables

Scan all clients for sent deliverables without extracted tasks:
```
find clients/*/takeover/correspondence/*-sent.md — check for "Tasks Extracted" section
find clients/*/proposals/*-sent.md — same check
```
If found → "⚠ 2 deliverables sent today without task extraction. Process now?"

### 3. Quick inbox triage

For each project with inbox/ items:
- Show count + aging
- "Process now or leave for tomorrow?"

### 4. Process new meetings

Any Fireflies transcripts from today not yet saved:
```
fireflies.get_transcripts(fromDate: today, limit: 10)
```
- Classify + route
- Extract action items
- Save raw transcripts

### 5. Day Summary

```
🌙 DAY END — 2026-03-25

COMPLETED TODAY: 7 tasks
  ExampleBrand: #77, #60 (BigQuery + IT requests)
  ExampleLocal: #21, #22 (test order cancel + hardcoded GAds removal)
  Arcanian: #43, #44, #45 (Sembly, CarLock, Perplexity)

CREATED TODAY: 4 tasks
  ExampleLocal: #23-#28 (from audit findings)
  ExampleBrand: #80 (from [Client Contact] meeting)

SYNCED TO [TASK_MANAGER]: ✓
  Pushed: 11 tasks (4 new, 7 updates)
  Completed: 7 in [Task Manager]

MEETINGS PROCESSED: 2
  ExampleBrand [Client Contact] weekly → 14 action items extracted
  ExampleLocal Claude Code → 9 action items extracted

DELIVERABLES SENT: 1
  ExampleBrand memo (heti-akos) → tasks extracted ✓

STILL OPEN:
  P0: 1 (ExampleLocal #9 consent gating)
  Overdue: 2 (ExampleRetail #53, [Retail Lead] follow-up)

TOMORROW'S PRIORITIES:
  1. ExampleLocal #9 — consent gating (P0)
  2. ExampleRetail #53 — GTM message bus (P0, overdue)
  3. [Retail Lead] — follow up (26 days!)

CAPTAINS_LOG entries today: 4
```

### 6. Push Day Summary

- Append to hub CAPTAINS_LOG
- If scheduled morning brief is set up → data ready for tomorrow's 8 AM brief

### 7. Verify everything is saved

- All TASKS.md files have current `updated:` timestamps
- All `ext:` IDs stored for newly synced tasks
- All `synced:` timestamps current
- No unsaved deliverables in chat
- Git: any uncommitted changes? Flag them.
