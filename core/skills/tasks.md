---
scope: shared
argument-hint: "[filter] — show tasks, optional filter"
---

# Skill: Task Management (`/tasks`)

## Purpose

Manages tasks across all Arcanian projects using a unified Palantir-ontology-inspired system. Tasks are stored locally in `TASKS.md` (active) and `TASKS_DONE.md` (archive) per project, with optional sync to external systems (Todoist, Asana, Trello, Bitrix).

## Trigger

Use this skill when:
- User asks to create, update, complete, or review tasks
- User says "add a task", "what's open", "mark done", "what's P0"
- User asks about task status, priorities, or blockers
- User wants to sync tasks with Todoist/Asana
- Working in any project that has a TASKS.md file
- User says `/tasks`

## Rules Reference

Full rules are in: `/Users/endre/Sites/__arcanian_full/memory/TASK_SYSTEM_RULES.md`
Always read that file before first task operation in a session.

## Commands

When invoked, ask what the user needs or detect from context:

### `/tasks` (no args) — Show overview
1. Read `TASKS.md` in the current project root
2. Show summary: count by priority + count by type (@next, @waiting, @monitor, etc.)
3. Show P0 tasks in full
4. Show P1 tasks as one-liners

### `/tasks create` — Create a new task
1. Read `TASKS.md` to find the next task number
2. Ask or infer from context:
   - Task description
   - GTD type (@next, @waiting, @someday, @monitor, @decision, @reminder, @milestone)
   - Context (@computer, @phone, @email, @deep, @quick)
   - Priority (P0-P3)
   - Owner (who DOES the work)
   - **From:** who requested / where it came from + **Inform:** who to notify when done
   - Due date (if applicable)
   - Effort (15m to 2w+)
   - Impact (noise, hygiene, lever, unlock, breakthrough)
   - Layer (L0-L7) — **MANDATORY**
   - **Domain** (which domain — required for multi-domain clients)
   - If @waiting: **Waiting on** (person + what), **Waiting since**, **Follow-up** (date + action)
   - Depends on / Blocks (task dependencies)
   - Ontology edges: FND, REC, SOP, Goal, Meeting, Email (what applies)
3. Format using EXACT line order (per TASK_FORMAT_STANDARD.md):
```
- [ ] #N Task description
  - @type @context
  - P# | Owner: X | Due: Y | Effort: T | Impact: V
  - From: {who} ({source}) | Inform: {who}
  - Created: YYYY-MM-DD | Updated: YYYY-MM-DD
  - Layer: L#
  - Domain: {domain}
  - Waiting on: {who} — {what}     ← if @waiting
  - Waiting since: YYYY-MM-DD      ← if @waiting
  - Follow-up: YYYY-MM-DD — {action} ← if @waiting
  - Depends on: #N | Blocks: #N
  - SOP/FND/REC/Goal/Meeting edges
  - notes...
```
4. Insert into correct priority section in TASKS.md
5. Update frontmatter `updated:`
6. **AUTO-SYNC (bidirectional) with Todoist/Asana** — on EVERY sync operation:
   - Read `sync:` from TASKS.md frontmatter
   - **PULL FIRST:** Before pushing, check ALL tasks with `ext:` IDs for external changes:
     - Task completed in Todoist → mark done locally, move to TASKS_DONE.md, show: "#{N} was completed in Todoist"
     - Priority changed in Todoist → update local priority, move to correct section, show: "#{N} priority changed to P{X} in Todoist"
     - Due date changed in Todoist → update local Due:, show: "#{N} due date changed to {date} in Todoist"
     - Task rescheduled in Todoist → update local, show: "#{N} rescheduled to {date} in Todoist"
     - New task created in Todoist → add to local TASKS.md (ask for Layer + Domain before adding)
   - **THEN PUSH:** Create/update the current task in external system with enriched description (Layer, Domain, From, Inform, ontology)
   - Store `ext:` ID + `synced:` date on the task
   - If @waiting: use Follow-up date as Todoist due (not task Due)
   - If Inform people are Todoist collaborators: add as followers
   - **Show sync summary:** "Synced: 1 pushed, 2 pulled (#{N} completed, #{M} rescheduled)"
   - **This happens automatically — no separate /task-sync needed**
7. **ONTOLOGY ENRICHMENT** (auto, per `core/methodology/ONTOLOGY_ENRICHMENT_RULE.md`):
   - Scan task content for references: FND-NNN, REC-NNN, SOP names, meeting dates, lead names, domain names, goal tags
   - Auto-add detected edges if not already present
   - **Create backlinks:** If task has `FND: FND-039` → open finding file, add `Tasks: #{N}` to it
   - **Create backlinks:** If task has `Lead: euronics` → open LEAD_STATUS.md, add `#{N}` to lead's task list
   - If edges detected from conversation context (user said "from the Ákos meeting"), add `Meeting:` and `From:` automatically

### `/tasks complete #N` — Complete a task
1. Find task #N in TASKS.md
2. Change `- [ ]` to `- [x]` and add date: `- [x] #N Task (YYYY-MM-DD)`
3. Move entire task block to TOP of TASKS_DONE.md
4. Update frontmatter `updated:` in both files
5. **BIDIRECTIONAL SYNC:** Pull all Todoist changes first (completions, priority changes, reschedules), then mark #{N} complete in Todoist
6. **NOTIFY:** If task has `Inform:` field, show: "Notify: {names} that #{N} is done"
7. **ONTOLOGY UPDATE:**
   - If task has `FND:` → check: is the finding now resolved? Update finding status if all related tasks are done.
   - If task has `Lead:` → update LEAD_STATUS.md timeline with completion.
   - If task has `Blocks:` → check blocked tasks: are they now unblocked? Suggest moving to @next.

### `/tasks update #N` — Update a task
1. Find task #N in TASKS.md
2. Apply requested changes (priority, status, labels, notes, etc.)
3. Update `Updated:` date to today
4. If priority changed, move to correct section
5. Update frontmatter `updated:`
6. **BIDIRECTIONAL SYNC:** Pull all Todoist changes first, then push #{N} update to Todoist/Asana

### `/tasks move #N P#` — Change priority
1. Find task #N
2. Remove from current section
3. Update the P# in metadata line
4. Insert into new priority section
5. Update `Updated:` and frontmatter

### `/tasks waiting` — Show all @waiting tasks
Filter and display all tasks with @waiting label, grouped by who we're waiting on.

### `/tasks next` — Show all @next tasks
Filter and display actionable tasks, sorted by priority then effort (quick wins first).

### `/tasks monitor` — Show all @monitor tasks
Show monitoring tasks with their Check/Baseline/Target/Frequency fields.

### `/tasks wontdo #N` — Mark as wont-do
1. Change to `- [x] #N Task — wont-do (YYYY-MM-DD)`
2. Move to TASKS_DONE.md
3. Add reason in notes

### `/tasks sync` — Sync with external system
1. Read frontmatter `sync:` to determine target (todoist/asana/trello/bitrix)
2. For each task with `ext:` ID:
   - Compare `Updated:` vs external `updatedAt` vs `synced:`
   - Push/pull based on which is newer
   - Flag conflicts (both changed since last sync)
3. For tasks without `ext:` — create in external system, store ID
4. Update `synced:` timestamps

### `/tasks search <query>` — Search tasks
Search task descriptions, notes, and ontology edges for the query string.

### `/tasks quick-wins` — Show low-effort high-impact tasks
Filter for Effort ≤ 1h AND Impact ∈ {lever, unlock, breakthrough}, sorted by effort ascending.

## Format Validation

When creating or updating tasks, ALWAYS validate per `core/methodology/TASK_FORMAT_STANDARD.md`:
- [ ] Line order is correct (tags → metadata → From/Inform → timestamps → Layer → Domain → waiting → depends → edges → sync → notes)
- [ ] `Created:` and `Updated:` are present
- [ ] `Layer:` is present — **MANDATORY, no exceptions**
- [ ] Impact is one of: noise, hygiene, lever, unlock, breakthrough
- [ ] GTD label is one of: @next, @waiting, @someday, @reminder, @monitor, @decision, @reference, @milestone
- [ ] Task is in the correct priority section
- [ ] If @waiting: has `Waiting on:`, `Waiting since:`, `Follow-up:`
- [ ] If multi-domain client: has `Domain:` field
- [ ] `From:` and `Inform:` populated when origin/stakeholders are known
- [ ] No empty metadata fields (only include what applies)

## Auto-Sync Behavior

**Tasks sync automatically on create, update, and complete.** No separate `/task-sync` step needed for individual task operations.

`/task-sync` is still available for:
- `/task-sync pull` — pull changes FROM Todoist/Asana (e.g., tasks created on mobile)
- `/task-sync all` — bulk sync ALL projects (used in `/day-start`)
- `/task-sync` — full bidirectional sync with conflict resolution

But for normal task work (create, update, complete), the sync happens inline.

## Project Detection

Detect current project from working directory:
- `_wellis_full/` → sync: asana
- `_diego_full/` → sync: todoist
- `_mancsbazis-full/` → sync: todoist
- `__arcanian_full/` → sync: todoist
- `_deluxe_full/` → sync: todoist
- `_measurement_audit/` → sync: todoist

If no TASKS.md exists in current project root, ask if user wants to create one from the template.

## Impact Decision Helper

If user is unsure about impact, use these questions:
- "If we DON'T do this, what breaks?" → hygiene
- "If we DO this, what multiplies?" → lever
- "What does this unblock?" → unlock
- "Does this change the game?" → breakthrough
- "Does anyone notice?" → noise
