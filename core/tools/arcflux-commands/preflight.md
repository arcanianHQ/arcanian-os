---
name: preflight
description: Run system validation checks before operations
arguments:
  - name: check
    description: Specific check (config, memory, services, all)
    required: false
  - name: strict
    description: Treat warnings as errors
    required: false
  - name: fix
    description: Auto-fix issues where possible
    required: false
  - name: json
    description: Output in JSON format
    required: false
scope: shared
---

# ArcFlux Preflight Command

## Purpose
Validate ArcFlux setup, configuration, and memory bank before operations. Ensures the system is properly configured.

## Check Categories

### Critical (Blocks Operations)

| Check | Description |
|-------|-------------|
| `.arcflux/` exists | Directory must exist |
| `config.json` valid | Must be valid JSON |
| `state.json` exists | State file required |
| `issuePrefix` set | Must have issue prefix |
| `_index.md` exists | Issue index required |

### Warning (Prompts User)

| Check | Description |
|-------|-------------|
| `architecture.md` content | Should have >100 chars |
| `roadmap.md` content | Should not be empty |
| GitHub configured | If enabled, org/repo set |
| Linear configured | If enabled, workspace/team set |
| Stack templates | Should have stack files |

### Info (Display Only)

| Check | Description |
|-------|-------------|
| Token usage | Show usage stats |
| Days since activity | Last activity time |
| Issues in progress | Current work count |

## Behavior

### Full Preflight Check

```
/arcflux:preflight

🔍 ArcFlux Preflight Check

═══ Critical Checks ═══
  ✅ .arcflux/ directory exists
  ✅ config.json is valid JSON
  ✅ state.json exists
  ✅ project.issuePrefix is set (AF)
  ✅ memory/issues/_index.md exists

═══ Configuration ═══
  ✅ project.name: arcflux
  ⚠️  services.github.org: (empty)
  ⚠️  services.linear.workspace: (empty)

═══ Memory Bank ═══
  ✅ architecture.md: 2,450 chars
  ✅ roadmap.md: 890 chars
  ⚠️  stacks/: 0 files (expected based on stack config)

═══ Services ═══
  ⚠️  GitHub: configured but credentials not verified
  ⚪ Linear: disabled
  ⚪ Lagoon: disabled

═══ Statistics ═══
  ℹ️  Total issues: 44
  ℹ️  Completed: 5 (11%)
  ℹ️  Last activity: 2 hours ago
  ℹ️  Token usage today: 45,000

──────────────────────────────────────
Result: ✅ PASS (3 warnings)

Warnings don't block operations but should be addressed.
Run /arcflux:preflight --fix to auto-fix where possible.
```

### Specific Checks

```
/arcflux:preflight --check=config
/arcflux:preflight --check=memory
/arcflux:preflight --check=services
```

### Strict Mode

```
/arcflux:preflight --strict

Result: ❌ FAIL (3 warnings treated as errors)
```

### Auto-Fix Mode

```
/arcflux:preflight --fix

Fixing issues...
  ✅ Created memory/stacks/drupal.md (from template)
  ✅ Created memory/stacks/typescript.md (from template)
  ⚠️  Cannot auto-fix: services.github.org (requires user input)

Run /arcflux:preflight again to verify.
```

### JSON Output

```
/arcflux:preflight --json
```

```json
{
  "status": "pass",
  "timestamp": "2026-01-09T14:00:00Z",
  "critical": {
    "passed": 5,
    "failed": 0,
    "checks": [...]
  },
  "warnings": {
    "count": 3,
    "items": [
      {"check": "github.org", "message": "Not configured"},
      {"check": "linear.workspace", "message": "Not configured"},
      {"check": "stacks/", "message": "No files found"}
    ]
  },
  "info": {
    "totalIssues": 44,
    "completedIssues": 5,
    "lastActivity": "2026-01-09T12:00:00Z"
  }
}
```

## Session Start Integration

Preflight runs automatically on session start (if `preflightOnStart` setting is true):

- Critical failures: Block with instructions
- Warnings: Show count, suggest `/arcflux:preflight`
- All pass: Show brief status

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 1 | Warnings present (pass in non-strict) |
| 2 | Critical failures |
