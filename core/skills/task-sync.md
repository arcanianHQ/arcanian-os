> v1.0 — 2026-03-24

# Skill: Task Sync (`/task-sync`)

## Purpose

> **Output posture:** Present sync results with questions. Show what changed. Invite review before applying.

Bidirectional sync between local TASKS.md and external systems (Todoist, Asana). Handles: new tasks, updates, completions, conflicts, and batch rate limiting.

## Trigger

- `/task-sync` — sync current project's TASKS.md with its configured external system
- `/task-sync {client}` — sync specific client from hub root
- `/task-sync all` — sync ALL projects (batch, rate-limited)
- `/task-sync pull` — one-way: pull from external → local only
- `/task-sync push` — one-way: push local → external only

## Prerequisites

- External system MCP connected (Todoist or Asana)
- `sync:` field in TASKS.md frontmatter (todoist/asana/none)
- `sync_id:` = external project ID (if known)

## Sync Mapping

### Project ↔ External System

| Local project | sync: | External project | sync_id |
|---|---|---|---|
| Hub (TASKS.md) | todoist | Todoist project TBD | TBD |
| clients/example-ecom | asana | C:ExampleBrand Transition | EXAMPLE-ID-001 |
| clients/example-retail | todoist | TBD | TBD |
| clients/examplelocal | todoist | TBD | TBD |
| clients/ExampleBuild | todoist | TBD | TBD |
| internal | todoist | TBD | TBD |

**First sync:** If `sync_id` is empty, list external projects and ask user to map.

### Task ↔ External Task

| Local field | Todoist field | Asana field |
|---|---|---|
| title | content | name |
| notes + ontology | description | notes |
| priority (P0-P3) | priority (4-1, inverted) | custom_field |
| due_date | due.date | due_on |
| status=done | is_completed | completed |
| task_type (@next etc) | labels[] | tags[] |
| impact | labels[] (custom) | custom_field |
| owner | responsible_uid (via TEAM_DIRECTORY.md) | assignee |
| domain | labels[] (one per domain, or "all-domains") | custom_field |
| Waiting on | description (structured) | notes |
| Waiting since | description (structured) | notes |
| Follow-up date (@waiting) | due.date (OVERRIDES task due) | due_on |
| Depends on / Blocks | description (structured) | dependencies |
| ext: | task ID | task gid |
| synced: | (local tracking) | (local tracking) |

**Todoist priority inversion:** P0→4, P1→3, P2→2, P3→1
**@waiting due override:** For @waiting tasks, Todoist due = Follow-up date (when to poke), not the task's Due date. This ensures Todoist reminds you on the right day.

## Process

### Step 0: Detect Session User

Before syncing, identify who is running this session:

1. Read `~/.claude/user.json` → get `name`, `email`
2. If not found, check `$USER` env var → map: `endre` = [Owner]
3. If still unknown, ask: "Who is running this session? ([Owner] / [Team Member 1] / [Team Member 2])"
4. Save to `~/.claude/user.json` for future sessions

Use the team directory (`core/methodology/TEAM_DIRECTORY.md`) to map the user to:
- Todoist `responsibleUser` email
- Asana `assignee` email
- Default owner for new tasks in this project

**When pushing tasks:**
- Tasks owned by the current user → push as their Todoist tasks
- Tasks owned by other team members → push with correct `responsibleUser`
- Tasks owned by external people (Pali, Viktor) → push without assignee, add owner in description

**When pulling tasks:**
- Tasks assigned to the current user in Todoist → mark as their tasks locally
- Tasks assigned to others → preserve the owner field

### Step 1: Read Local State

```
Read TASKS.md → parse all tasks with their metadata
Build local task map: { task_number: { title, priority, status, ext, synced, updated } }
```

### Step 2: Read External State

```
Todoist: find-tasks(projectId: sync_id, limit: 100)
  → BATCH: 10 per call, 3s delay (MCP_RATE_LIMITS rule)
Asana: get_tasks(project: sync_id)
Build external task map: { ext_id: { title, priority, status, updatedAt } }
```

### Step 3: Classify Each Task

For every task (local + external), determine action:

```
A) LOCAL ONLY (has task #N, no ext:)
   → CREATE in external system
   → Store ext: ID + synced: now

B) EXTERNAL ONLY (has ext ID, no local match)
   → CREATE in TASKS.md
   → Assign next task number
   → Add ext: + synced:

C) BOTH EXIST — compare timestamps:
   C1) local.Updated > synced AND external.updatedAt <= synced
       → PUSH local to external (local wins)
   C2) external.updatedAt > synced AND local.Updated <= synced
       → PULL external to local (external wins)
   C3) BOTH changed since synced
       → CONFLICT — flag for manual resolution
   C4) Neither changed
       → NO-OP

D) LOCAL DONE, EXTERNAL OPEN
   → Complete in external system

E) EXTERNAL DONE, LOCAL OPEN
   → Move to TASKS_DONE.md (with completion date)
```

### Step 4: Present Sync Plan (BEFORE executing)

**Never auto-sync. Always show the plan first.**

```
SYNC PLAN — clients/example-ecom ↔ Asana

CREATE in Asana (local → external): 3 tasks
  #77 Roivenue BigQuery billing (P0)
  #78 Roivenue status (P2, @waiting)
  #60 IT requests (P0)

PULL from Asana (external → local): 2 tasks
  "Review Q1 ads report" (new in Asana, not in local)
  "Update landing page copy" (new in Asana)

PUSH to Asana (local wins): 5 tasks
  #12 disableAutoConfig → priority changed P1→P0
  #30 consent-gate → added SOP reference

COMPLETE in Asana: 1 task
  #46 Todoist cleanup (done locally)

CONFLICTS: 1 task
  #22 Ad spend analysis
    Local: changed title + priority on 2026-03-24
    Asana: changed assignee on 2026-03-24
    → Which version? [local / external / merge]

Apply this plan? [yes / modify / cancel]
```

### Step 4b: Enrich Tasks Before Sending (MANDATORY)

Before ANY task is sent to Todoist/Asana, enrich the description with ontology:

```
Todoist task description MUST include:
─────────────────────────────────────
Layer: L5
Domain: example-d2c.com
FND: FND-009, FND-011
SOP: [audit-framework]/02-phase-1-browser
Goal: Q1-examplelocal-compliant
Client: examplelocal
Local task: #9
Waiting on: Viktor — keret jóváhagyás    ← if @waiting
Waiting since: 2026-03-26                ← if @waiting
Follow-up: 2026-03-28                    ← if @waiting
Depends on: #113                         ← if has dependencies
Blocks: #115, #116                       ← if blocks other tasks

Ontology edges from TASKS.md — NOT just the title.
─────────────────────────────────────
```

**Mapping to Todoist fields:**

| Local field | Todoist field | How |
|---|---|---|
| Title | `content` | Title as-is |
| Layer + Domain + FND + SOP + Goal + Waiting + Depends/Blocks | `description` | Concatenate all edges as text |
| Priority P0-P3 | `priority` p1-p4 (inverted) | P0→p1, P1→p2, P2→p3, P3→p4 |
| Due date | `dueString` | Date as-is |
| Owner | `responsibleUser` (if project has collaborators) | Match by name via TEAM_DIRECTORY.md |
| GTD type @next/@waiting | `labels` | Create labels: "next", "waiting", "monitor", "decision" |
| Effort | `duration` | Map: "15m"→15, "1h"→60, "4h"→240, "1d"→480 |
| Domain | `labels` | Create label per domain: "example-d2c.com", "example-ecom.com", etc. |
| Impact | `labels` | Create labels: "impact-lever", "impact-unlock", etc. |
| @waiting Follow-up date | `dueString` | If @waiting: use Follow-up date as due (not the task Due), so Todoist reminds to poke |
| From | `description` | "From: {name} ({source})" line in description |
| Inform | Todoist followers / description | If Inform names are Todoist collaborators → add as followers. Otherwise → in description. |

**Example 1: Regular @next task sent to Todoist:**
```json
{
  "content": "#113 ASAP összekötések — sGTM, BigQuery, GTM admin",
  "description": "Layer: L5\nDomain: example-d2c.com\nSOP: 08-MEASUREMENT-SETUP\nGoal: Q1-examplebrand-measurement\nClient: examplebrand\nLocal task: #113\nDepends on: —\nBlocks: #115 (hirdetési keret növelés)",
  "priority": "p1",
  "labels": ["next", "computer", "impact-unlock", "example-d2c.com"],
  "dueString": "2026-03-26",
  "duration": 480,
  "durationUnit": "minute"
}
```

**Example 2: @waiting task sent to Todoist:**
```json
{
  "content": "#115 Hirdetési keret növelés — napi +$500",
  "description": "Layer: L5\nDomain: example-d2c.com\nSOP: 05-CAMPAIGN-MANAGEMENT\nClient: examplebrand\nLocal task: #115\nWaiting on: Viktor + [Agency A] — keret jóváhagyás\nWaiting since: 2026-03-26\nFollow-up: 2026-03-28 — [Owner] emlékeztető [Name]nak\nDepends on: #113",
  "priority": "p1",
  "labels": ["waiting", "impact-unlock", "example-d2c.com"],
  "dueString": "2026-03-28",
  "duration": 60,
  "durationUnit": "minute"
}
```

Note: @waiting tasks use the **Follow-up date** as `dueString`, not the task Due date. This way Todoist reminds you to poke on the right day.

**Example 3: Multi-domain task:**
```json
{
  "content": "#138 Semrush — hozzáférés és beállítás",
  "description": "Layer: L5\nDomain: example-d2c.com, example-b2b.com, example-ecom.com, examplebrand.fr, examplebrand.nl, examplebrand.com, examplebrandfactorystore.com\nSOP: 07-VENDOR-ACCESS\nClient: examplebrand\nLocal task: #138",
  "priority": "p2",
  "labels": ["next", "computer", "impact-lever", "all-domains"],
  "dueString": "2026-03-29",
  "duration": 60,
  "durationUnit": "minute"
}
```

For tasks with 3+ domains, use "all-domains" label instead of listing each.

**Warnings before sending:**
- "⚠ Task #N has no Layer — add Layer before syncing?"
- "⚠ Task #N is @waiting but missing 'Waiting on:' — who are we waiting for?"
- "⚠ Task #N in multi-domain client has no Domain: — which domain does this apply to?"

### Step 5: Execute (with rate limiting)

After user confirms:
```
Batch 1: create tasks in external (10 max per call, 3s delay)
  → Each task has enriched description with ontology
Batch 2: push updates (10 max per call, 3s delay)
Batch 3: complete tasks
Batch 4: pull tasks → add to TASKS.md

On 429: wait retry_after, halve batch, retry (max 3 retries)
```

### Step 6: Update Local TASKS.md (MANDATORY after every sync)

After successful sync, update EVERY synced task in TASKS.md:

**For newly created tasks (local → external):**
```markdown
- [ ] #9 Add consent gating to all Google tags
  - @next @computer
  - P0 | Owner: [Owner] | Effort: 2h | Impact: hygiene
  - Created: 2026-03-13 | Updated: 2026-03-24
  - Layer: L5
  - FND: FND-002, FND-003, FND-011
  - ext: 8345678901 | synced: 2026-03-24T16:30    ← ADD THESE
```

**For pulled tasks (external → local):**
Create full task format with ALL ontology edges populated:
- Ask: "What Layer is this? What's the impact?" before adding
- Don't add skeleton tasks — every task needs Layer + Impact minimum

**Update frontmatter:**
```yaml
sync_id: "6X3pHvWMP9xHHXgM"   ← store project ID after first sync
updated: 2026-03-24T16:30
```

**Log to CAPTAINS_LOG:**
```
## 2026-03-24 — Task sync: examplelocal ↔ Todoist
- Created 14 tasks in Todoist (sections: P0-P3)
- Pulled 1 task from Todoist ("olcsó kutyatáp kampány")
- All tasks enriched with Layer/FND/SOP in Todoist description
- ext: IDs stored in TASKS.md
```

### Step 7: Handle Already-Synced Inconsistencies

**For tasks that have Todoist project references but no ext: ID (current hub state):**

```
Hub TASKS.md currently has:
  - [ ] #40 Linear/Asana/Todoist egységesítés
    - Todoist: 89 Internal IT    ← project name, NOT task ID

This needs migration:
1. Search Todoist for matching task by title
2. If found → add ext: {todoist_task_id}
3. If not found → mark as LOCAL ONLY (needs creating in Todoist)
4. Replace "Todoist: 89" with proper ext: + synced: fields
```

## `/task-sync all` — Hub-Wide Sync

From hub root, sync ALL projects sequentially:
```
1. Read PROJECT_REGISTRY → list of all clients with sync targets
2. For each client with sync != none:
   a. Read their TASKS.md
   b. Connect to their external system
   c. Run Steps 1-6
   d. Wait 5s between clients (rate limit safety)
3. Summary:
   "Synced 8 projects. Created 12, updated 23, conflicts 3, completed 5."
```

## Conflict Resolution

When both sides changed since last sync:

```
CONFLICT: Task #22 "Ad spend analysis"

LOCAL version (Updated: 2026-03-24):
  P1 → P0, added SOP: 03-FINANCIAL-CONTROLS

EXTERNAL version (updatedAt: 2026-03-24):
  Assignee changed: [Owner] → [Team Member 1]

Options:
  [L] Keep local, overwrite external
  [E] Keep external, overwrite local
  [M] Merge: take priority from local + assignee from external
  [S] Skip (resolve later)
```

**Default: never auto-resolve. Always ask.**

## First-Time Setup (per project)

When a project has never synced (`sync_id` is empty):

1. List external projects: `todoist.find-projects()` or `asana.get_projects()`
2. Show them: "Which Todoist project maps to this client?"
3. User picks → store `sync_id` in frontmatter
4. Run initial sync (classify all tasks as LOCAL ONLY or EXTERNAL ONLY)
5. **For tasks with `Todoist: {project_name}` but no `ext:`:** match by title search

## Rate Limiting (MCP_RATE_LIMITS)

| Operation | Batch size | Delay |
|---|---|---|
| Todoist find-tasks | 100 (single call) | — |
| Todoist add-tasks | 10 | 3s |
| Todoist update-tasks | 10 | 3s |
| Todoist complete-tasks | 10 | 3s |
| Asana get_tasks | 100 (single call) | — |
| Asana create_task | 5 | 2s |
| Asana update_task | 5 | 2s |
