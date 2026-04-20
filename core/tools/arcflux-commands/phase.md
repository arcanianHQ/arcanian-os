---
name: phase
description: Manage workflow phases
usage: /arcflux:phase [action]
mode: hybrid
cli_command: arcflux phase
arguments:
  - name: action
    description: Phase action (next, back, skip, complete, set)
    required: false
scope: shared
---

# /arcflux:phase

Manage the 7-phase development workflow.

## Mode: Hybrid (CLI + Claude)

This command uses the **hybrid approach**:
1. Claude runs the `arcflux phase` CLI command
2. CLI handles state updates and validation
3. Claude provides phase-specific guidance

## Prerequisites Check

Verify:
1. CLI installed: `arcflux --version`
2. Active issue exists: `arcflux status`

## Execution

Run the CLI command:

```bash
arcflux phase [action] [options]
```

### Actions

| Action | CLI Command | Description |
|--------|-------------|-------------|
| (none) | `arcflux phase` | Show current phase |
| next | `arcflux phase next` | Advance to next phase |
| back | `arcflux phase back` | Return to previous |
| skip | `arcflux phase skip` | Skip current phase |
| complete | `arcflux phase complete` | Mark issue done |
| set | `arcflux phase set --to X` | Jump to phase |

### Options

| Option | Description |
|--------|-------------|
| `-y, --yes` | Skip confirmation prompts |
| `-f, --force` | Force (skip required phases) |
| `--to <phase>` | Target phase for set |
| `--reason <text>` | Reason for skipping |

## The 7 Phases

```
explore → plan → architect → implement → review → test → document
```

| Phase | Claude's Role |
|-------|---------------|
| **explore** | Help search codebase, understand requirements |
| **plan** | Help break down tasks |
| **architect** | Help design solution |
| **implement** | Write the code |
| **review** | Run validation (when available) |
| **test** | Run tests, add coverage |
| **document** | Update docs |

## Examples

```bash
# Show current
arcflux phase

# Advance
arcflux phase next --yes

# Skip (with reason)
arcflux phase skip --reason "Simple bugfix"

# Complete issue
arcflux phase complete --yes
```

## After Phase Change

When CLI completes, Claude should provide phase-specific guidance:

**Explore:** "Search the codebase for related code. What are you building?"

**Plan:** "Let's break this down into tasks. What's the scope?"

**Implement:** "Ready to code. What file should we start with?"

**Review:** "Let's review the changes. Run `/arcflux:validate` when ready."

**Complete:** "Issue done! Ready for `/arcflux:start <next-issue>`"
