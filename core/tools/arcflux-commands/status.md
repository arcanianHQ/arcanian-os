---
name: status
description: Show current ArcFlux project status
usage: /arcflux:status [--json]
mode: hybrid
cli_command: arcflux status
arguments:
  - name: json
    description: Output in JSON format
    required: false
scope: shared
---

# /arcflux:status

Display current project status including active issue and phase.

## Mode: Hybrid (CLI + Claude)

This command uses the **hybrid approach**:
1. Claude runs the `arcflux status` CLI command
2. CLI reads state and displays information
3. Claude can provide additional context

## Prerequisites Check

Verify:
1. CLI installed: `arcflux --version`
2. In an ArcFlux project directory

## Execution

Run the CLI command:

```bash
arcflux status [options]
```

### Options

| Option | Description |
|--------|-------------|
| `--json` | Output as JSON |

## What It Shows

1. **Git Status** - Branch, changed files
2. **Active Issue** - Key, title, branch
3. **Current Phase** - Progress through workflow
4. **Quality Settings** - Thresholds
5. **Integrations** - GitHub, Linear status

## Sample Output

```
═══ ArcFlux Status ═══

Git
────────────────────────────────────────
Branch: feature/af-007-start-command
Changes: 3 file(s)

Active Issue
────────────────────────────────────────
Key: AF-007
Title: Start Command
Branch: feature/af-007-start-command

Development Phase
────────────────────────────────────────
✓explore → ✓plan → [implement] → review → test → document

Quality Gates
────────────────────────────────────────
Max file lines: 500
Test coverage: 80%

Integrations
────────────────────────────────────────
github: ✓
linear: ✓
```

## After Status Display

If no active issue:
- Suggest: `/arcflux:start <issue>` to begin work

If issue active:
- Remind current phase
- Suggest next action based on phase

## Error Handling

**Not an ArcFlux project:**
```
Not initialized. Run /arcflux:init first.
```

**CLI not found:**
```
Install ArcFlux CLI first. See SETUP.md.
```
