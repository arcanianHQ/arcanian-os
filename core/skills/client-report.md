---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
argument-hint: "client — Client slug (e.g., wellis, diego)"
---

# Skill: Client Report (`/client-report`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Auto-generates a weekly or monthly client report by combining task progress, decision log, and MCP-sourced metrics into a single markdown document.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. All MCP metric queries (Databox, AC, GA4) must be domain-filtered. Report sections should show "(Domain: X)" for domain-specific metrics. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data confidence ≠ causal confidence. GA4 alone is insufficient for causal diagnosis — always check platform-side data (Meta Ads Manager, Google Ads, etc.). See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

## Trigger

Use when: user says `/client-report`, "generate report", "weekly report", "monthly report", or "client summary".

## Input

| Input | Required | Default |
|---|---|---|
| `client` | Yes | Current project name |
| `period` | Yes | `week` (W## of current year) or `month` (YYYY-MM) |
| `mcp_sources` | No | All configured MCPs |

## Execution Steps

### Step 1: Determine scope
1. Resolve `client` → project path (e.g., `_arcanian-ops/clients/{client}`)
2. Parse `period` — week number (`W12`) or month (`2026-03`) → derive date range
3. Check `.claude/settings.json` or `.mcp.json` for configured MCP sources

### Step 2: Read local sources
1. Read `TASKS.md` — filter tasks by `Updated:` or `Created:` within the period
   - Completed this period (moved to TASKS_DONE.md with date in range)
   - In-progress (open tasks worked on)
   - Blocked (tasks with @waiting or explicit blocker notes)
2. Read `CAPTAINS_LOG.md` — extract entries dated within the period
   - Pull key decisions, pivots, escalations

### Step 3: Pull MCP data (if available)
For each configured and requested MCP source, pull period data:
- **GA4**: sessions, users, conversions, revenue, top pages, channel breakdown
- **Google Ads**: spend, ROAS, CPC, top campaigns, conversion count
- **Meta Ads**: spend, ROAS, impressions, top ad sets, CTR
- **ActiveCampaign/CRM**: emails sent, open rate, click rate, pipeline movement
- If an MCP query fails: log warning, continue with remaining sources

### Step 4: Generate report
Assemble markdown with these sections:
```
# {Client} — {Period Label} Report

## Executive Summary
{3-5 bullet points: what happened, key metrics, what's next}

## Completed Work
{Tasks completed this period, grouped by category}

## Key Decisions
{From CAPTAINS_LOG entries this period}

## Metrics
### Traffic & Conversions (GA4)
### Paid Media (Google Ads / Meta)
### Email & CRM
{Each subsection only appears if data was available}

## Blockers & Risks
{Open @waiting tasks, escalations, dependencies}

## Next Period Plan
{P0 and P1 tasks planned for next period}
```

### Step 5: Save report
- Weekly: `reports/YYYY-WNN.md` (e.g., `reports/2026-W12.md`)
- Monthly: `reports/YYYY-MM-monthly.md` (e.g., `reports/2026-03-monthly.md`)
- Create `reports/` directory if it doesn't exist

### Step 6: Optionally commit
Ask user: "Commit report to git?" If yes, stage and commit with message: `report: {client} {period}`.

## Output Format

```
/client-report — {client} {period}
─────────────────────────────────
Report generated: reports/{filename}
Sources: TASKS.md ✓ | LOG ✓ | GA4 ✓ | Ads ✗ | Meta ✗ | CRM ✗
Completed: {N} tasks | Blocked: {N} | Decisions: {N}
─────────────────────────────────
```

## Notes

- **Offline mode**: If no MCP sources are configured or all fail, generate report from TASKS.md + CAPTAINS_LOG.md only. Note "Metrics unavailable — offline mode" in the Executive Summary.
- Reports are client-facing documents — use professional tone, no internal shorthand.
- Reference: `core/methodology/TASK_SYSTEM_RULES.md` for task format parsing.
