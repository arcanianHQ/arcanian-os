# Skill: Session Preflight (`/preflight`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Run at session start before doing any work. Loads project context, surfaces urgent tasks, checks tool availability, and shows what happened last session.

## Trigger

Use when: session begins, user says `/preflight`, "what's the state", "catch me up", or "where were we".

## Input

None. Operates on the current working directory.

## Execution Steps

### Step 1: Load project context
1. Read `CLAUDE.md` from project root
2. Extract: project name, client name, project type, key rules
3. If no CLAUDE.md: STOP — "No CLAUDE.md found. Are you in the right directory?"

### Step 2: Task status
1. Read `TASKS.md` from project root
2. Count tasks by priority (P0, P1, P2, P3)
3. Count overdue tasks (tasks with `Due:` date before today)
4. List all P0 task titles (one line each)
5. If no TASKS.md: WARN — "No TASKS.md. Run /scaffold-project or create from template."

### Step 3: Check MCP connections
1. Read `.claude/settings.json` or `.mcp.json` if present
2. List configured MCP servers and their connection status
3. Common connections to check: GA4, Google Ads, Search Console, Meta Ads, Todoist, Asana
4. If no MCP config: note "No MCP connections configured for this project"

### Step 4: Last session context
1. Read `CAPTAINS_LOG.md` from project root
2. Extract the most recent dated entry (first `## YYYY-MM-DD` block)
3. Show date + first 3-5 lines of that entry
4. If no log: WARN — "No CAPTAINS_LOG.md. Session history unavailable."

### Step 5: Stale @waiting tasks
1. Filter TASKS.md for tasks with `@waiting` label
2. Check each for `Updated:` date
3. Flag any where `Updated:` is more than 7 days ago
4. List stale tasks with who we're waiting on and how many days

## Output Format

```
/preflight — {project_name}
═══════════════════════════════

Context: {one-line from CLAUDE.md}

Tasks: {P0_count} P0, {P1_count} P1, {total} total | {overdue_count} overdue
  P0: #12 Fix consent mode v2 implementation
  P0: #15 GA4 ecommerce events audit

MCP: GA4 ✓  Ads ✓  SC ✓  Todoist ✗  Meta ✗

Last session (YYYY-MM-DD):
  {first 3 lines of last log entry}

Stale @waiting ({count}):
  #8 Waiting on agency GTM access (12 days) → contact@example-agency.com
  #19 Waiting on feed URL from client (9 days) → client IT

Ready to work. {P0_count} P0s, {overdue_count} overdue, MCP: {summary}
═══════════════════════════════
```

## Notes

- This skill is read-only. It never modifies files.
- Keep output compact — the goal is a 10-second scan, not a full report.
- If the project is freshly scaffolded (no tasks, no log), say: "Fresh project. Start with /tasks create or brand/ profile."
- Designed to be triggered automatically by a session-start hook (see `tools/hooks/HOOKS_GUIDE.md`).
