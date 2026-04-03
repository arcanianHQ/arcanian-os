# Ontology Backfill Plan

> v1.0 — 2026-03-26
> Systematic plan to bring all existing tasks/files up to ontology standard.
> Run from hub session. Each phase is independent — do one at a time.

## Priority Order (by impact on system usability)

### Phase 1: @waiting Fields (48 tasks) — HIGHEST IMPACT, smallest batch
**Why first:** These are actively blocking work. People are waiting and nobody can see who/what/when.

```
/task-oversight → shows all @waiting tasks missing fields
For each: add Waiting on: + Waiting since: + Follow-up:
```

Clients affected: examplebrand (26), exampleretail (8), ExamplePress (3), internal (5), examplelocal (2), ExampleBuild (2), example-startup (1), example-edu-editoria (1)

**Effort:** ~1 hour across all projects. Run per-client session.

### Phase 2: FND Backlinks (130 finding files) — HIGH IMPACT
**Why:** Enables `/query FND-039` to show related tasks. Currently one-directional.

For each finding file that has a matching task:
1. Open finding file
2. Add/update `Tasks:` section with all task numbers that reference this FND

Clients affected: exampleretail (48 FND files), examplelocal (21), examplehome (9), example-auto (59)

**Effort:** ~2 hours. Can be scripted — grep TASKS.md for each FND-NNN, then update the FND file.

### Phase 3: Domain Field (active multi-domain clients only)
**Why:** Enables filtering "what's open on example-d2c.com?"

Only backfill active clients with 2+ domains:
- **examplebrand** (190+ tasks, 8 domains) — biggest but most important
- **exampleretail** (68 tasks, 2 domains — example-retail.com, exampleretail.sk)
- **ExamplePress** (10 tasks, 10+ domains)
- **ExampleBuild** (35 tasks, 2+ domains)

Skip: single-domain clients, stubs, archived

**Effort:** ~2 hours for examplebrand (requires knowing which domain per task), ~30min each for others.

### Phase 4: From/Inform (all active projects)
**Why:** Enables stakeholder tracking. "Who asked for this? Who to tell when done?"

Only backfill where the source is known (from Meeting: field, from task context, from CAPTAINS_LOG):
- Tasks with `Meeting:` → From: = meeting attendees
- Tasks from /council output → From: = /council
- Tasks from audit findings → From: = audit FND-NNN
- Tasks created by user → From: = self or infer from context

**Effort:** ~3 hours across active projects. Best done incrementally — add From/Inform as you touch each task.

### Phase 5: Table-Format Conversion (3 projects)
**Why:** ExampleSoft, ExampleHome, ExampleAuto use table format which can't support ontology fields.

Convert to standard markdown list format (ExampleBrand gold standard).

**Effort:** ~1 hour per project. Can be scripted.

### Phase 6: Goal + Lead + Meeting Edges (low priority)
**Why:** Nice to have, enables richer querying but doesn't block daily work.

- Goal: add to tasks where quarterly goal is obvious from context
- Lead: create LEAD_STATUS.md for clients with active leads
- Meeting: add to tasks sourced from meetings (detectable from CAPTAINS_LOG)

**Effort:** ~4 hours across all projects. Low urgency.

## How to Run Each Phase

### From hub session:
```bash
cd ~/Sites/_arcanian-ops
claude

# Phase 1: Fix all @waiting tasks
/task-oversight
# → Shows all @waiting missing fields
# → Fix per-client: open client session, update each @waiting task

# Phase 2: FND backlinks (can use agent)
# Agent scans TASKS.md for FND-NNN references, opens each FND file, adds Tasks: backlinks

# Phase 3-6: Incremental — add as you touch each project
```

### Per-client session (for focused backfill):
```bash
cd ~/Sites/_arcanian-ops/clients/example-ecom
claude

# "Backfill all @waiting tasks with Waiting on/since/Follow-up"
# "Add Domain: to all P0 and P1 tasks"
# "Add From: to all tasks that have a Meeting: reference"
```

## Backfill Rules

1. **Don't guess.** If you don't know the domain or who requested a task, add `Domain: TBD` or `From: TBD` — don't make it up.
2. **Backfill incrementally.** Don't try to do all 500 tasks at once. Do one phase at a time, one project at a time.
3. **Start with active projects.** ExampleBrand, ExampleRetail, Internal first. Stubs and archived projects last (or never).
4. **Auto-sync after backfill.** Run `/task-sync push` after each project to push enriched tasks to Todoist.
5. **Update coverage table.** After each phase, re-run the audit to track progress.

## Coverage Targets

| Edge | Current | After Phase 1 | After Phase 3 | After Phase 6 |
|------|:-------:|:-------------:|:-------------:|:-------------:|
| Layer | ~92% | 92% | 92% | 95%+ |
| Waiting on/since/Follow-up | 0% | **100%** | 100% | 100% |
| FND backlinks | 0% | 0% | **100%** | 100% |
| Domain (multi-domain) | 2% | 2% | **>50%** | >80% |
| From/Inform | 0% | 0% | 0% | **>60%** |
| Goal | 8% | 8% | 8% | >30% |
