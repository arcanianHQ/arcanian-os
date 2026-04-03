---
project: "{slug}"
sync: todoist
sync_id: ""
updated: {YYYY-MM-DDThh:mm}
---

# {Display Name} — Tasks

> Local source of truth. Syncs to `sync:` system via `/task-sync`.
> Format: `core/methodology/TASK_FORMAT_STANDARD.md` (ExampleBrand gold standard)
> Done tasks → `TASKS_DONE.md`

---

## P0 — Critical

- [ ] #1 Complete client intelligence profile
  - @next @deep
  - P0 | Owner: {owner} | Due: {two_weeks_from_now} | Effort: 1d | Impact: breakthrough
  - Created: {today} | Updated: {today}
  - Layer: L0, L1, L2
  - Domain: {primary_domain}
  - SOP: client-intelligence-profile
  - Checklist:
    - [ ] Run /7layer → brand/7LAYER_DIAGNOSTIC.md
    - [ ] Run  → brand/CONSTRAINT_MAP.md
    - [ ] Run /repair-roadmap → brand/REPAIR_ROADMAP.md
    - [ ] Run  → brand/.md
    - [ ] Run /build-brand → brand/VOICE.md
    - [ ] Run /[customer need framework]-map + /7layer L6 → brand/TARGET_PROFILE.md
    - [ ] Run  + /analyze-gtm → brand/POSITIONING.md

---

## P1 — High

{tasks}

---

## P2 — Medium

{tasks}

---

## P3 — Low

{tasks}

---

## Reference

- [ ] Key domains
  - @reference
  - {primary_domain} — {platform} — {market}
  - {secondary_domain} — {platform} — {market}
  - Full list: CLIENT_CONFIG.md

- [ ] Key contacts
  - @reference
  - {contact_name} — {role}
  - Full list: CLIENT_CONFIG.md or EXTERNAL-CONTACTS-TABLE.md

- [ ] Task format
  - @reference
  - Standard: `core/methodology/TASK_FORMAT_STANDARD.md`
  - Required fields: #{N}, @tag, Priority, Owner, Due, Impact, Created, Layer
  - @waiting requires: Waiting on, Waiting since, Follow-up
  - Multi-domain clients: add Domain: field to every task
  - Sync: /task-sync pushes to Todoist with ontology enrichment

---

> **Done tasks → `TASKS_DONE.md`** (separate file, append-only, newest first)

---

> *Task format: core/methodology/TASK_FORMAT_STANDARD.md*
> *Template version: 2.0 — 2026-03-26*
