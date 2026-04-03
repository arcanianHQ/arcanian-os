> v1.0 — 2026-04-03

# 09 — Inbox Management

> Generic SOP. Every project has an `inbox/` directory.
> **Owner:** Project lead | **Tier:** 1 | **Review:** Weekly
> **Version:** 1.0 | **Last updated:** 2026-03-24

## Purpose
Ensure no input is lost and every piece of information reaches its correct location within 7 days.

## Trigger
- New file appears in `inbox/` (manually dropped or auto-captured from Fireflies/email)
- Weekly triage (every Monday)
- `/inbox` skill invoked
- Morning brief flags "X files in inbox > 7 days"

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Project lead | Responsible + Accountable |
| Team member who added file | Consulted (if unclear) |

## Systems
- `inbox/` directory (per project)
- `/inbox` skill (classification + routing)
- Post-tool-use hook (flags new inbox items)
- Morning brief (surfaces aging items)

## Steps

### 1. Daily Check (2 min)
- Glance at inbox — anything urgent?
- Urgent items: process immediately (don't wait for weekly triage)

### 2. Weekly Triage (Monday, 15-30 min per project)
1. Run `/inbox` on each project with items
2. Review classifications — correct any misrouted files
3. Extract action items → TASKS.md
4. Files > 14 days old: decide keep or archive
5. Files > 30 days: archive unless explicitly kept

### 3. Naming on Input
When adding a file to inbox:
- Name it: `YYYY-MM-DD_SHORT_DESCRIPTION.{ext}`
- If from a meeting: `YYYY-MM-DD_meeting-with-NAME.md`
- If from email: `YYYY-MM-DD_from-NAME-topic.md`
- If auto-captured (Fireflies): auto-named, rename during triage

### 4. Processing Rules

| File type | Destination | Extract tasks? |
|---|---|---|
| Meeting transcript | `notes/` or `correspondence/` | YES — action items |
| Email/message | `correspondence/` | YES — requests, deadlines |
| GTM/data export | `data/` or `audit/data/` | Maybe — if fix needed |
| Screenshot | `data/screenshots/` | No |
| Article/reference | `archive/` or relevant dir | No |
| Client deliverable draft | Relevant dir (brand/, processes/) | YES — review needed |
| Proposal/ajánlat | Root or `proposals/` | YES — send/review |
| Unknown/unclear | Leave in inbox, flag | Ask who added it |

### 5. Log Processing
After triage, append to CAPTAINS_LOG:
```
## YYYY-MM-DD — Inbox triage
- Processed X files, created Y tasks, archived Z
```

## Escalation

| Condition | Action |
|---|---|
| File in inbox > 14 days | Morning brief flags it |
| File in inbox > 30 days | Auto-archive warning |
| Unclear file (no context) | Ask the person who added it |
| Sensitive file (PII, credentials) | Move to `.env` or delete. NEVER leave in inbox. |

## KPIs

| Metric | Target |
|---|---|
| Inbox empty on Monday evening | 100% |
| No file older than 7 days | 95% |
| Action items extracted from all meetings | 100% |
| Processing time per inbox | < 30 min |

## Review Cadence
Weekly (part of Monday triage)
