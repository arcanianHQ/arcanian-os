> v1.0 — 2026-04-03

# {Display Name} — Project Instructions

## What This Is
{One-line description}
**Owner:** {owner}
**Team:** {team}
**Created:** {date}

## Task System
- `TASKS.md` — active tasks | `TASKS_DONE.md` — archive | `/tasks` to manage
- Format: `core/methodology/TASK_FORMAT_STANDARD.md` (ExampleBrand gold standard)
- Rules: `core/methodology/TASK_SYSTEM_RULES.md`

### Quick Reference
```
- [ ] #N Task title
  - @type @context
  - P# | Owner: X | Due: YYYY-MM-DD | Effort: T | Impact: V
  - From: {who} ({source}) | Inform: {who}
  - Created: YYYY-MM-DD | Updated: YYYY-MM-DD
  - Layer: L#
  - Domain: {domain}              ← REQUIRED for multi-domain clients
  - Waiting on: {who} — {what}    ← REQUIRED for @waiting tasks
  - Waiting since: YYYY-MM-DD     ← REQUIRED for @waiting tasks
  - Follow-up: YYYY-MM-DD — {action} ← REQUIRED for @waiting tasks
  - Depends on: #N | Blocks: #N
  - SOP/FND/REC/Goal/Meeting edges
  - ext: ID | synced: T
```
GTD: @next @waiting @someday @reminder @monitor @decision @reference @milestone
Impact: noise → hygiene → lever → unlock → breakthrough
Priority: P0 (now) | P1 (week) | P2 (2wk) | P3 (convenience)

## Layers: L0 Source | L1 Core | L2 Identity | L3 Product | L4 Offer | L5 Channels | L6 Customer | L7 Market

## Multi-Domain (if 2+ domains)
<!-- Remove this section for single-domain clients -->
**Before ANY analysis or MCP query:** load `DOMAIN_CHANNEL_MAP.md` and filter by domain.
Rule: `../../core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`

## Key Directories
- `CAPTAINS_LOG.md` — decisions (append-only, newest at bottom)
- `inbox/` — unprocessed inputs (triage weekly)
- `archive/` — superseded files
- `memory/MEMORY.md` — auto-memory index

## Sync: {sync_system} | ID: {sync_id}

## File Intake (ALWAYS-ON)
When user references a file from outside (~/Downloads/, inbox/, etc.): auto-route to correct location, rename, add ontology, extract tasks, log. Rule: `../../core/methodology/FILE_INTAKE_RULE.md`

## Data Rules
NEVER commit: PII, API tokens, raw exports, .env files. See .gitignore.

## SOP Auto-Surface (ALWAYS-ON)
**Before executing any task, check if a relevant SOP exists and LOAD it.**
- email/newsletter/AC → `marketing-ops/06` + client `processes/06-*`
- agency coordination → `marketing-ops/01`
- tracking/measurement → `marketing-ops/04`
- campaign launch → `marketing-ops/05`
- lead/pipeline → `marketing-ops/02`
- audit → `[audit-framework]/01-06`
- Also load client-specific `processes/` SOPs for this topic
- A SOP that is not loaded is a SOP that does not exist
- Rule: `../../core/methodology/SOP_AUTO_SURFACE_RULE.md`

## Data Analysis Output Standard (ALWAYS-ON)
**Every data query MUST use analytical frameworks — a table of numbers is NOT analysis.**
- **Minimum:** BLUF (conclusion first + confidence) → data table → OODA (observe/orient/decide/act) → Data Reliability
- **On anomalies (>15% change):** add ACH (3-6 competing hypotheses scored CC/C/N/I against evidence)
- **On threshold triggers** ("if X < Y, then..."): pull diagnostic metrics to test, do not just check the number
- Template: `../../core/templates/BLUF_OODA_TEMPLATE.md`
- Applies to: ALL Databox queries, ALL MCP metric pulls, ALL freeform data questions
