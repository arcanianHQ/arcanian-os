---
scope: shared
---

# ArcFlux Naming Conventions

This document defines naming conventions used throughout ArcFlux.

---

## Skills

Skills are stored in `arcflux/skills/` and follow the pattern:

```
{category}-{name}/
└── SKILL.md
```

### Categories

| Prefix | Category | Description |
|--------|----------|-------------|
| `frontend-` | Frontend/UI | Design and UI generation skills |
| `backend-` | Backend/API | Server, API, database skills |
| `devops-` | DevOps | Infrastructure, deployment skills |
| `testing-` | Testing | Test strategy, coverage skills |
| `security-` | Security | Security scanning, hardening skills |

### Frontend Skills

| Skill Name | Path | Description |
|------------|------|-------------|
| `frontend-design` | `skills/frontend-design/` | Anthropic's generic design skill |
| `frontend-brand-book` | `skills/frontend-brand-book/` | Company brand guidelines |
| `frontend-brutalist` | `skills/frontend-brutalist/` | Brutalist design aesthetic |
| `frontend-luxury` | `skills/frontend-luxury/` | Luxury/refined aesthetic |
| `frontend-minimal` | `skills/frontend-minimal/` | Minimalist design |
| `frontend-playful` | `skills/frontend-playful/` | Playful/toy-like aesthetic |

### Usage

When starting a frontend issue:

```bash
arcflux start XAR-001 --create --title "Login Page" --type frontend --style design
```

The `--style` value maps to the skill folder:
- `--style design` → `skills/frontend-design/`
- `--style brand-book` → `skills/frontend-brand-book/`
- `--style brutalist` → `skills/frontend-brutalist/`

---

## Issue Types

Issues have a `type` field that determines which skills apply:

| Type | Description | Skills Applied |
|------|-------------|----------------|
| `frontend` | UI/UX work | `frontend-*` skills |
| `backend` | API/server work | `backend-*` skills |
| `devops` | Infrastructure | `devops-*` skills |
| `testing` | Test work | `testing-*` skills |
| `other` | General work | No automatic skills |

---

## Issue Keys

Issue keys follow the pattern:

```
{PREFIX}-{NUMBER}
```

- **PREFIX**: 2-5 uppercase letters (project identifier)
- **NUMBER**: Sequential number (001, 002, etc.)

Examples:
- `AF-001` - ArcFlux issue 1
- `XAR-042` - Test project issue 42
- `PROJ-100` - Project issue 100

---

## Branch Names

Git branches follow the pattern:

```
{prefix}/{issue-key}-{slug}
```

- **prefix**: Configurable (default: `feature/`)
- **issue-key**: Lowercase issue key
- **slug**: Slugified title (max 60 chars total)

Examples:
- `feature/af-001-cli-entry-point`
- `feature/xar-042-login-page`
- `bugfix/proj-100-fix-auth`

---

## File Structure

### Skills Directory

```
arcflux/
└── skills/
    ├── frontend-design/
    │   └── SKILL.md
    ├── frontend-brand-book/
    │   ├── SKILL.md
    │   ├── colors.md
    │   └── typography.md
    └── backend-api/
        └── SKILL.md
```

### Issue Files

```
.arcflux/memory/issues/
├── _index.md           # Issue index
├── AF-001.md           # Individual issues
├── AF-002.md
└── ...
```

---

## Command Names

CLI commands use lowercase with hyphens:

| Command | Description |
|---------|-------------|
| `arcflux init` | Initialize project |
| `arcflux start` | Start issue |
| `arcflux phase` | Manage phases |
| `arcflux status` | Show status |

Slash commands use the same pattern:

| Slash Command | Description |
|---------------|-------------|
| `/arcflux-init` | Initialize project |
| `/arcflux-start` | Start issue |
| `/arcflux-phase` | Manage phases |
| `/arcflux-status` | Show status |

---

## Configuration Keys

Configuration uses camelCase:

```json
{
  "project": {
    "name": "MyProject",
    "prefix": "MP"
  },
  "workflow": {
    "phases": ["explore", "plan", ...],
    "requiredPhases": ["explore", "implement"]
  },
  "integrations": {
    "github": {
      "enabled": true,
      "branchPrefix": "feature/"
    }
  }
}
```

---

*Last updated: 2026-01-09*
