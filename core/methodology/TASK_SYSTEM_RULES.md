# Arcanian Task System — Rules & Best Practices

> Shared reference for all projects. Each project's CLAUDE.md should point here.
> This is the CANONICAL definition of the task format.

---

## File Structure

Every project has exactly TWO task files in its root:
- `TASKS.md` — active tasks only (P0-P3 + Reference)
- `TASKS_DONE.md` — completed/wont-do archive (append-only, newest first)

---

## Task Format (EXACT line order)

```markdown
- [ ] #N Task description
  - @type @context                          ← 1. GTD labels (always first)
  - P# | Owner: X | Due: Y | Effort: T | Impact: V  ← 2. Core metadata
  - Created: YYYY-MM-DD | Updated: YYYY-MM-DD        ← 3. Timestamps (ALWAYS present)
  - FND: / REC: / SOP: / Goal:             ← 4. Ontology edges (what applies)
  - Meeting: / Email:                       ← 5. People/calendar edges (what applies)
  - Check: / Baseline: / Target: / Frequency:  ← 6. Monitor fields (if @monitor)
  - ext: ID | synced: YYYY-MM-DDTHH:MM     ← 7. Sync metadata (if synced)
  - Free text notes                         ← 8. Context
```

**Rules:**
- Line order is FIXED — never reorder
- Only include lines that apply (no empty fields)
- `Created:` and `Updated:` are ALWAYS present on every task
- Task numbers are sequential per project, never reused

---

## TASKS.md Frontmatter

```yaml
---
project: "project-name"
sync: [task-manager]          # default external system ([task-manager]/asana/trello/bitrix/none)
sync_id: ""            # external project/board ID
updated: 2026-03-23T18:00
---
```

## TASKS_DONE.md Frontmatter

```yaml
---
project: "project-name"
type: archive
updated: 2026-03-23T18:00
---
```

---

## Sections (in order)

```
## P0 — Critical
## P1 — High
## P2 — Medium
## P3 — Low
## Reference
```

Tasks live in the section matching their priority.
`@reference` items go in the Reference section (no priority).
Subsection headers (### Workstream Name) are optional for organization within a priority level.

---

## GTD Labels (task types)

| Label | Type | Has action? |
|---|---|---|
| `@next` | Ready to do now | Yes |
| `@waiting` | Blocked on someone | No (someone else) |
| `@someday` | Not committed | Maybe later |
| `@reminder` | Awareness, no action | No |
| `@monitor` | Check periodically | Check, not do |
| `@decision` | Needs a choice | Think, not do |
| `@reference` | Stored context | No |
| `@milestone` | Point in time | No |

### Context labels (combine with type)
| Label | When |
|---|---|
| `@computer` | Needs laptop/desk |
| `@phone` | Can do by phone |
| `@email` | Requires sending/reading email |
| `@deep` | Needs focus time (>30 min) |
| `@quick` | Can do in <5 min |

---

## Impact Scale

| Value | Meaning |
|---|---|
| `noise` | Doesn't move anything meaningful |
| `hygiene` | Prevents problems, avoids downside |
| `lever` | Multiplies something already working |
| `unlock` | Removes a blocker, opens new capability |
| `breakthrough` | Changes the game |

---

## Effort Scale

`15m` `30m` `1h` `2h` `4h` `1d` `2d` `3d` `1w` `2w+`

---

## Priority

| P | Meaning | Response |
|---|---|---|
| P0 | Critical | Fix now |
| P1 | High | This week |
| P2 | Medium | Within 2 weeks |
| P3 | Low | At convenience |

---

## Monitor Tasks (@monitor)

Extra fields after ontology edges:
```
- Check: what to look at and where
- Baseline: starting value (date)
- Target: what "good" looks like
- Frequency: when to check (weekly / after deploys / 2x/week)
- Risk: what could go wrong
```

Subtypes (all use @monitor):
- **Post-fix verification** — did the fix work?
- **Platform health** — fragile thing, check after changes
- **Spend/performance drift** — budget or metric off track
- **External dependency** — outside your control
- **Compliance** — legal/consent things

---

## Timestamps

- `Created:` YYYY-MM-DD — when task was first written (never changes)
- `Updated:` YYYY-MM-DD — last local edit (changes on every modification)
- `synced:` YYYY-MM-DDTHH:MM — last sync with external system (time precision for conflict resolution)

---

## Ontology (Palantir-style typed edges)

Each task is a node connected to other objects:

| Edge | Format | Example |
|---|---|---|
| Finding | `FND: FND-039` | Measurement audit finding |
| Recommendation | `REC: REC-039` | Measurement audit recommendation |
| Process/SOP | `SOP: 05-CAMPAIGN-MANAGEMENT` | Which process this follows |
| Goal | `Goal: Q1-ship-[diagnostic-service]` | Shallow tag, no hierarchy |
| Layer | `Layer: L1` or `Layer: L1, L5` | Which framework layer(s) this task touches (L0–L7) |
| Meeting | `Meeting: 2026-03-10 IT vezető` | Calendar/meeting reference |
| Email | `Email: Jenő 2026-03-04 subject` | Email thread reference |

- SOP→Task is one-way: task references SOP, SOPs don't generate tasks
- Calendar/email are text references only (no API)
- Goals are shallow tags (no Goal→KR→Initiative cascade)

---

## External System Sync

Each project has a default sync target in frontmatter (`sync:`).
Tasks inherit the project default. Individual tasks can override with `sync:` line.

**Supported systems:** `[task-manager]` `asana` `trello` `bitrix` `none`

**Sync fields on task:**
```
- ext: 000000000000 | synced: 2026-03-23T14:30
```

- `ext:` = task ID in external system
- `synced:` = last sync timestamp

**Conflict resolution (last-write-wins):**
- `Updated > synced` → push local to external
- External `updatedAt > synced` → pull external to local
- Both changed since last sync → **conflict** → flag for manual decision

---

## Completing a Task

1. Change `- [ ]` to `- [x]` and add completion date to title: `- [x] Task (2026-03-23)`
2. Move the entire task block from TASKS.md to top of TASKS_DONE.md
3. Keep all metadata (ontology edges, effort, impact) — it's historical record
4. Update `updated:` in TASKS.md frontmatter

---

## Creating a New Task

1. Assign next sequential number for the project
2. Follow the exact line order (labels → metadata → timestamps → edges → sync → notes)
3. Set `Created:` to today, `Updated:` to today
4. Place in correct priority section
5. Only include metadata lines that apply

---

## What NOT to Do

- No recurring tasks — all tasks are one-off
- No deep goal hierarchies — just a tag
- Don't leave empty metadata fields
- Don't delete from TASKS_DONE.md
- Don't reuse task numbers
- Don't put done tasks in TASKS.md (move to TASKS_DONE.md)

---

## Project Registry

| Project | Location | Sync | Tasks |
|---|---|---|---|
| ExampleBrand | `_example_full/` | asana (`EXAMPLE-ID-001`) | ~111 |
| ExampleRetail | `_example_full/` | [task-manager] | ~26 |
| ExampleLocal | `_example_full/` | [task-manager] | ~10 |
| Arcanian | `__example_full/` | [task-manager] | ~26 |
| ExampleBuild | `_ExampleBuild_full/` | [task-manager] | ~18 |
| [Audit Framework] | `[audit-framework]/` | [task-manager] | ~14 |
