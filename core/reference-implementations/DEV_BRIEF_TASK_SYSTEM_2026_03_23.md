# Developer Brief: Arcanian Task Management System

**Date:** 2026-03-23
**Author:** [Owner Name] (owner@example.com)
**Status:** Ready for development
**Priority:** High — this is the operational backbone for the entire practice

---

## 1. Executive Summary

Build a task management system that functions as a **lightweight knowledge graph** — inspired by Palantir's Ontology layer. Tasks are not flat items; they are nodes with typed relationships (edges) to other business objects: findings, SOPs, goals, meetings, emails, and people.

The system currently runs as markdown files managed by Claude Code AI. This brief describes how to build it as a **standalone application** that preserves the ontology model while adding real-time sync, multi-user access, and visual interfaces.

### Why This Exists

We run a fractional CMO practice with 6+ concurrent projects. Each project has 10-300 tasks. Tasks originate from different sources (audit findings, SOPs, meetings, emails, goals) and sync to different external systems ([Task Manager], Asana, Trello, Bitrix) per client. No existing tool handles all of this — they either do flat task lists ([Task Manager]) or complex project management (Asana/Monday) but none model the *relationships between tasks and business objects*.

### Current State (working, needs to be replaced)

- 6 projects with `TASKS.md` + `TASKS_DONE.md` files (markdown, ~200+ active tasks total)
- A Claude Code AI skill (`/tasks`) that creates, updates, completes, and syncs tasks
- Timestamp-based conflict resolution for bidirectional sync
- GTD labeling system for task types
- Custom impact scale (noise → breakthrough) for prioritization

---

## 2. Core Data Model

### 2.1 Task (Primary Entity)

Every task has these properties:

| Property | Type | Required | Example |
|---|---|---|---|
| `id` | Integer | Yes | `53` (sequential per project, never reused) |
| `project_id` | FK → Project | Yes | `examplebrand` |
| `title` | String | Yes | `Fix dead GTM message bus` |
| `status` | Enum | Yes | `open`, `in_progress`, `done`, `blocked`, `wont_do` |
| `priority` | Enum | Yes | `P0`, `P1`, `P2`, `P3` |
| `task_type` | Enum | Yes | `next`, `waiting`, `someday`, `reminder`, `monitor`, `decision`, `reference`, `milestone` |
| `context_labels` | Array<Enum> | No | `["computer", "deep"]` |
| `owner` | String | No | `[Owner]` |
| `due_date` | Date | No | `2026-04-07` |
| `effort` | Enum | No | `15m`, `30m`, `1h`, `2h`, `4h`, `1d`, `2d`, `3d`, `1w`, `2w+` |
| `impact` | Enum | Yes | `noise`, `hygiene`, `lever`, `unlock`, `breakthrough` |
| `created_at` | Date | Yes | `2026-03-23` (immutable) |
| `updated_at` | Date | Yes | `2026-03-23` (auto-set on any change) |
| `layers` | Array<Enum> | No | `["L5", "L6"]` — which framework layers this task touches |
| `notes` | Text | No | Free text context |
| `completion_date` | Date | No | Set when status → done/wont_do |
| `completion_note` | String | No | `"Fixed in ws116"` |

### 2.2 Ontology Edges (Relationships)

Tasks connect to other business objects via **typed edges**. These are the key differentiator from every other task tool.

| Edge Type | Target Object | Cardinality | Example |
|---|---|---|---|
| `finding` | Finding (FND) | Many-to-Many | `FND-039`, `FND-002` |
| `recommendation` | Recommendation (REC) | Many-to-Many | `REC-039` |
| `sop` | Process/SOP document | Many-to-Many | `05-CAMPAIGN-MANAGEMENT`, `MEASUREMENT_HEALTH_SOP → Phase 3` |
| `goal` | Goal (shallow tag) | Many-to-Many | `Q1-ship-prism`, `Q1-examplebrand-revenue` |
| `meeting` | Calendar event | Many-to-Many | `2026-03-10 IT vezető ([Name])` |
| `email` | Email thread | Many-to-Many | `Jenő 2026-03-04 "JSON-LD duplicate block"` |
| `layer` | Framework Layer (L0-L7) | Many-to-Many | `L1`, `L5, L7` |
| `depends_on` | Task | Many-to-Many | `#13 GD contract signed` |
| `blocks` | Task | Many-to-Many | (inverse of depends_on) |

**Edge storage:** Each edge is a row in an `edges` table:
```
task_id | edge_type | target_type | target_id | target_label
53      | finding   | FND         | FND-039   | NULL
53      | sop       | SOP         | NULL      | "MEASUREMENT_HEALTH_SOP → Phase 3"
10      | meeting   | Meeting     | NULL      | "2026-03-10 IT vezető"
```

Some targets are structured (FND-039 has its own file), others are text labels (meetings, emails). The system should handle both — don't force users to create a "Meeting" entity just to link a task to a call.

### 2.3 External Sync Metadata

| Property | Type | Required | Example |
|---|---|---|---|
| `sync_system` | Enum | No | `[task-manager]`, `asana`, `trello`, `bitrix`, `none` |
| `ext_id` | String | No | `000000000000` (task ID in external system) |
| `synced_at` | DateTime | No | `2026-03-23T14:30` (minute precision needed) |

Inherited from project default if not set on task.

### 2.4 Monitor Task Extensions

When `task_type = monitor`, these additional fields are available:

| Property | Type | Example |
|---|---|---|
| `check` | String | `Meta Commerce Manager → HU → Match Rate` |
| `baseline` | String | `60.6% (2026-03-07)` |
| `target` | String | `75%+` |
| `frequency` | String | `weekly until stable` |
| `risk` | String | `Theme update can break dataLayer` |

### 2.5 Project

| Property | Type | Example |
|---|---|---|
| `id` | String (slug) | `examplebrand` |
| `name` | String | `ExampleBrand` |
| `sync_system` | Enum | `asana` |
| `sync_id` | String | `EXAMPLE-ID-001` |
| `location` | String (path) | `/path/to/project/` |

### 2.6 Goal (Lightweight)

Goals are shallow tags — not a full OKR system. No hierarchy.

| Property | Type | Example |
|---|---|---|
| `id` | String (slug) | `Q1-ship-prism` |
| `name` | String | `Ship first Prism (Euronics)` |
| `project_id` | FK → Project | `arcanian` |
| `quarter` | String | `Q1-2026` |

---

## 3. Enumerations

### 3.1 Priority

| Value | Label | Meaning | SLA |
|---|---|---|---|
| `P0` | Critical | System broken, data loss, compliance risk | Fix now |
| `P1` | High | Significant issue, blocks progress | This week |
| `P2` | Medium | Non-critical, improvement | Within 2 weeks |
| `P3` | Low | Nice-to-have, future | At convenience |

### 3.2 Task Type (GTD-based)

| Value | Label | Actionable? | Description |
|---|---|---|---|
| `next` | Next Action | Yes | Ready to do, no blockers |
| `waiting` | Waiting For | No (someone else) | Delegated or blocked externally |
| `someday` | Someday/Maybe | Not yet | Not committed, review monthly |
| `reminder` | Reminder | No | Awareness only, trigger date |
| `monitor` | Monitor | Check, not do | Periodic verification |
| `decision` | Decision | Think, not do | Needs a choice |
| `reference` | Reference | No | Stored context, not a task |
| `milestone` | Milestone | No | Point in time marker |

### 3.3 Context Labels

| Value | When |
|---|---|
| `computer` | Needs laptop/desk |
| `phone` | Can do by phone |
| `email` | Requires sending/reading email |
| `deep` | Needs focus time (>30 min) |
| `quick` | Can do in <5 min |
| `errand` | Physical location needed |

### 3.4 Impact Scale

This is NOT a standard scale. It was designed to match how our business thinks about value.

| Value | Question it answers | Example |
|---|---|---|
| `noise` | "Does anyone notice?" | Fix Snapchat typo in paused SGTM tag |
| `hygiene` | "If we don't, what breaks?" | Consent gating — GDPR compliance |
| `lever` | "What does this multiply?" | Enhanced Conversions → better Smart Bidding → more ROAS |
| `unlock` | "What does this unblock?" | Fix dead GTM message bus → ALL tracking starts working |
| `breakthrough` | "Does this change the game?" | First Prism delivery → proves the business model |

### 3.5 Effort Scale

| Value | Meaning |
|---|---|
| `15m` | Under 15 minutes |
| `30m` | Under 30 minutes |
| `1h` | About 1 hour |
| `2h` | About 2 hours |
| `4h` | Half day |
| `1d` | Full day |
| `2d` | 2 days |
| `3d` | 3 days |
| `1w` | 1 week |
| `2w+` | Multi-week / project |

### 3.6 Framework Layers (Arcanian Marketing Control Framework)

Every task can be tagged with one or more layers from the Arcanian L0–L7 diagnostic framework. This connects operational tasks to the systemic diagnosis — a task isn't just "do X," it's "fix the system at layer Y."

| Value | Name | What it covers | Task example |
|---|---|---|---|
| `L0` | Source (Forrás) | People's identity, patterns, mindset. WHY they can't change. | `Kocsibeallo [diagnostic profile] — Premium vs Standard identity conflict` |
| `L1` | Core | Organizational capability: structure, capacity, decisions, team. WHAT they can't do. | `[Team Member 2] & [Team Member 1] → operational — delegate delivery` |
| `L2` | Customer | Who the customer is, segments, Target Profile, personas. | `ExampleD2C brand identity + messaging document` |
| `L3` | Value | What value is delivered, product-market fit, offer structure. | `Create offer/pricing page — 3 tiers (Morsel/Nexus/Fractional)` |
| `L4` | Offer | How the value is packaged: pricing, bundling, guarantees. | `Offer optimalizáció (finanszírozás, szezonális, garanciák)` |
| `L5` | Channels | Where marketing happens: SEO, paid, email, social, distribution. | `Attribution kiépítés (GA4 → sGTM → AC → Shopify)` |
| `L6` | Conversion | How leads become customers: funnels, scoring, automation, CRM. | `Lead scoring újraépítés + életciklus automatizálás` |
| `L7` | Intelligence | How you measure, learn, compete: analytics, testing, competitive intel. | `Versenytárs monitoring + piaci intelligencia` |

**Key rules:**
- A task can touch multiple layers (e.g., consent gating = L5 + L7)
- The layer tag answers: "Which layer of the marketing system does this fix or improve?"
- Direction rule: problems cascade L0→L7. Fixing L0 often resolves L1-L7 symptoms.
- This field connects the task system to the diagnostic methodology — it's how we know if we're fixing symptoms or root causes.

**In the markdown format:**
```markdown
- [ ] #93 [L1] OKR keretrendszer + North Star Metric
  - @someday
  - P3 | Owner: [Owner] | Effort: 1d | Impact: breakthrough
  - Created: 2026-02-26 | Updated: 2026-03-23
  - Layer: L1
  - Goal: Q2-examplebrand-systems
```

Multiple layers:
```markdown
- [ ] #30 Document & consent-gate 8+ third-party platforms
  - @next @computer
  - P1 | Owner: [Owner] + ITG | Effort: 4h | Impact: hygiene
  - Created: 2026-03-07 | Updated: 2026-03-23
  - Layer: L5, L7
  - FND: FND-031 | REC: REC-031
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 1 → Consent Check
```

**UI: Layer distribution view.** Show a bar chart or heatmap: how many tasks per layer per project. This reveals where the work is concentrated and whether we're fixing root causes (L0-L2) or symptoms (L5-L7).

**Ontology query:** "Show all L1 tasks across all projects" → reveals the organizational capability gaps we're working on.

### 3.7 External Sync Systems

| Value | API | Auth | Notes |
|---|---|---|---|
| `[task-manager]` | REST API v2 | Bearer token | Primary for most projects |
| `asana` | REST API | OAuth or PAT | Used by ExampleBrand |
| `trello` | REST API | API key + token | Used by some clients |
| `bitrix` | REST API | Webhook or OAuth | Used by ExampleOrg |
| `none` | — | — | Local only |

---

## 4. Sync Engine

### 4.1 Conflict Resolution Algorithm

The system uses **timestamp-based last-write-wins** with conflict flagging.

```
For each task with ext_id:
  1. Fetch external task by ext_id
  2. Compare:
     - local.updated_at vs synced_at
     - external.updatedAt vs synced_at
  3. Decision:
     a) local.updated_at > synced_at AND external.updatedAt <= synced_at
        → LOCAL WINS: push local to external
     b) external.updatedAt > synced_at AND local.updated_at <= synced_at
        → EXTERNAL WINS: pull external to local
     c) BOTH local.updated_at > synced_at AND external.updatedAt > synced_at
        → CONFLICT: flag for manual resolution
     d) Neither changed since last sync
        → NO-OP
  4. After resolution: set synced_at = now()
```

### 4.2 Field Mapping

Not all fields exist in all external systems. Here's the mapping:

| Our Field | [Task Manager] | Asana | Trello | Bitrix |
|---|---|---|---|---|
| `title` | `content` | `name` | `name` | `TITLE` |
| `notes` | `description` | `notes` | `desc` | `DESCRIPTION` |
| `priority` | `priority` (1-4, inverted) | `custom_field` | `label` | `PRIORITY` |
| `due_date` | `due.date` | `due_on` | `due` | `DEADLINE` |
| `status=done` | `is_completed` | `completed` | `closed` | `STATUS=5` |
| `task_type` | `labels[]` | `tags[]` | `labels[]` | `TAGS` |
| `impact` | `labels[]` | `custom_field` | `custom_field` | N/A |
| `effort` | `duration` | `custom_field` | `custom_field` | N/A |
| `owner` | `responsible_uid` | `assignee` | `idMembers[0]` | `RESPONSIBLE_ID` |

**Priority inversion for [Task Manager]:** [Task Manager] uses 1=normal, 4=urgent. We use P0=critical, P3=low. Mapping: P0→4, P1→3, P2→2, P3→1.

### 4.3 Sync for New Tasks

When a task exists locally but has no `ext_id`:
1. Create task in external system using field mapping
2. Store returned ID as `ext_id`
3. Set `synced_at = now()`

When a task exists in external system but not locally:
1. Pull and create locally using reverse field mapping
2. Assign next sequential task number
3. Set `synced_at = now()`

### 4.4 Sync Frequency

- **On-demand:** User triggers `/tasks sync`
- **Scheduled:** Every 15 minutes (configurable)
- **On conflict:** Pause and flag, don't auto-resolve

---

## 5. Views & Queries

The system must support these views efficiently:

### 5.1 Standard Views

| View | Filter | Sort |
|---|---|---|
| **Overview** | All active tasks in project | Priority (P0 first), then by updated_at desc |
| **P0 Critical** | `priority = P0` | Due date asc |
| **Next Actions** | `task_type = next` | Priority, then effort asc |
| **Waiting For** | `task_type = waiting` | Owner, then due date |
| **Monitoring** | `task_type = monitor` | Frequency/next check date |
| **Decisions** | `task_type = decision` | Due date asc |
| **Quick Wins** | `effort <= 1h AND impact IN (lever, unlock, breakthrough)` | Effort asc |
| **Blockers** | `status = blocked OR task_type = waiting` | Priority |
| **By Owner** | Group by owner | Priority within group |
| **By Goal** | Group by goal edge | Priority within group |
| **By SOP** | Group by SOP edge | Priority within group |
| **Done (archive)** | `status IN (done, wont_do)` | Completion date desc |

### 5.2 Cross-Project Views

| View | Description |
|---|---|
| **All P0s** | P0 tasks across all projects |
| **All Waiting** | All @waiting tasks across projects, grouped by who |
| **All Quick Wins** | Quick wins across all projects |
| **My Tasks** | All tasks where `owner = current_user` across projects |
| **This Week** | All tasks with `due_date` within current week |
| **Overdue** | All tasks with `due_date < today AND status = open` |

### 5.3 Ontology Queries

These are the queries that make this system different from a flat task manager:

| Query | Description |
|---|---|
| "Show all tasks linked to FND-039" | Filter by finding edge |
| "What tasks follow SOP 05-CAMPAIGN-MANAGEMENT?" | Filter by SOP edge |
| "What tasks serve Goal Q1-ship-prism?" | Filter by goal edge |
| "What tasks have a meeting this week?" | Filter by meeting edge + date |
| "Show the FND → REC → Task chain for ExampleRetail" | Traverse finding → recommendation → task edges |
| "What goals have no tasks?" | Goals without incoming task edges |
| "What SOPs have no tasks referencing them?" | Orphan SOPs |
| "Show all L1 tasks across projects" | Filter by layer edge — reveals organizational capability gaps |
| "Layer distribution for ExampleBrand" | Count tasks per layer — heatmap showing where work concentrates |
| "Are we fixing root causes or symptoms?" | Compare L0-L2 task count vs L5-L7 — low L0-L2 = symptom-chasing |

---

## 6. API Design

### 6.1 Task CRUD

```
POST   /api/projects/:projectId/tasks          — Create task
GET    /api/projects/:projectId/tasks           — List tasks (with filters)
GET    /api/projects/:projectId/tasks/:taskId   — Get single task
PATCH  /api/projects/:projectId/tasks/:taskId   — Update task
DELETE /api/projects/:projectId/tasks/:taskId   — Soft delete (move to archive)
```

### 6.2 Task Actions

```
POST   /api/projects/:projectId/tasks/:taskId/complete   — Complete (move to archive)
POST   /api/projects/:projectId/tasks/:taskId/wontdo     — Mark as wont-do
POST   /api/projects/:projectId/tasks/:taskId/move       — Change priority/project
```

### 6.3 Edges

```
POST   /api/projects/:projectId/tasks/:taskId/edges      — Add edge
DELETE /api/projects/:projectId/tasks/:taskId/edges/:edgeId — Remove edge
GET    /api/projects/:projectId/tasks/:taskId/edges       — List edges for task
GET    /api/edges?type=finding&target=FND-039             — Find tasks by edge
```

### 6.4 Sync

```
POST   /api/projects/:projectId/sync              — Trigger sync for project
GET    /api/projects/:projectId/sync/status        — Get sync status + conflicts
POST   /api/projects/:projectId/sync/resolve/:taskId — Resolve conflict (local/remote)
```

### 6.5 Views

```
GET    /api/views/quick-wins?project=all           — Quick wins across projects
GET    /api/views/waiting?project=all              — All waiting tasks
GET    /api/views/overdue?project=all              — All overdue
GET    /api/views/by-goal/:goalId                  — Tasks for a goal
GET    /api/views/by-sop/:sopId                    — Tasks for an SOP
```

### 6.6 Markdown Export/Import

```
GET    /api/projects/:projectId/export/markdown    — Export TASKS.md format
POST   /api/projects/:projectId/import/markdown    — Import from TASKS.md
```

This is critical — the markdown format is the canonical representation. The system must be able to round-trip perfectly: export → edit in text editor → import → no data loss.

---

## 7. Markdown Parser/Serializer

The most technically complex piece. The system must parse and generate the exact markdown format.

### 7.1 TASKS.md Structure

```markdown
---
project: "examplebrand"
sync: asana
sync_id: "EXAMPLE-ID-001"
updated: 2026-03-23T18:00
---

# ExampleBrand — Tasks

> Header text (ignored by parser, preserved on export)

---

## P0 — Critical

- [ ] #1 Task title here
  - @next @computer
  - P0 | Owner: [Owner] | Due: 2026-04-07 | Effort: 4h | Impact: unlock
  - Created: 2026-02-26 | Updated: 2026-03-23
  - FND: FND-039 | REC: REC-039
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 3
  - Goal: Q1-ship-prism
  - Meeting: 2026-03-10 IT vezető
  - Email: Jenő 2026-03-04 "JSON-LD duplicate"
  - ext: 000000000000 | synced: 2026-03-23T14:30
  - Free text notes on the last line(s)
```

### 7.2 Parser Rules

**Task detection:** A line matching `- [ ] #\d+` or `- [x] #\d+` starts a new task block.

**Metadata lines:** All subsequent lines starting with `  - ` (2-space indent + dash + space) belong to the current task.

**Line identification (by order and pattern):**

| Line # | Pattern | Parses to |
|---|---|---|
| 1 | `- [ ] #N Title` | `id`, `title`, `status` (`[ ]`=open, `[x]`=done) |
| 2 | `  - @word @word...` | `task_type` (first @word), `context_labels` (remaining @words) |
| 3 | `  - P# \| Owner: X \| Due: Y \| Effort: T \| Impact: V` | `priority`, `owner`, `due_date`, `effort`, `impact` — pipe-separated, each field optional except P# |
| 4 | `  - Created: YYYY-MM-DD \| Updated: YYYY-MM-DD` | `created_at`, `updated_at` |
| 5+ | `  - KEY: value` | Ontology edges or monitor fields (see below) |
| Last | `  - ` (no known prefix) | `notes` |

**Edge detection (line 5+):**
- `FND: FND-xxx` → finding edge (split by comma for multiple)
- `REC: REC-xxx` → recommendation edge
- `SOP: value` → sop edge
- `Goal: value` → goal edge
- `Layer: L0` or `Layer: L1, L5` → framework layer(s) (split by comma for multiple)
- `Meeting: value` → meeting edge
- `Email: value` → email edge
- `Depends on: #N description` → depends_on edge
- `ext: ID | synced: TIMESTAMP` → sync metadata
- `Check:` / `Baseline:` / `Target:` / `Frequency:` / `Risk:` → monitor fields

**Section detection:**
- `## P0 — Critical` → tasks below are P0
- `## P1 — High` → P1
- `## P2 — Medium` → P2
- `## P3 — Low` → P3
- `## Reference` → tasks are type=reference
- `### Subsection Name` → optional grouping (preserve on export, use as tag)

### 7.3 Serializer Rules

When exporting to markdown, follow the EXACT line order specified above. Do not include empty fields. Always include Created/Updated. Separate priority sections with `---`.

### 7.4 Round-trip Guarantee

`parse(serialize(task)) == task` must hold for all tasks. This is a hard requirement — users will edit markdown by hand and re-import.

---

## 8. UI Requirements

### 8.1 Primary Interface

A **kanban-style board** with columns for P0/P1/P2/P3, where each card shows:
- Task title
- GTD type badge (@next, @waiting, etc.)
- Impact badge (color-coded: noise=gray, hygiene=blue, lever=green, unlock=orange, breakthrough=red)
- Effort pill
- Owner [Target Customer Profile]/name
- Edge count indicator (e.g., "3 links")

### 8.2 Task Detail Panel

Slide-out panel showing:
- All task properties (editable)
- Ontology edges as clickable pills/tags
- Monitor fields (if @monitor)
- Sync status (last synced, external link)
- Activity log (changes over time)
- Markdown preview (raw format)

### 8.3 Quick Win Spotlight

A dedicated widget/view that surfaces:
- Tasks where `effort <= 1h AND impact IN (lever, unlock, breakthrough)`
- Sorted by effort ascending
- Across all projects or filtered to one

### 8.4 Ontology Explorer

A graph/network visualization showing:
- Tasks as nodes
- Edges to FND/REC/SOP/Goal/Meeting as connected nodes
- Color-coded by type
- Click a Finding → see all linked tasks and recommendations
- Click a Goal → see all tasks serving it
- This is the "Palantir view" — the system's differentiator

### 8.5 Layer Distribution View

A horizontal stacked bar chart or heatmap showing task count per layer (L0–L7) per project.

```
           L0  L1  L2  L3  L4  L5  L6  L7
ExampleBrand     ░   ██  ░   ░   █   ███ ██  █
ExampleRetail      ░   ░   ░   ░   ░   ███ █   ██
Arcanian   ░   ██  █   ██  █   █   ░   ░
```

**Purpose:** Reveals whether we're fixing root causes (L0-L2) or chasing symptoms (L5-L7). If a project has 20 tasks at L5-L7 and 0 at L0-L2, we're likely treating symptoms — the diagnosis needs revisiting.

**Click a cell** → filtered task list for that project × layer combination.

**Color coding:** L0-L2 = warm tones (these are deeper, harder, more impactful). L5-L7 = cool tones (operational, easier, less systemic).

### 8.6 Cross-Project Dashboard

For the founder view:
- All P0s across all projects (should be 0-3 at any time)
- Overdue tasks count per project
- @waiting tasks grouped by who (reveals bottlenecks: "[Name] has 5 tasks waiting")
- Quick wins available
- Sync health per project (last synced, conflicts pending)

### 8.6 Design Requirements

- **Dark mode primary** (#1a1a1a background, #ffaa00 amber accent) — Arcanian brand
- **Inter font**
- **Linear/Vercel aesthetic** — minimal, fast, keyboard-first
- **Mobile responsive** — must work on phone for @phone context tasks
- Global keyboard shortcut: `Cmd+K` → command palette (create task, search, switch project, change view)

---

## 9. Tech Stack Recommendation

This is a suggestion — developer can propose alternatives.

| Layer | Recommendation | Why |
|---|---|---|
| Frontend | Next.js + Tailwind | SSR for speed, Tailwind for dark-mode, Vercel deploy |
| State | Zustand or Jotai | Lightweight, works with SSR |
| Backend | Next.js API routes or separate Hono/Express | Simple REST, no GraphQL needed yet |
| Database | SQLite (via Turso) or Postgres | SQLite for simplicity, Postgres if multi-user |
| ORM | Drizzle or Prisma | Type-safe queries |
| Markdown parser | Custom (spec above) or remark/unified | Must follow exact format spec |
| Sync engine | Background jobs (Inngest or cron) | Per-project sync on schedule |
| Graph viz | D3.js or Cytoscape.js | For ontology explorer |
| Auth | Clerk or NextAuth | Multi-user for team ([Owner], [Team Member 1], [Team Member 2]) |
| Deploy | Vercel | Fast, Arcanian already uses it |

---

## 10. Migration Plan

### Phase 1: Import existing data
1. Parse all 6 TASKS.md files using the markdown parser
2. Import into database
3. Verify round-trip: export back to markdown, diff against original

### Phase 2: Sync connections
1. Connect [Task Manager] API (most projects)
2. Connect Asana API (ExampleBrand)
3. Run first sync, resolve any conflicts
4. Verify: tasks appear in both systems correctly

### Phase 3: UI
1. Build kanban board + task detail panel
2. Build cross-project dashboard
3. Build quick wins view
4. Build ontology explorer (can be v2)

### Phase 4: Markdown export stays alive
1. Export to TASKS.md on every change (write-through)
2. File watcher: detect external markdown edits → re-import
3. This ensures Claude Code `/tasks` skill continues to work alongside the UI

---

## 11. Real Data: Current Projects

| Project | Slug | Active Tasks | Done Tasks | Sync | External ID |
|---|---|---|---|---|---|
| ExampleBrand | `examplebrand` | 111 | 12 | Asana | `EXAMPLE-ID-001` |
| ExampleRetail | `exampleretail` | 26 | 14 | [Task Manager] | TBD |
| ExampleLocal | `examplelocal` | 10 | 9 | [Task Manager] | TBD |
| Arcanian | `arcanian` | 26 | 7 | [Task Manager] | TBD |
| ExampleBuild | `ExampleBuild` | 18 | 8 | [Task Manager] | TBD |
| [Audit Framework] | `[audit-framework]` | 14 | 4 | [Task Manager] | TBD |
| **Total** | | **205** | **54** | | |

### Sample Data Files (for testing)

All files are at project roots:
- `/path/to/project/TASKS.md` (largest — 111 tasks, best test case)
- `/path/to/project/TASKS.md` (richest ontology — FND/REC/SOP edges)
- `/path/to/project/TASKS.md` (most task types — goals, milestones, decisions)

---

## 12. Non-Requirements (Explicitly Out of Scope)

- **No recurring tasks** — all tasks are one-off
- **No goal hierarchy** — goals are flat tags, not OKR cascades
- **No SOP-to-task generation** — SOPs don't auto-create tasks; tasks reference SOPs
- **No real-time collaboration** — team is 3 people, async is fine
- **No time tracking** — effort is an estimate, not tracked time
- **No Gantt charts** — this is GTD, not waterfall
- **No notifications/alerts** — sync + dashboard is sufficient
- **No mobile app** — responsive web is enough

---

## 13. Success Criteria

The system is done when:

1. **Import:** All 205 active tasks + 54 done tasks import correctly from markdown
2. **Round-trip:** `parse(serialize(task)) == task` for all tasks — zero data loss
3. **Sync:** Bidirectional sync works with [Task Manager] and Asana
4. **Views:** All 12 standard views + 7 ontology queries work
5. **Quick wins:** Can answer "what can I do in 15 minutes that moves the needle?" in 1 click
6. **Ontology:** Can click a Finding and see all linked tasks, or click a Goal and see all tasks serving it
7. **Markdown export:** Changes in UI are automatically written back to TASKS.md, so Claude Code `/tasks` skill continues to work
8. **Speed:** Task list loads in <200ms, sync completes in <5s per project

---

## 14. Reference Files

| File | Location | What it contains |
|---|---|---|
| Task system rules | `__example_full/memory/TASK_SYSTEM_RULES.md` | Canonical format definition |
| Design decisions | `__example_full/memory/task-system-design.md` | Full design history with all 12 decisions |
| Template | `__example_full/memory/TASKS_TEMPLATE.md` | Example file with all task types |
| Skill definition | `__example_full/skills/tasks.md` | Claude Code `/tasks` skill (shows all commands) |
| Captain's Log entry | `__example_full/arcanian/CAPTAINS_LOG.md` | 2026-03-23 entry with strategic context |

---

## 15. Required Developer Skills

### Must-Have

| Skill | Why | Proof Point |
|---|---|---|
| **TypeScript (advanced)** | Entire stack is TS. Parser, API, frontend. Type safety is critical for the ontology model — loose types = broken edges. | Can build a recursive markdown parser with proper type narrowing |
| **Next.js (App Router, SSR)** | Primary framework. Server components for fast task list loads. API routes for sync. | Has shipped a production Next.js app with server actions |
| **SQL (relational modeling)** | The ontology is a graph stored in relational tables. Edges table design, self-referential joins (task→task dependencies), efficient cross-project queries. | Can design a normalized schema for a graph-in-SQL pattern and write the queries for "find all tasks linked to FND-039 across projects" |
| **REST API design** | Clean CRUD + action endpoints. Sync engine exposes status/conflict endpoints. Markdown import/export. | Understands idempotency, proper HTTP verbs, error handling |
| **Markdown parsing** | Must build a custom parser that handles the exact format spec (Section 7). Not a generic markdown-to-HTML — it's a structured data extraction problem. | Has written a parser for a structured document format (not just used a library) |
| **External API integration** | Bidirectional sync with [Task Manager] REST API, Asana REST API. OAuth/PAT auth. Rate limiting. Pagination. | Has built a sync between two systems with conflict resolution |
| **State management (frontend)** | Kanban board with drag-and-drop (priority changes), optimistic updates, real-time edge editing. | Has built interactive UIs with complex local state |

### Nice-to-Have

| Skill | Why |
|---|---|
| **Graph visualization (D3.js / Cytoscape.js)** | Ontology explorer — the "Palantir view". Could be Phase 2 but it's the differentiator. |
| **File system watching** | Markdown write-through + detecting external edits (Claude Code modifies TASKS.md directly). Node.js `fs.watch` or `chokidar`. |
| **Tailwind CSS + dark mode** | Arcanian brand requires dark-first design (#1a1a1a bg, #ffaa00 amber). Developer should be comfortable with design implementation, not just logic. |
| **Background jobs** | Scheduled sync every 15 min. Inngest, BullMQ, or simple cron. |
| **Trello / Bitrix API** | Future sync targets. Not day-1 but architecture should support adding new sync adapters easily. |

### Red Flags (do NOT hire if)

- Only knows NoSQL / document databases — the ontology requires relational joins
- Has never built a bidirectional sync — this is the hardest part, not the UI
- Treats markdown as "just text" — the parser is a structured data problem, not string manipulation
- Can't work with an existing specification — this brief IS the spec, not a starting point for "let me redesign it"
- Only frontend or only backend — this is a full-stack build, single developer needs to own both

---

## 16. Guardrails & Risk Mitigation

### Data Integrity

| Risk | Consequence | Guardrail |
|---|---|---|
| **Markdown round-trip breaks** | Data loss — user edits in Typora, imports, fields are gone | Mandatory: `parse(serialize(task)) == task` test suite. Run on every import. Fail loudly if ANY field is lost. This is the #1 acceptance criterion. |
| **Task number collision** | Two tasks with same #N in a project | Enforce: task IDs are auto-incremented per project. Never accept user-provided IDs. On import, validate uniqueness and reject duplicates. |
| **Edge pointing to deleted target** | "Task links to FND-039" but FND-039 was deleted | Soft-delete only. Edges become "orphaned" but never broken. Show warning in UI: "Linked finding FND-039 not found." Never auto-delete edges. |
| **Frontmatter corruption** | YAML frontmatter in TASKS.md is malformed after manual edit | Parser must handle: missing fields (use defaults), extra fields (preserve), malformed YAML (reject file with clear error, don't silently corrupt). |

### Sync Safety

| Risk | Consequence | Guardrail |
|---|---|---|
| **Sync overwrites local changes** | User edited a task locally, sync pulls older version from [Task Manager] | NEVER auto-overwrite. Timestamp comparison is mandatory before any write. If `both changed since last sync` → flag as conflict, require manual resolution. Never silently resolve. |
| **Sync creates duplicates** | Same task exists in both systems, sync creates it again | Match by `ext_id` first. If no `ext_id`, match by title + project (fuzzy). On first sync of existing project, run a "match candidates" step before creating anything new. Require user confirmation for bulk creates. |
| **API rate limiting** | [Task Manager]/Asana rate-limits hit during bulk sync | Implement exponential backoff. Queue sync operations. Show progress ("syncing 45/111 tasks..."). Never fail silently — show exactly which tasks couldn't sync and why. |
| **API token expiry / auth failure** | Sync silently stops working | Health check on every sync start. If auth fails, surface it immediately in dashboard: "ExampleBrand Asana sync: AUTH FAILED since 2026-03-23." Don't retry auth in a loop. |
| **External system deletes a task** | User deletes in [Task Manager], sync pulls deletion to local | NEVER auto-delete locally. Flag as "deleted in external system" — user decides whether to archive locally or re-create externally. Deletion is irreversible; the guardrail is making it a conscious choice. |
| **Field mapping loses data** | Impact scale doesn't exist in [Task Manager] — syncing back loses it | Track which fields are "local-only" vs "synced". On sync, only write fields that map. On conflict display, show which fields exist only locally. Document clearly: "Impact, Effort, Monitor fields, and Ontology edges are LOCAL ONLY — they don't sync to external systems." |

### Operational Safety

| Risk | Consequence | Guardrail |
|---|---|---|
| **Markdown file grows too large** | 300+ tasks, TASKS.md becomes slow to open/parse | Monitor file size. Warn at 500 tasks: "Consider archiving completed tasks." Parser must handle 1000+ tasks without timeout. Lazy-load in UI (paginate P2/P3). |
| **TASKS_DONE.md grows forever** | Archive becomes massive over months/years | Partition by quarter: `TASKS_DONE_2026_Q1.md`, `TASKS_DONE_2026_Q2.md`. Auto-rotate when archive exceeds 500 entries. Old archives become read-only. |
| **Concurrent markdown edits** | Claude Code and the UI both write to TASKS.md at the same time | File locking: before writing, acquire a `.TASKS.md.lock` file. If lock exists and is <30 seconds old, wait. If >30 seconds, assume stale lock, override. On write: read → parse → merge changes → write. Never overwrite the whole file blind. |
| **User accidentally moves all tasks to P0** | Everything is "critical," nothing is prioritized | Soft limit: warn if >5 tasks are P0. "You have 8 P0 tasks. P0 means 'fix now' — are all of these truly critical?" Don't block, just warn. |
| **Owner field becomes inconsistent** | "[Owner]" vs "Laci" vs "laszlo" for same person | Normalize owners to a fixed list per project. On import, fuzzy-match to known owners. Suggest corrections: "Did you mean '[Owner]'?" Enum in UI, free text only on import. |

### Security & Privacy

| Risk | Consequence | Guardrail |
|---|---|---|
| **API tokens in config** | [Task Manager]/Asana tokens exposed in code or files | Store tokens in environment variables or a secrets manager. NEVER in TASKS.md, NEVER in git. `.env.local` with `.gitignore`. |
| **Client data cross-contamination** | ExampleRetail's findings visible in ExampleBrand project | Project isolation is absolute. No cross-project data in API responses unless explicitly queried via cross-project views. Cross-project views require explicit permission (founder-only). |
| **Markdown files contain client-sensitive data** | TASKS.md with client contacts, tracking IDs, business details | These files should NOT be committed to public repos. `.gitignore` TASKS.md and TASKS_DONE.md by default. If backup is needed, encrypt or use a private repo. |
| **Sync tokens give write access to client systems** | Compromised token could modify client's Asana/[Task Manager] | Use minimum-permission tokens. [Task Manager]: read+write on specific projects only. Asana: limit to specific workspace. Review token permissions quarterly. |

### UX Guardrails

| Risk | Consequence | Guardrail |
|---|---|---|
| **User forgets to set impact** | Tasks without impact can't be prioritized in quick-wins view | Impact is a REQUIRED field. Block task creation if not set. Provide the decision helper: "If we DON'T do this, what breaks? → hygiene" |
| **Monitor tasks without check/target** | @monitor task with no check criteria is useless | If `task_type = monitor`, require at minimum `check` field. Warn if `target` or `frequency` is missing. |
| **Stale @waiting tasks** | Task has been @waiting for 3 weeks, nobody noticed | Dashboard widget: "Stale waiting tasks (>7 days without update)." Highlight in amber. Group by who we're waiting on — reveals bottleneck people. |
| **Quick win inflation** | Everything gets marked as "lever" impact to appear in quick wins | Quick wins view should show effort×impact distribution. If >50% of tasks are "lever" or above, surface a warning: "Impact ratings may need recalibration." |
| **Orphan tasks** | Tasks with no edges (no FND, SOP, Goal, Meeting) | Not an error — some tasks are standalone. But surface "unlinked tasks" as a view for review. These are often missing context that should be added. |

---

## 17. Questions for the Developer

1. **Database:** SQLite (simpler, single-file) or Postgres (multi-user ready)?
2. **Hosting:** Vercel (serverless) or a VPS (for background sync jobs)?
3. **Graph visualization:** Is Cytoscape.js sufficient for the ontology explorer, or should we consider a different approach?
4. **Markdown write-through:** Watch the file for external changes (Claude Code editing) — polling or filesystem events?
5. **Timeline estimate:** Given the scope above, what's a realistic timeline?
6. **Sync complexity:** Have you built a bidirectional sync with conflict resolution before? What was the hardest part?
7. **Markdown parser:** How would you approach the round-trip guarantee? What's your testing strategy for it?

---

*"AI tools tell you WHAT to do. We tell you WHERE to start."*
*— Arcanian*
