---
scope: shared
---

# Project Configuration Guide

ArcFlux projects are configured via `.arcflux/config.json` and optionally a `CLAUDE.md` file for Claude Code integration.

## Project Structure

```
your-project/
├── .arcflux/
│   ├── config.json          # Project configuration
│   ├── state.json           # Current state (auto-managed)
│   └── memory/
│       ├── issues/          # Issue tracking
│       │   ├── _index.md    # Issue index
│       │   └── XX-001.md    # Individual issues
│       ├── captains-log.md  # Decision journal
│       ├── roadmap.md       # Project roadmap
│       └── stacks/          # Technology knowledge
│           └── {stack}.md   # Stack-specific docs
├── CLAUDE.md                # Claude Code bootstrap (optional)
└── ... your code ...
```

## config.json

The main configuration file for your project.

### Full Template

```json
{
  "project": {
    "name": "My Project",
    "version": "0.1.0",
    "type": "node-cli",
    "issuePrefix": "MP",
    "description": "Brief project description"
  },
  "workflow": {
    "phases": ["explore", "plan", "architect", "implement", "review", "test", "document"],
    "commitFrequency": "feature",
    "tdd": false
  },
  "quality": {
    "maxFileLines": 500,
    "maxFunctionLines": 50,
    "testCoverage": 80,
    "noConsoleLog": true,
    "noHardcodedSecrets": true
  },
  "services": {
    "github": {
      "enabled": true,
      "org": "your-org",
      "repo": "your-repo",
      "defaultBranch": "main"
    },
    "linear": {
      "enabled": false,
      "workspace": "",
      "team": "",
      "project": ""
    },
    "lagoon": {
      "enabled": false,
      "project": "",
      "environments": {
        "dev": "",
        "staging": "",
        "prod": ""
      }
    },
    "supabase": {
      "enabled": false,
      "project": "",
      "org": ""
    }
  },
  "stack": {
    "backend": {
      "type": "node",
      "version": "20"
    },
    "frontend": {
      "type": "react",
      "version": "18"
    },
    "database": {
      "type": "postgresql",
      "version": "15"
    },
    "runtime": {
      "node": "20",
      "php": ""
    }
  },
  "drupal": {
    "version": "11",
    "docker": true,
    "api": {
      "baseUrl": "http://localhost:8080",
      "username": "admin",
      "password": "admin"
    }
  }
}
```

### Section: project

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Project display name |
| `version` | string | Semantic version |
| `type` | string | Project type: `node-cli`, `node-api`, `drupal`, `react`, `next`, etc. |
| `issuePrefix` | string | 2-3 letter prefix for issues (e.g., "AF", "MP") |
| `description` | string | Brief description of the project |

### Section: workflow

| Field | Type | Description |
|-------|------|-------------|
| `phases` | array | Ordered list of workflow phases |
| `commitFrequency` | string | When to commit: `feature`, `phase`, `manual` |
| `tdd` | boolean | Enforce test-driven development |

**Default phases:**
```
explore → plan → architect → implement → review → test → document
```

### Section: quality

| Field | Type | Description |
|-------|------|-------------|
| `maxFileLines` | number | Maximum lines per file (default: 500) |
| `maxFunctionLines` | number | Maximum lines per function (default: 50) |
| `testCoverage` | number | Required test coverage % (default: 80) |
| `noConsoleLog` | boolean | Disallow console.log in production code |
| `noHardcodedSecrets` | boolean | Check for hardcoded secrets |

### Section: services

Configure external service integrations.

**GitHub:**
```json
"github": {
  "enabled": true,
  "org": "my-org",
  "repo": "my-repo",
  "defaultBranch": "main"
}
```

**Linear:**
```json
"linear": {
  "enabled": true,
  "workspace": "my-workspace",
  "team": "ENG",
  "project": "Q1 2026"
}
```

**Lagoon (Drupal hosting):**
```json
"lagoon": {
  "enabled": true,
  "project": "my-drupal-site",
  "environments": {
    "dev": "dev.my-site.lagoon.site",
    "staging": "staging.my-site.lagoon.site",
    "prod": "my-site.com"
  }
}
```

### Section: stack

Define your technology stack for context-aware assistance.

```json
"stack": {
  "backend": {
    "type": "drupal",
    "version": "11"
  },
  "frontend": {
    "type": "react",
    "version": "18"
  },
  "database": {
    "type": "mariadb",
    "version": "10.11"
  },
  "runtime": {
    "node": "20",
    "php": "8.3"
  }
}
```

**Common stack types:**
- Backend: `node`, `drupal`, `laravel`, `django`, `rails`, `go`
- Frontend: `react`, `vue`, `svelte`, `next`, `nuxt`, `angular`
- Database: `postgresql`, `mysql`, `mariadb`, `sqlite`, `mongodb`

### Section: drupal (Drupal projects only)

```json
"drupal": {
  "version": "11",
  "docker": true,
  "webroot": "web",
  "api": {
    "baseUrl": "http://localhost:8080",
    "username": "admin",
    "password": "admin"
  }
}
```

---

## CLAUDE.md

The `CLAUDE.md` file is read by Claude Code at the start of each session. It provides context and instructions.

### Template

```markdown
# {Project Name}

> **IMPORTANT**: Read this file first on every session.

## Quick Context Load

To get full context after a session restart, read these files in order:

1. **This file** - Overview and instructions
2. `.arcflux/state.json` - Current active issue and phase
3. `.arcflux/memory/captains-log.md` - Decision journal
4. `.arcflux/memory/roadmap.md` - What we're building

## What is {Project Name}?

{2-3 sentences describing what this project does}

## Project Structure

```
{project}/
├── src/                     # Source code
│   ├── commands/           # CLI commands (if applicable)
│   └── utils/              # Utilities
├── .arcflux/               # ArcFlux tracking
└── ...
```

## Development Guidelines

1. **Issue-First**: Always have an active issue before coding
2. **Phase-Aware**: Follow the 7-phase workflow
3. **Update State**: Use `arcflux phase next` to advance
4. **Test Before Commit**: Run tests before committing

## Key Commands

```bash
arcflux status              # Show current state
arcflux start <issue>       # Start work on issue
arcflux phase next          # Advance to next phase
arcflux commit              # Commit with context
arcflux ready               # Prepare for PR
```

## Current Focus

{What's currently being worked on}

## Session Recovery Checklist

If starting fresh session:

- [ ] Read this CLAUDE.md
- [ ] Run `arcflux status` to see current state
- [ ] Check `.arcflux/memory/captains-log.md` for recent decisions
- [ ] Continue from where we left off
```

### Best Practices for CLAUDE.md

1. **Keep it focused**: Only include what Claude needs to know
2. **Update regularly**: Keep current focus section up to date
3. **Link to details**: Reference other files rather than duplicating content
4. **Include recovery steps**: Help Claude resume after context loss

---

## Initializing a Project

### Interactive Mode

```bash
arcflux init
```

Prompts for:
- Project name
- Issue prefix
- Project type
- Services to enable

### Non-Interactive Mode (for scripts/Claude Code)

```bash
arcflux init --yes
```

Uses defaults or existing config.

### Adopting Existing Project

```bash
arcflux adopt
```

Creates `.arcflux/` structure for an existing project without modifying existing files.

---

## Project Types

### Node.js CLI

```json
{
  "project": {
    "type": "node-cli"
  },
  "stack": {
    "runtime": { "node": "20" }
  }
}
```

### Drupal

```json
{
  "project": {
    "type": "drupal"
  },
  "stack": {
    "backend": { "type": "drupal", "version": "11" },
    "database": { "type": "mariadb", "version": "10.11" },
    "runtime": { "php": "8.3" }
  },
  "drupal": {
    "docker": true,
    "webroot": "web"
  }
}
```

### React/Next.js

```json
{
  "project": {
    "type": "next"
  },
  "stack": {
    "frontend": { "type": "next", "version": "14" },
    "runtime": { "node": "20" }
  }
}
```

### Full-Stack (Node + React)

```json
{
  "project": {
    "type": "fullstack"
  },
  "stack": {
    "backend": { "type": "node", "version": "20" },
    "frontend": { "type": "react", "version": "18" },
    "database": { "type": "postgresql", "version": "15" }
  }
}
```

---

## Environment Variables

Some features require environment variables:

| Variable | Purpose |
|----------|---------|
| `LINEAR_API_KEY` | Linear integration |
| `GITHUB_TOKEN` | GitHub API (or use `gh auth`) |
| `SUPABASE_ACCESS_TOKEN` | Supabase CLI |

---

## Requirements

### Required

- **Node.js** 18+ (20 recommended)
- **Git** 2.x

### Optional (by feature)

| Feature | Requirement |
|---------|-------------|
| GitHub integration | `gh` CLI (`brew install gh`) |
| Linear integration | `LINEAR_API_KEY` or `linearis` CLI |
| Drupal projects | Docker, Composer |
| Supabase | `supabase` CLI |
| Fly.io deployment | `flyctl` CLI |
