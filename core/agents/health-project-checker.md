---
id: health-project-checker
name: "Project Integrity Checker"
focus: "Project structure — CLAUDE.md, TASKS.md, CONTACTS.md, symlinks, brand files"
context: [infrastructure]
data: [filesystem]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.25
---

# Agent: Project Integrity Checker

## Purpose

Validates that each project in `clients/` and `internal/` has the required file structure, symlinks, and configuration. Catches projects that were scaffolded incompletely or have drifted.

## Process

For each directory in `clients/` and `internal/`:

1. **CLAUDE.md** — exists? Under 80 lines?
2. **TASKS.md** — exists? Has YAML frontmatter (`project:`, `sync:`)? Has priority sections (P0, P1)?
3. **CAPTAINS_LOG.md** — exists? Has at least one `## YYYY-MM-DD` entry?
4. **CONTACTS.md** — exists? (MANDATORY per `CONTACT_REGISTRY_STANDARD.md`)
5. **brand/** — count files present out of 7: 7LAYER_DIAGNOSTIC, BELIEF_PROFILE, CONSTRAINT_MAP, ICP, POSITIONING, VOICE, REPAIR_ROADMAP
6. **skills/** symlink — exists and resolves to `core/skills/`?
7. **sops/** symlink — exists and resolves to `core/sops/`?
8. **.gitignore** — exists and blocks `.env`?
9. **Multi-domain check:** If `CLIENT_CONFIG.md` lists 2+ domains → `DOMAIN_CHANNEL_MAP.md` MUST exist. Missing = CRITICAL.

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 1

Per-project score (0-100), then average across all projects.

## Output

```markdown
### Project Integrity [Score: {0-100}/100]

| Project | CLAUDE | TASKS | LOG | CONTACTS | Brand | Symlinks | Score |
|---|---|---|---|---|---|---|---|
| {slug} | {ok/missing} | {ok/issues} | {ok/missing} | {ok/MISSING} | {N}/7 | {ok/broken} | {0-100} |

**Critical:** {list of CRITICAL issues}
**Warnings:** {list of warnings}

Evidence: [OBSERVED: filesystem check, {date}]
```
