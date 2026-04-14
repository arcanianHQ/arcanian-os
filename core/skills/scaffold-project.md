# Skill: Project Scaffolding (`/scaffold-project`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Creates a fully operational Claude Code project from scratch — with every file, convention, and pattern learned from running Arcanian (468 files) and ExampleBrand (944 files) projects.

## Trigger

Use when: starting a new client/internal/audit project, "scaffold a project", "onboard a new client".

## Input Required

| Input | Required | Example | Default |
|---|---|---|---|
| `project_name` | Yes | `heavytools` | — |
| `display_name` | Yes | `Heavy Tools` | Titlecase of project_name |
| `project_type` | Yes | `client` / `internal` / `audit` | `client` |
| `location` | No | `/path/to/project` | `_arcanian-ops/clients/{name}` |
| `sync_system` | No | `[task-manager]` / `asana` / `trello` / `bitrix` | `[task-manager]` |
| `sync_id` | No | `EXAMPLE-ID-001` | `""` |
| `owner` | No | `[Owner]` | `[Owner]` |
| `team` | No | `["[Owner]", "[Team Member 1]"]` | `["[Owner]"]` |
| `goals` | No | `["Q2-heavytools-onboard"]` | `[]` |
| `domains` | No | `["heavytools.hu", "heavytools.com"]` | `[]` — ask if multi-domain |
| `primary_contact` | No | `{"name": "Kiss János", "nickname": "János", "email": "..."}` | `{}` — fill in CONTACTS.md |
| `language` | No | `HU` / `EN` | `HU` |
| `nda` | No | `true` / `false` | `false` |

## Execution Steps

### Step 1: Create directory structure
Read `scaffold-project/DIRECTORY_STRUCTURE.md` for the full tree per project type.
Create all directories and .gitkeep files.

### Step 2: Generate CLAUDE.md
Read `scaffold-project/FILE_TEMPLATES.md` → section "CLAUDE.md".
Fill in variables from input. Keep under 80 lines.

### Step 3: Generate CAPTAINS_LOG.md
Read `scaffold-project/FILE_TEMPLATES.md` → section "CAPTAINS_LOG.md".
Initial entry with project creation context.

### Step 3b: Generate CONTACTS.md

Use template from `core/methodology/CONTACT_REGISTRY_STANDARD.md`.
- Pre-populate Arcanian Team section ([Owner], [Team Member 1], [Team Member 2] from TEAM_DIRECTORY.md)
- Leave Client Team and Agencies sections empty (fill during onboarding)
- Set Communication Rules from client brief (language, tegező/magázó, NDA)

### Step 3c: Generate DOMAIN_CHANNEL_MAP.md (multi-domain clients only)

If `domains` input has 2+ entries (or CLIENT_CONFIG.md lists 2+ domains):
1. Use template from `core/templates/DOMAIN_CHANNEL_MAP_TEMPLATE.md`
2. Pre-populate the Domains table from input
3. Leave all channel sections as placeholders (fill during onboarding/audit)
4. Add task to TASKS.md: "Complete DOMAIN_CHANNEL_MAP.md — map all channels to domains"

If single-domain or domains unknown: skip this step. Add a note in NEXT STEPS to revisit if multi-domain.

Rule: `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`

### Step 3d: Generate EVENT_LOG.md

Use template from `core/templates/EVENT_LOG_TEMPLATE.md`.
- Replace `{Display Name}` and `{date}` with project values
- Table starts empty — populated during onboarding, audits, and ongoing analysis
- Add task to TASKS.md: "Populate EVENT_LOG.md with known historical events (budget changes, agency switches, platform migrations)"

**This file is MANDATORY for all project types.** Every analysis skill loads it before querying data.

### Step 4: Generate TASKS.md + TASKS_DONE.md
Use template from `core/templates/TASKS.md` (v2.0 — ExampleBrand gold standard format).
Task format standard: `core/methodology/TASK_FORMAT_STANDARD.md`.

**Fill in template variables:**
- `{slug}` = project_name
- `{Display Name}` = display_name
- `{owner}` = from input or default to [Owner]
- `{today}` = current date
- `{two_weeks_from_now}` = today + 14 days
- `{primary_domain}` = from CLIENT_CONFIG.md if exists, otherwise ask

**For multi-domain clients (2+ domains in CLIENT_CONFIG.md):**
Add Domain: field to every task, including the #1 template task.
Add domain list to Reference section.

**For @waiting tasks:** Always include Waiting on + Waiting since + Follow-up fields.

If `project_type == audit`: pre-populate Phase 0-5 tasks + mandatory knowledge extraction task.
Read `scaffold-project/AUDIT_TASKS.md` for the pre-populated task list.

### Step 5: Generate brand/ intelligence profile stubs
Create 7 empty files in `brand/`:
`7LAYER_DIAGNOSTIC.md`, `CONSTRAINT_MAP.md`, `REPAIR_ROADMAP.md`, `.md`, `VOICE.md`, `TARGET_PROFILE.md`, `POSITIONING.md`
Add task to TASKS.md: "Complete client intelligence profile" with checklist.

### Step 6: Generate .gitignore
Read `scaffold-project/FILE_TEMPLATES.md` → section ".gitignore".

### Step 7: Generate .claude/commands/ (ALL standard commands)

Create these command files in `.claude/commands/`. Each file has ONE line:
```
Read and follow the skill instructions in `../../core/skills/{skill-name}.md`.
User request: $ARGUMENTS
```

**Standard commands (ALL projects):**

| Command file | Skill | Purpose |
|---|---|---|
| `tasks.md` | `tasks.md` | Task management (create, update, complete — with auto-sync + ontology) |
| `task-sync.md` | `task-sync.md` | Bidirectional [Task Manager]/Asana sync |
| `task-oversight.md` | `task-oversight.md` | Cross-project task health scan |
| `council.md` | `council.md` | Multi-agent council deliberation |
| `pipeline.md` | `pipeline.md` | Auto-chained diagnostic/measurement/discovery pipeline |
| `day-start.md` | `day-start.md` | Morning routine (sync + oversight + brief) |
| `day-end.md` | `day-end.md` | End of day summary |
| `inbox-process.md` | `inbox-process.md` | Inbox triage |
| `query.md` | `query.md` | Ontology graph traversal |

**Client-type only:**

| Command file | Skill | Purpose |
|---|---|---|

### Step 8: Create symlinks to core
```bash
ln -s ../../core/skills {location}/skills
ln -s ../../core/sops {location}/sops
ln -s ../../core/agents {location}/agents
```

### Step 9: Generate memory/MEMORY.md
Slim index pointing to TASKS.md, CAPTAINS_LOG.md, brand/.

### Step 10: Type-specific files
- **client**: `processes/00-PROCESS-MAP.md`, `agencies/`, `takeover/correspondence/`, `audit/`, `analysis/mindset/`, `newsletter/EMAIL-BEST-PRACTICES.md`
- **audit**: `findings/`, `recommendations/`, `audits/`, `CLIENT_CONFIG.md`, `ACCESS_REGISTRY.md`, `data/{gtm-exports,feeds,screenshots}/`
- **internal**: `strategy/`, `brand/`, `content/linkedin/{posts,comments}/`, `leads/`, `analyses/`, `team/`, `events/`, `PUBLICATION_DIRECTORY.md`, `CONTENT_CALENDAR.md`

Read `scaffold-project/DIRECTORY_STRUCTURE.md` for exact structure per type.

### Step 10b: Create MCP permissions (ALWAYS — every new project)

**This step runs for EVERY project — new OR migrated. Without it, Chrome DevTools and other MCPs won't work.**

For migrations: copy from source AND merge with standard permissions:
```bash
cp {source}/.claude/settings.local.json {location}/.claude/settings.local.json
cp {source}/.mcp.json {location}/.mcp.json
```

For ALL projects (new AND migrated): ensure `settings.local.json` has Chrome DevTools:
```json
{
  "permissions": {
    "allow": [
      "mcp__chrome-devtools__list_pages",
      "mcp__chrome-devtools__navigate_page",
      "mcp__chrome-devtools__evaluate_script",
      "mcp__chrome-devtools__list_network_requests",
      "mcp__chrome-devtools__take_screenshot",
      "mcp__chrome-devtools__get_network_request",
      "mcp__chrome-devtools__take_snapshot",
      "mcp__chrome-devtools__click",
      "mcp__chrome-devtools__wait_for",
      "mcp__chrome-devtools__list_console_messages",
      "mcp__chrome-devtools__new_page"
    ]
  }
}
```
Every client needs Chrome DevTools for measurement audits (all clients go through audit).

### Step 11: Set up git repo
```bash
cd {location} && git init
```
Add to `../../methodology/PROJECT_REGISTRY.md`.

### Step 12: Post-scaffold verification

**Core files:**
- [ ] `CLAUDE.md` exists, <80 lines, references TASK_FORMAT_STANDARD + File Intake + Contact Registry
- [ ] `CAPTAINS_LOG.md` has initial entry
- [ ] `CONTACTS.md` created (Arcanian team pre-populated, Client/Agency sections ready to fill)
- [ ] `DOMAIN_CHANNEL_MAP.md` created if 2+ domains (or flagged in NEXT STEPS if single/unknown)
- [ ] `TASKS.md` uses v2.0 template (markdown list format, ExampleBrand gold standard)
- [ ] `TASKS.md` #1 task has: Layer, Domain, From, Owner, Impact, Created
- [ ] `TASKS_DONE.md` exists (empty template)
- [ ] `brand/` has 7 stub files
- [ ] `.gitignore` blocks raw data + .env

**Symlinks & agents:**
- [ ] `skills/` → core/skills/ (symlink resolves, shows 60+ skills)
- [ ] `sops/` → core/sops/ (symlink resolves)
- [ ] `agents/` → core/agents/ (symlink resolves, shows 11 agents + councils/)
- [ ] `.claude/agents/` inherited from hub root (11 subagents auto-discovered via directory walk)

**Commands (9 standard + 1 client-type):**
- [ ] `.claude/commands/` has: tasks, task-sync, task-oversight, council, pipeline, day-start, day-end, inbox-process, query
- [ ] If client type: also has newsletter

**Hooks (inherited from hub, verify firing):**
- [ ] Task-format-check hook fires on TASKS.md edit (warns missing Layer, @waiting fields)
- [ ] Task-sync-reminder hook fires on TASKS.md edit (prompts to sync)
- [ ] Ontology-check hook fires on Write/Edit (warns missing backlinks)
- [ ] PII guard fires on UserPromptSubmit
- [ ] Directory guard fires on PreToolUse (blocks cross-client writes)

**System integration:**
- [ ] `/tasks` works (returns overview)
- [ ] `/council diagnostic --client {slug} --question "test"` runs without error
- [ ] `~/.claude/user.json` exists on user's machine (for task-sync owner mapping)

**Project-type specific:**
- [ ] `upd/README.md` exists
- [ ] `meetings/raw/` exists
- [ ] `audit/evidence/AUDIT_LOG.md` exists (audit/client types)
- [ ] `.claude/settings.local.json` has Chrome DevTools permissions

**Final:**
- [ ] `git init` done
- [ ] Added to `core/methodology/PROJECT_REGISTRY.md`
- [ ] `git status` is clean

### Step 13: Output summary
```
Project scaffolded: {display_name}
Location: {location}
Type: {project_type} | Sync: {sync_system}
Domains: {domains or "TBD — ask client"}
Files created: {count}
Commands: 9 standard + {N} type-specific
Symlinks: skills + sops + agents → core/
Subagents: 11 (auto-discovered from hub .claude/agents/)
Hooks: 5 active (format check, sync reminder, ontology, PII, directory guard)

NEXT STEPS:
1. Fill CONTACTS.md with client team contacts (name, nickname, email, language)
2. Fill CLIENT_CONFIG.md with domains, tracking IDs, platform access
3. If multi-domain: complete DOMAIN_CHANNEL_MAP.md (map ALL channels to domains)
4. Run /council discovery --client {slug} --question "What can we learn?"
5. Run /7layer for initial diagnosis → brand/7LAYER_DIAGNOSTIC.md
6. Create real tasks with full ontology (Layer, Domain, From, Inform)
```

---

## Reference Files (progressive disclosure)

| File | Contents | When to load |
|---|---|---|
| `scaffold-project/DIRECTORY_STRUCTURE.md` | Full directory tree per type (client/audit/internal) | Step 1, 10 |
| `scaffold-project/FILE_TEMPLATES.md` | CLAUDE.md, CAPTAINS_LOG, TASKS, .gitignore, MEMORY templates | Steps 2-6, 9 |
| `scaffold-project/AUDIT_TASKS.md` | Pre-populated Phase 0-5 + knowledge extraction tasks | Step 4 (audit type only) |
| `scaffold-project/NAMING_CONVENTIONS.md` | → `../../methodology/NAMING_CONVENTIONS.md` | When creating files |
| `scaffold-project/MCP_SETUP.md` | MCP connection patterns per project type | Post-scaffold |
| `scaffold-project/REFERENCE_IMPLEMENTATIONS.md` | ExampleBrand + [Audit Framework] patterns | Context for decisions |

---

## Naming Conventions

Reference: `../../methodology/NAMING_CONVENTIONS.md`

Quick lookup:
- Process: `NN-DESCRIPTIVE-NAME.md`
- Finding: `FND-NNN_slug.md`
- Recommendation: `REC-NNN_slug.md`
- Correspondence: `{recipient}-{topic}-{status}.md`
- Newsletter: `MMDD-topic-market.html`
- Content: `LINKEDIN_POST_NN_TITLE.md`

---

## Knowledge Flow (MANDATORY for audit projects)

After every Phase 5, a pre-populated extraction task ensures learnings flow back to core:
- New patterns → `core/methodology/KNOWN_PATTERNS.md`
- SOP improvements → `core/sops/` + `SOP_CHANGELOG.md`
- Scripts → `core/scripts/`

See `scaffold-project/AUDIT_TASKS.md` for the full extraction task with checklist.
