# Skill: Project Validation (`/validate`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Checks a project's health against the Arcanian scaffold standard. Run after `/scaffold-project` to verify, or periodically to catch drift.

## Trigger

Use when: user says `/validate`, "check project health", "is this project set up correctly", or after scaffolding a new project.

## Input

| Input | Required | Default |
|---|---|---|
| `project_path` | No | Current working directory |

## Checks

Run each check and record pass/fail. Stop-on-error = false (run all checks, report all).

### 1. CLAUDE.md
- [ ] File exists at project root
- [ ] Line count is under 80 lines
- If missing: FAIL — "No CLAUDE.md. Run /scaffold-project or create manually."
- If over 80 lines: WARN — "CLAUDE.md is {N} lines. Target: <80. Move details to memory/ or brand/."

### 2. CAPTAINS_LOG.md
- [ ] File exists at project root
- [ ] Has at least one dated entry (pattern: `## YYYY-MM-DD`)
- If missing: FAIL — "No CAPTAINS_LOG.md. Create from core/templates/CAPTAINS_LOG_TEMPLATE.md."

### 3. TASKS.md
- [ ] File exists at project root
- [ ] Has YAML frontmatter (opens with `---`)
- [ ] Contains at least one priority section heading (`## P0`, `## P1`, `## P2`, or `## P3`)
- If missing: FAIL — "No TASKS.md. Create from core/templates/TASKS_TEMPLATE.md."
- If malformed: WARN — "TASKS.md missing frontmatter or priority sections."

### 4. TASKS_DONE.md
- [ ] File exists at project root
- If missing: WARN — "No TASKS_DONE.md. Will be created on first /tasks complete."

### 5. brand/ intelligence profile
- [ ] Directory `brand/` exists
- [ ] Contains these 7 files: `7LAYER_DIAGNOSTIC.md`, `CONSTRAINT_MAP.md`, `REPAIR_ROADMAP.md`, `.md`, `VOICE.md`, `TARGET_PROFILE.md`, `POSITIONING.md`
- Report which are present and which are missing
- If <4 present: WARN — "Brand intelligence profile incomplete ({N}/7)."

### 6. skills/ symlink
- [ ] `skills/` exists and is a symlink
- [ ] Symlink resolves (target directory exists and contains .md files)
- If missing or broken: FAIL — "skills/ symlink missing or broken. Run: ln -s ../../core/skills ./skills"

### 7. sops/ symlink
- [ ] `sops/` exists and is a symlink
- [ ] Symlink resolves (target directory exists and contains .md files)
- If missing or broken: FAIL — "sops/ symlink missing or broken. Run: ln -s ../../core/sops ./sops"

### 8. .gitignore
- [ ] File exists at project root
- [ ] Contains `.env` pattern
- [ ] Contains a raw data exclusion (e.g., `data/`, `*.csv`, `*.xlsx`, or `raw/`)
- If missing: FAIL — "No .gitignore. Secrets and raw data may leak."

### 9. .claude/commands/tasks.md
- [ ] File exists at `.claude/commands/tasks.md`
- If missing: WARN — "No .claude/commands/tasks.md. /tasks shortcut won't work."

### 10. No .env files
- [ ] Scan project root (1 level deep) for `.env`, `.env.*` files
- If found: FAIL — "Found .env file(s): {list}. Remove or add to .gitignore immediately."

### 11. No PII patterns in .md files
- [ ] Quick scan .md files in project root + brand/ for obvious PII patterns:
  - Email regex outside known contacts files: `[a-z]+@[a-z]+\.[a-z]+`
  - Phone numbers: `\+?[0-9]{10,12}`
  - Hungarian tax ID: `[0-9]{10}`
- Skip files named `*CONTACTS*` or `*REGISTRY*` (expected to contain contact data)
- If found: WARN — "Possible PII in {file}: {pattern}. Review and redact if needed."

## Output Format

```
/validate — {project_name}
─────────────────────────────
 ✓ CLAUDE.md .................. 54 lines
 ✓ CAPTAINS_LOG.md ............ 3 entries
 ✓ TASKS.md ................... frontmatter OK, 4 sections
 ✗ TASKS_DONE.md .............. missing
 ✓ brand/ ..................... 7/7 files
 ✓ skills/ symlink ............ resolves → core/skills
 ✓ sops/ symlink .............. resolves → core/sops
 ✓ .gitignore ................. .env + data/ blocked
 ✗ .claude/commands/tasks.md .. missing
 ✓ No .env files
 ⚠ PII scan ................... 1 warning (see below)
─────────────────────────────
Result: 8 pass, 1 fail, 2 warnings

Action items:
1. Create TASKS_DONE.md (will auto-create on first /tasks complete)
2. Create .claude/commands/tasks.md for /tasks shortcut
3. Review brand/VOICE.md line 12 — possible email address
```
