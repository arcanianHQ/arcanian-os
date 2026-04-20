---
name: commit
description: Commit changes with issue tracking and execution logging
arguments:
  - name: message
    description: Commit message (auto-generated if not provided)
    required: false
  - name: skip-validation
    description: Skip pre-commit validation (not recommended)
    required: false
scope: shared
---

# ArcFlux Commit Command

## Purpose
Create a git commit with automatic issue reference, execution logging, and ICAO tracking.

## Prerequisites

- Active issue (`state.json` has `activeIssue`)
- Validation passed (or `--skip-validation`)
- Changes staged or ready to stage

## Behavior

### Standard Commit

```
/arcflux:commit

🔍 Pre-commit validation...
✅ Validation passed (confidence: 0.86)

📝 Generating commit message...

feat(AF-007): implement start command

- Add start command with dependency checking
- Update state.json on issue start
- Create execution log on start

Files changed:
  M src/commands/start.js
  M bin/arcflux.js
  A src/utils/dependencies.js

? Proceed with commit? (Y/n)
```

### With Custom Message

```
/arcflux:commit "add error handling for missing issues"

feat(AF-007): add error handling for missing issues

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Commit Message Format

```
<type>(<issue>): <description>

<body>

<footer>
```

Types:
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code restructuring
- `docs` - Documentation
- `test` - Tests
- `chore` - Maintenance

## Execution Logging

On commit, update `.arcflux/execution/AF-007/_current.json`:

```json
{
  "commits": [
    {
      "hash": "abc123",
      "timestamp": "2026-01-09T15:30:00Z",
      "message": "feat(AF-007): implement start command",
      "files": ["src/commands/start.js", "bin/arcflux.js"],
      "phase": "implement"
    }
  ]
}
```

## Token/Cost Logging

Update `.arcflux/execution/_ledger.json`:

```json
{
  "by_issue": {
    "AF-007": {
      "commits": 3,
      "last_commit": "2026-01-09T15:30:00Z"
    }
  }
}
```

## Integration with commit-commands

This command uses the `commit-commands` peer plugin internally:

1. ArcFlux validates and prepares
2. Calls `/commit` from commit-commands
3. ArcFlux logs execution data

## Validation Enforcement

```
/arcflux:commit

❌ Cannot commit - validation not passed

Last validation: 0.72 (below 0.80 threshold)

Run /arcflux:validate to check issues.
Or use --skip-validation (not recommended).
```

## Post-Commit Actions

After successful commit:
1. Log commit to execution history
2. Update issue phase if applicable
3. Suggest next steps

```
✅ Committed: abc123

Next steps:
  - Continue implementing, or
  - Run /arcflux:phase review to move to review
  - Run /arcflux:status to see progress
```
