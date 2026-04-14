---
scope: shared
---

# Changelog Enforcement Rule

> **A change without a log entry is a change we can't debug.**
> Every tracked artifact in the system MUST have a changelog. No exceptions.

## Principle

Changes happen fast. Memory doesn't keep up. The changelog is the only thing that survives context switches, session restarts, and team handoffs. If it's not logged, it didn't happen — or worse, it happened and nobody knows why.

## What Requires a Changelog Entry

### 1. GTM / sGTM Container Changes
- **Where:** `clients/{slug}/data/gtm-exports/GTM_CHANGELOG.md`
- **When:** Every publish, every export, every draft workspace change
- **What to log:** Container ID, version, what tags/triggers/variables changed, who changed it, RECs addressed, verification status
- **Template:** `core/templates/GTM_CHANGELOG.md`
- **Rule:** A GTM export file without a changelog entry is an orphan. Flag it.

### 2. Distribution Repo Exports (Shared / Company / Advanced)
- **Where:** `CHANGELOG.md` in each distribution repo
- **When:** Every commit, every push — no matter how small
- **What to log:** Version bump, what files were added/changed/removed, which skill ran the export
- **Format:** Keep Changelog standard (`## [X.Y.Z] — YYYY-MM-DD` + `### Added/Changed/Fixed`)
- **Rule:** `/share-to-os`, `/share-to-company`, `/share-to-advanced` MUST update CHANGELOG.md as a mandatory step. A push without a changelog update is a failed export.

### 3. Client Configuration Changes
- **Where:** `clients/{slug}/CAPTAINS_LOG.md`
- **When:** Any change to CLIENT_CONFIG.md, DOMAIN_CHANNEL_MAP.md, CONTACTS.md, or CLIENT_INTELLIGENCE_PROFILE files
- **What to log:** What changed, why, who requested it, what tasks/findings drove it
- **Rule:** Config changes are silent killers. A domain map that changed without a log entry will cause wrong analysis for weeks before anyone notices.

### 4. Methodology Updates
- **Where:** Git commit message + version bump in file header
- **When:** Any change to `core/methodology/*.md`
- **What to log:** What rule changed, why (which incident or finding triggered it), what skills/agents are affected
- **Rule:** Methodology changes cascade — one rule change can affect 10+ skills. The commit message must explain the WHY, not just the WHAT.

### 5. SOP Updates
- **Where:** Git commit message + version bump in file header
- **When:** Any change to `core/sops/**/*.md`
- **What to log:** What step changed, why, which client engagement revealed the gap
- **Rule:** SOPs are procedures — a changed step without a logged reason is a procedure nobody trusts.

### 6. Scheduled Workflow Changes
- **Where:** `core/skills/scheduled-workflows.md` + CAPTAINS_LOG
- **When:** Any schedule added, removed, or modified
- **What to log:** Schedule ID, old/new cron, which client/project, why the change

### 7. MCP Connection Changes
- **Where:** CAPTAINS_LOG + `core/methodology/MCP_CONNECTIONS.md`
- **When:** Any `.mcp.json` edit, token rotation, server add/remove
- **What to log:** Which server, what changed, which sessions need restart

## Changelog Format Standards

### For version-tracked files (repos, GTM):
```
## [X.Y.Z] — YYYY-MM-DD

### Added / Changed / Fixed / Removed
- **{filename or component}** — {what changed and why}
```

### For CAPTAINS_LOG entries:
```
### YYYY-MM-DD HH:MM — {title}
- **What:** {what changed}
- **Why:** {what triggered the change — FND, REC, incident, request}
- **Impact:** {what else is affected}
```

## Enforcement

- **Hook:** Post-tool-use hooks should warn when files matching changelog-tracked categories are modified without a corresponding log entry in the same session
- **Task Overseer:** `/task-oversight` flags GTM exports without changelog entries
- **Export Skills:** `/share-to-os`, `/share-to-company`, `/share-to-advanced` BLOCK push if CHANGELOG.md was not updated in the same commit
- **Audit:** `/health-check` includes a changelog freshness check — are there recent file modifications without matching log entries?

### 8. Operational Events (Budget, Agency, Platform, Tracking Changes)
- **Where:** `clients/{slug}/EVENT_LOG.md`
- **When:** Any external operational change that affects data interpretation — budget changes, agency handovers, platform migrations, tracking deployments, campaign launches/kills, personnel changes
- **What to log:** EVT ID, date, type, what happened, observed impact, evidence source, layer, related FND/REC/Task
- **Template:** `core/templates/EVENT_LOG_TEMPLATE.md`
- **Rule:** An analysis that discovers a dated inflection point without logging it to EVENT_LOG.md is a knowledge leak. The same event will be re-derived next session.
- **Enforcement:** Analysis skills auto-extract events (EVENT_LOG_RULE.md). `/meeting-sync` and `/inbox-process` scan for operational events in transcripts and emails.

## What NOT to Log

- Reading files (no state change)
- Draft deliverables still in conversation (not yet saved)
- Memory file updates (auto-memory has its own index)
- Task status changes (TASKS.md IS the log for task state)

## The Test

> "If I open this project in 3 months, can I reconstruct what happened and why from the changelogs alone?"

If not, the changelogs are incomplete.
