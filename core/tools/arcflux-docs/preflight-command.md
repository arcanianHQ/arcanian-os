---
scope: shared
---

# ArcFlux Preflight Command

Validate your ArcFlux setup before running operations.

## Overview

The preflight command checks your ArcFlux configuration and project setup for issues that could cause problems during development. It runs automatically before certain commands and can be run manually.

## Quick Start

```bash
# Run preflight checks
arcflux preflight

# Auto-fix what can be fixed
arcflux preflight --fix

# Show all passed checks
arcflux preflight --verbose
```

## When Preflight Runs

| Command | Preflight Behavior |
|---------|-------------------|
| `arcflux start` | Blocks on critical, warns on warnings |
| `arcflux validate` | Blocks on critical |
| `arcflux commit` | Blocks on critical |
| `arcflux preflight` | Manual full check |

## Check Categories

### Critical (Blocks Execution)

These must be fixed before ArcFlux can work:

| Check | What It Validates |
|-------|-------------------|
| `.arcflux/` directory | ArcFlux initialized |
| `config.json` | Valid JSON configuration |
| `state.json` | State file exists |
| `project.name` | Project name configured |
| `project.prefix` | Issue prefix set (2-4 uppercase letters) |

### Warnings (Prompts User)

These should be fixed but won't block:

| Check | What It Validates |
|-------|-------------------|
| `architecture.md` | Has meaningful content (> 100 chars) |
| `github.org` | GitHub org set (if enabled) |
| `github.repo` | GitHub repo set (if enabled) |
| `linear.workspace` | Linear workspace set (if enabled) |
| `linear.team` | Linear team set (if enabled) |

### Info (Just Displays)

Suggestions for improvement:

| Check | What It Validates |
|-------|-------------------|
| `roadmap.md` | Roadmap file exists |
| `CLAUDE.md` | Claude Code context file exists |
| `.claude/commands` | Slash commands directory exists |
| `stacks` | Stack configuration matches detected files |

## Options

```bash
arcflux preflight [options]
```

| Option | Description |
|--------|-------------|
| `--json` | Output as JSON (for scripting) |
| `-q, --quiet` | Silent mode, exit code only |
| `-v, --verbose` | Show all passed checks |
| `--strict` | Treat warnings as errors |
| `--fix` | Auto-fix what can be fixed |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 1 | Warnings found (or warnings + `--strict`) |
| 2 | Critical issues found |

## Auto-Fix Mode

The `--fix` flag automatically creates missing files:

```bash
arcflux preflight --fix
```

**What it creates:**
- `.arcflux/memory/` directory
- `.arcflux/memory/issues/` directory
- `issues/_index.md` with template
- `architecture.md` with template
- `roadmap.md` with template
- `CLAUDE.md` with template
- `.claude/commands/` directory

**What it cannot fix:**
- Invalid JSON in config files
- Missing project name/prefix (requires user input)
- Integration credentials (GitHub, Linear)

## JSON Output

For CI/CD integration:

```bash
arcflux preflight --json
```

```json
{
  "status": "warning",
  "critical": [],
  "warnings": [
    {
      "check": "architecture.md",
      "message": "Architecture file is mostly empty (< 100 chars)",
      "fix": "Document your system architecture in .arcflux/memory/architecture.md"
    }
  ],
  "info": [...],
  "passed": [
    ".arcflux directory",
    "config.json valid",
    "state.json exists",
    "project.name set",
    "project.prefix valid",
    ...
  ]
}
```

## CI/CD Usage

```bash
# In CI pipeline - fail on any issues
arcflux preflight --strict --quiet
if [ $? -ne 0 ]; then
  echo "Preflight failed"
  exit 1
fi
```

## Example Output

### Passing

```
🔍 ArcFlux Preflight Check

Info:
  ℹ stacks: Detected stacks: typescript, nodejs (not in config)
    → Add "stacks": ["typescript","nodejs"] to config

────────────────────────────────────────
12 passed, 0 warnings, 0 critical, 1 info

✓ PREFLIGHT PASSED
```

### With Warnings

```
🔍 ArcFlux Preflight Check

Warnings:
  ⚠ architecture.md: Architecture file is mostly empty (< 100 chars)
    → Document your system architecture in .arcflux/memory/architecture.md
  ⚠ github.org: GitHub enabled but organization not set
    → Set integrations.github.org in config or disable with --no-github

────────────────────────────────────────
10 passed, 2 warnings, 0 critical, 0 info

⚠ PREFLIGHT PASSED WITH WARNINGS
```

### Critical Failure

```
🔍 ArcFlux Preflight Check

Critical Issues (must fix):
  ✗ project.prefix: Issue prefix not configured
    → Add "project.prefix" (2-4 uppercase letters) to config

────────────────────────────────────────
8 passed, 0 warnings, 1 critical, 0 info

✗ PREFLIGHT FAILED
```

## Best Practices

1. **Run after init**: Verify setup is complete
2. **Run before commits**: Catch config issues early
3. **Use in CI**: `arcflux preflight --strict --quiet`
4. **Use --fix for new projects**: Creates all recommended files

---

## Permission Prediction

Predict what Claude Code permissions will be needed for issues before running them.

### Single Issue

```bash
# Analyze an issue
arcflux preflight --issue AF-001

# Save permissions to .claude/settings.json
arcflux preflight --issue AF-001 --save

# Verbose output
arcflux preflight --issue AF-001 --verbose
```

### Multiple Issues (Batch)

```bash
# Analyze multiple issues
arcflux preflight --issues AF-001,AF-002,AF-003

# Save combined permissions
arcflux preflight --issues AF-001,AF-002,AF-003 --save

# JSON output
arcflux preflight --issues AF-001,AF-002 --json
```

### Permission Options

| Option | Description |
|--------|-------------|
| `--issue <id>` | Predict permissions for a single issue |
| `--issues <ids>` | Predict for multiple issues (comma-separated) |
| `--save` | Save predicted permissions to `.claude/settings.json` |
| `-v, --verbose` | Show detailed analysis |
| `--json` | Output as JSON |

### Output

The permission prediction outputs:

1. **Tools Required**: Read, Edit, Write, Bash, Glob, Grep
2. **Files to Edit**: Extracted from issue file paths
3. **Bash Commands**: npm, docker, drush patterns
4. **Confidence Level**: low/medium/high based on analysis

### Example Output

```
🔐 Permission Manifest

Issue: AF-061
Confidence: high

Tools Required:
  • Read
  • Glob
  • Grep
  • Write
  • Edit
  • Bash

Files to Edit:
  • src/commands/drupal-config.js
  • src/cli/drupal-api.js

Bash Commands (Allow):
  ✓ composer *
  ✓ drush *
  ✓ npm test

────────────────────────────────────────
Suggested .claude/settings.json:

{
  "permissions": {
    "allow": [
      "Read",
      "Edit(src/commands/drupal-config.js)",
      "Bash(npm test)"
    ],
    "deny": [
      "Bash(rm -rf *)"
    ]
  }
}
```

### How It Works

The analyzer reads issue markdown files and extracts:

1. **File paths** mentioned in backticks or paths like `src/commands/*.js`
2. **Keywords** like "npm", "docker", "drush", "test", "build"
3. **"Files to Create/Modify"** sections for high confidence
4. **Directory patterns** like `src/commands/**`

### Workflow for Automated Runs

```bash
# 1. Predict permissions for batch
arcflux preflight --issues AF-001,AF-002 --save

# 2. Review the settings
cat .claude/settings.json

# 3. Run batch with pre-authorized permissions
arcflux batch AF-001 AF-002
```

---

## Related Commands

- `arcflux init` - Initialize ArcFlux project
- `arcflux doctor` - Check environment/tools
- `arcflux status` - Show current state
- `arcflux batch` - Process multiple issues (auto-runs preflight)
