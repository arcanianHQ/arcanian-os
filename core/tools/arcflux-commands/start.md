---
name: start
description: Start work on an issue with context loading
usage: /arcflux:start <issue-key>
mode: hybrid
cli_command: arcflux start
arguments:
  - name: issue
    description: Issue ID (e.g., AF-007)
    required: true
scope: shared
---

# /arcflux:start

Start work on an issue, setting up the development environment.

## Mode: Hybrid (CLI + Claude)

This command uses the **hybrid approach**:
1. Claude runs the `arcflux start` CLI command
2. CLI handles state management and branch creation
3. Claude provides context and guidance after

## Prerequisites Check

Verify:
1. CLI installed: `arcflux --version`
2. Project initialized: `.arcflux/` exists

## Execution

Run the CLI command:

```bash
arcflux start <issue-key> [options]
```

### Options

| Option | Description |
|--------|-------------|
| `-f, --force` | Switch even if working on another issue |
| `-c, --create` | Create issue file if doesn't exist |
| `-t, --title <title>` | Issue title (with --create) |
| `--no-branch` | Don't create git branch |

### Examples

```bash
# Start existing issue
arcflux start AF-001

# Create and start new issue
arcflux start AF-050 --create --title "Add new feature"

# Force switch
arcflux start AF-002 --force

# Without branch
arcflux start AF-001 --no-branch
```

## What CLI Does

1. Validates issue exists (or creates with --create)
2. Creates/switches git branch: `feature/af-001-slug`
3. Updates `state.json` with activeIssue
4. Sets phase to "explore"
5. Updates issue status to IN_PROGRESS
6. Shows workflow guidance

## After Starting

When CLI completes, Claude should:

1. Confirm the issue is now active
2. Remind user they're in **Explore** phase
3. Suggest next actions:
   - Read issue requirements
   - Search codebase for related code
   - When ready: `/arcflux:phase next`

## Error Handling

**Issue not found:**
```bash
arcflux start AF-050 --create --title "Description"
```

**Already working on another issue:**
```bash
arcflux start AF-002 --force
```

**Not an ArcFlux project:**
```bash
arcflux init
```
