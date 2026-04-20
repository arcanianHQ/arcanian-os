---
scope: shared
---

# Arcanian IT Operations

This repository is the central documentation hub for all IT systems, tools, and operational rules used at Arcanian.

## Purpose

**Why this project exists:**

Arcanian uses multiple IT systems (Asana, GitHub, and others) that need to work together efficiently. This repository:

1. **Documents all IT systems** - Configuration, credentials, and how they connect
2. **Defines operational rules** - Naming conventions, project structures, workflows
3. **Provides AI assistant context** - Enables Claude Code to understand and operate within Arcanian's systems
4. **Ensures consistency** - Single source of truth for how things should be done

This is a living document that grows as new systems are added or rules are created.

## Quick Start for Claude

When starting a new session, read these files in order:

1. **SYSTEMS.md** - Connected systems (Asana, GitHub, Todoist) with IDs and credentials
2. **RULES.md** - Operational rules (naming conventions, project structures)

### Key Information

| Item | Value |
|------|-------|
| Asana Workspace | `1206169144105850` (arcanian.ai) |
| Asana Team (for projects) | `1210213282346183` (Arcanian Consulting) |
| GitHub Repo | ArcanianAi/new-it-arcanian |
| Co-founders | László Fazakas, Dóra Diószegi |
| Co-worker | Éva Erdei |

### Current Rules Summary

| Rule | Description |
|------|-------------|
| R001 | Asana project naming: `PREFIX:NAME` or `PREFIX:CLIENT-SERVICE` |
| R002 | (Legacy) Full-service clients need 6 services - superseded by R003 |
| R003 | Client project consolidation: One project per client with Service Type custom field |

### Prefixes

- `A:` = Arcanian (internal)
- `C:` = Client
- `DH:` = DH Division
- `NX:` = Nexus

## Files

| File/Folder | Description |
|-------------|-------------|
| README.md | This file - quick start guide |
| RULES.md | Operational rules (R001, R002, ...) |
| SYSTEMS.md | Connected systems configuration |
| ACCESS.md | Access management - who has access to what |
| onboarding/ | Step-by-step onboarding guides for each system |
| how-to/ | Knowledge base - discovered procedures and guides |
| .gitignore | Git ignore patterns |

## Verification Commands

After starting a session, verify connections:

```
# Verify Asana connection
mcp__asana__asana_get_user()

# Verify GitHub connection
git remote -v
```

---

Last updated: 2026-01-04
