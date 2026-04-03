> v1.0 — 2026-04-03

# Scaffold — File Templates

> Template content for generated files. Variables: {project_name}, {display_name}, {project_type}, {owner}, {team}, {sync_system}, {sync_id}, {today}, {goals}.

---

## CLAUDE.md

```markdown
# {display_name} — Project Instructions

## What This Is
{project_type} project: {display_name}
**Owner:** {owner} | **Team:** {team} | **Created:** {today}

## Task System
- `TASKS.md` — active tasks | `TASKS_DONE.md` — archive | `/tasks` to manage
- Rules: `../../core/methodology/TASK_SYSTEM_RULES.md`

### Quick Reference
- [ ] #N Task → @type @context → P# | Owner | Due | Effort | Impact → Created | Updated → Layer → edges → notes
- GTD: @next @waiting @someday @reminder @monitor @decision @reference @milestone
- Impact: noise → hygiene → lever → unlock → breakthrough
- Priority: P0 (now) | P1 (week) | P2 (2wk) | P3 (convenience)

## Layers
L0 Source | L1 Core | L2 Customer | L3 Value | L4 Offer | L5 Channels | L6 Conversion | L7 Intelligence

## Key Directories
- `CAPTAINS_LOG.md` — decisions (append-only, newest at bottom)
- `brand/` — intelligence profile (7 diagnostic files)
- `upd/` — User Provided Data (files FROM the client: exports, screenshots, data they send us)
- `inbox/` — unprocessed inputs from US (triage weekly)
- `meetings/` — transcripts + `raw/` originals (from Fireflies)
- `audit/evidence/` — timestamped audit evidence (screenshots, network, cookies)
- `data/gtm-exports/` — GTM container exports + changelog
- `archive/` — superseded files
- `skills/` → core skills (symlink, read-only)
- `sops/` → core SOPs (symlink, read-only)

## Sync: {sync_system} | ID: {sync_id}

## Data Rules
NEVER commit: PII, API tokens, raw exports, .env files.
```

---

## CAPTAINS_LOG.md

```markdown
# Captain's Log — {display_name}

Strategic decisions and reasoning. Append-only. Newest at bottom.

---

## {today} | PROJECT CREATED

### Context
{project_type} project scaffolded.
- Owner: {owner}
- Team: {team}
- Sync: {sync_system}
- Goals: {goals}

### Next Steps
1. Fill in client/project details
2. Complete brand/ intelligence profile (/7layer →  → /repair-roadmap)
3. Add team contacts to EXTERNAL-CONTACTS-TABLE.md
4. Configure MCP servers
5. Create first real tasks

---
```

---

## TASKS.md

```markdown
---
project: "{project_name}"
sync: {sync_system}
sync_id: "{sync_id}"
updated: {now_iso}
---

# {display_name} — Tasks

> Local source of truth. Syncs to {sync_system}.
> `Updated:` vs external `updatedAt` vs `synced:` — newer wins.
> Done tasks → `TASKS_DONE.md`

---

## P0 — Critical

(No tasks yet)

---

## P1 — High

- [ ] #1 Project setup complete — verify all systems
  - @next @computer
  - P1 | Owner: {owner} | Due: {today+7} | Effort: 1h | Impact: unlock
  - Created: {today} | Updated: {today}
  - Layer: L1
  - Goal: {first_goal}
  - Verify: CLAUDE.md loaded, /tasks works, symlinks resolve, team access granted

- [ ] #2 Complete client intelligence profile
  - @next @deep
  - P1 | Owner: {owner} | Due: {today+14} | Effort: 1d | Impact: breakthrough
  - Created: {today} | Updated: {today}
  - Layer: L0, L1, L2
  - SOP: arcanian/06-client-intelligence-profile
  - Checklist:
    - [ ] Run /7layer → brand/7LAYER_DIAGNOSTIC.md
    - [ ] Run  → brand/CONSTRAINT_MAP.md
    - [ ] Run /repair-roadmap → brand/REPAIR_ROADMAP.md
    - [ ] Run  → brand/.md
    - [ ] Run /build-brand → brand/VOICE.md
    - [ ] Run /[customer need framework]-map → brand/TARGET_PROFILE.md
    - [ ] Run  → brand/POSITIONING.md

---

## P2 — Medium

(Add tasks as work begins)

---

## P3 — Low

(Add tasks as work begins)

---

## Reference

- [ ] Key contacts
  - @reference
  - {owner} — project lead
  - (Add team + client contacts)

- [ ] Goals
  - @reference
  - {goals listed}
```

---

## TASKS_DONE.md

```markdown
---
project: "{project_name}"
type: archive
updated: {now_iso}
---

# {display_name} — Completed Tasks

> Append-only archive. Newest first.

---

- [x] Project scaffolded ({today})
  - @next @computer
  - P0 | Owner: {owner} | Effort: 15m | Impact: unlock
  - Created: {today} | Updated: {today}
  - Layer: L1
```

---

## .gitignore

```
# Secrets
.env
.env.*
*.key
*.pem
credentials.json

# Raw data
data/raw/
exports/
*.xlsx
*.json.gz

# PII
**/pii/
**/customers/

# OS
.DS_Store
Thumbs.db

# Large files
*.zip
*.tar.gz
*.mp4
*.mov
*.svg
recordings/

# Claude Code
.claude/settings.local.json
```

---

## memory/MEMORY.md

```markdown
# {display_name} — Auto-Memory Index

> Slim index. Pointers only.

## Reference Files

| File | Contents |
|------|----------|
| `TASKS.md` | Active tasks |
| `TASKS_DONE.md` | Completed archive |
| `CAPTAINS_LOG.md` | Decision journal |
| `brand/` | Intelligence profile (7 files) |
```

---

## EXTERNAL-CONTACTS-TABLE.md (client type)

```markdown
# {display_name} — Key Contacts

| Name | Role | Context | Preferred Channel | Notes |
|------|------|---------|-------------------|-------|
| {owner} | Project lead | Arcanian | Slack / email | |
```

---

## processes/00-PROCESS-MAP.md (client type)

```markdown
# {display_name} — Process Map

> Client-specific adaptations of core SOPs.
> Core SOPs: `sops/` (symlinked from core, read-only)

## Core Processes (00-09)

| # | Process | Based on | Owner | Status |
|---|---------|----------|-------|--------|
| — | (Adapt from sops/marketing-ops/ as needed) | — | — | — |

## Quick Wins (10-19)

| # | Initiative | Effort | Est. Impact | Status |
|---|-----------|--------|-------------|--------|

## How to Add
1. Create `NN-DESCRIPTIVE-NAME.md`
2. Reference master SOP: `> Based on: sops/marketing-ops/NN-name.md`
3. Add client-specific adaptations
4. Reference from tasks: `SOP: NN-name`
```

---

## CLIENT_CONFIG.md (audit type)

```markdown
---
client: "{project_name}"
created: "{today}"
---

# {display_name} — Client Configuration

## Domains
| Domain | Platform | Country |
|--------|----------|---------|

## Tracking IDs
| Platform | ID | Notes |
|----------|-----|-------|
| GA4 | | |
| Google Ads | | |
| Meta Pixel | | |
| SGTM | | |

## GTM Containers
| Container | ID | Workspace |
|-----------|-----|-----------|
| Web | | |
| SGTM | | |

## Feed URLs
| Feed | URL | Format |
|------|-----|--------|

## CMP
| Platform | Type | Notes |
|----------|------|-------|
```

---

## ACCESS_REGISTRY.md (audit type)

```markdown
---
client: "{project_name}"
created: "{today}"
---

# {display_name} — Access Registry

| Platform | URL | Access Level | Granted By | Date | Notes |
|----------|-----|-------------|------------|------|-------|
| GA4 | | | | | |
| GTM | | | | | |
| Google Ads | | | | | |
| Meta Business | | | | | |
```

---

## PROJECT_GLOSSARY.md (every project — created empty, filled by team)

```markdown
> v1.0 — {today}

# {display_name} — Project Glossary

> What we call things in THIS project. System checks against this.

## Terms We USE

| Term | Meaning | NOT this |
|---|---|---|

## Terms We Do NOT Use

| Banned term | Why | Use instead |
|---|---|---|

## People & Roles

| Name | Full name | Role | Notes |
|---|---|---|---|

## Agreed Decisions

| Decision | Date | Context |
|---|---|---|
```

---

## upd/README.md (every project)

```markdown
# User Provided Data (UPD)

> Files, exports, screenshots, and data provided BY THE CLIENT.
> NOT our analysis — their raw inputs.
>
> Examples: GA4 exports, product lists, brand guidelines PDF, photos, 
> competitor screenshots, email lists, any file the client sends us.
>
> Track what was received, when, from whom, and whether it was processed.

| Date | What | From | Processed? | Moved to |
|---|---|---|---|---|
| — | No UPD received yet | — | — | — |

## Rules
- Date-stamp everything: `YYYY-MM-DD_{description}.{ext}`
- After processing: move to the correct dir (data/, brand/, audit/) 
- Keep a row in this table even after moving (audit trail)
- PII in UPD: check DATA_RULES before committing to Git
```
