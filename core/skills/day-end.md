---
scope: shared
argument-hint: end-of-day sync and summary
---

> v1.0 — 2026-03-24

# Skill: Day End (`/day-end`)

## Purpose

> **Output posture:** Present observations with questions. Help reflect, don't judge.

End-of-day routine: push local changes to Todoist, process inboxes, capture what happened, prepare for tomorrow.

## Trigger

- `/day-end` — run manually
- Before closing the last session of the day

## Process

### 1. Push ALL projects to Todoist (bidirectional push)

**Every project syncs to Todoist.** Run from hub root.

For EACH project (hub → internal → all clients):
1. Read TASKS.md → find tasks with `Updated > synced` (local is newer)
2. Tasks created locally (no `ext:`) → create in Todoist with enriched description (Layer/FND/SOP/Goal)
3. Tasks updated locally → push to Todoist
4. Tasks completed locally → complete in Todoist
5. Store new `ext:` IDs + update `synced:` timestamps
6. Rate limited: 10/batch, 3s delay between projects
7. If `sync_id` empty → "Project {name} not mapped — run /task-sync {name} first"

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
  Wellis: #77, #60 (BigQuery + IT requests)
  Mancsbazis: #21, #22 (test order cancel + hardcoded GAds removal)
  Arcanian: #43, #44, #45 (Sembly, CarLock, Perplexity)

CREATED TODAY: 4 tasks
  Mancsbazis: #23-#28 (from audit findings)
  Wellis: #80 (from Ákos meeting)

SYNCED TO TODOIST: ✓
  Pushed: 11 tasks (4 new, 7 updates)
  Completed: 7 in Todoist

MEETINGS PROCESSED: 2
  Wellis Ákos weekly → 14 action items extracted
  Mancsbazis Claude Code → 9 action items extracted

DELIVERABLES SENT: 1
  Wellis memo (heti-akos) → tasks extracted ✓

STILL OPEN:
  P0: 1 (Mancsbazis #9 consent gating)
  Overdue: 2 (Diego #53, Euronics follow-up)

TOMORROW'S PRIORITIES:
  1. Mancsbazis #9 — consent gating (P0)
  2. Diego #53 — GTM message bus (P0, overdue)
  3. Euronics — follow up (26 days!)

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
