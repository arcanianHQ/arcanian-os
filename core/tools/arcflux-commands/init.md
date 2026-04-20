---
name: init
description: Initialize ArcFlux in current project with full scaffolding
usage: /arcflux:init
mode: hybrid
cli_command: arcflux init
scope: shared
---

# /arcflux:init

Initialize a new ArcFlux project with interactive setup.

## Mode: Hybrid (CLI + Claude)

This command uses the **hybrid approach**:
1. Claude runs the `arcflux init` CLI command
2. CLI handles interactive prompts and file creation
3. Claude provides guidance before/after

## Prerequisites Check

Before running, verify CLI is installed:

```bash
arcflux --version
```

If not installed, guide user:

```
ArcFlux CLI not found.

To install:
1. Get the arcflux source folder
2. cd /path/to/arcflux
3. npm install
4. npm link
5. Verify: arcflux --version

Then run /arcflux:init again.
```

## Execution

Run the CLI command:

```bash
arcflux init
```

The CLI will interactively prompt for:
- Project name
- Issue prefix (e.g., AF, PROJ)
- Project type
- Description
- Technology stacks
- GitHub integration
- Linear integration
- Git initialization

## Created Structure

After successful init:

```
project/
├── .arcflux/
│   ├── config.json          # Project configuration
│   ├── state.json           # Current state
│   └── memory/
│       ├── architecture.md  # System design
│       ├── captains-log.md  # Decision journal
│       ├── environment.md   # Config documentation
│       ├── SETUP.md         # Setup instructions
│       └── issues/
│           └── _index.md    # Issue index
└── CLAUDE.md                # Bootstrap file
```

## After Initialization

Tell the user:

```
Project initialized! Next steps:

1. Read CLAUDE.md for project overview
2. Create first issue:
   /arcflux:start PREFIX-001 --create --title "First task"
3. Or check status:
   /arcflux:status
```

## Error Handling

**Already initialized:**
- CLI will ask about reinitializing
- Let user decide

**CLI not found:**
- Show installation instructions above

**Permission errors:**
- Suggest checking directory permissions
