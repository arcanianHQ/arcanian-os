---
name: context
description: Dump full project context for session recovery
arguments:
  - name: compact
    description: Output minimal JSON for programmatic use
    required: false
scope: shared
---

# ArcFlux Context Command

## Purpose
Dump complete project context for session recovery after crashes, context switches, or new sessions.

## When to Use

- After a session crash or disconnect
- When resuming work after a break
- When switching between projects
- When a new Claude session starts

## Output

```
/arcflux:context

╔════════════════════════════════════════════════════════════════╗
║                 ArcFlux Context Recovery                        ║
╚════════════════════════════════════════════════════════════════╝

═══ Project ═══
Name:     arcflux
Prefix:   AF
Type:     node-cli
Branch:   feat/af-007-start-command

═══ Current State ═══
Active Issue: AF-007 - Start Command
Phase:        4. Implement (45 min)
Last Action:  Added dependency checking logic

═══ Recent Activity ═══
• 14:30 - Commit: "feat(AF-007): add dependency checking"
• 14:15 - Created src/utils/dependencies.js
• 14:00 - Started phase "Implement"
• 13:45 - Completed phase "Architect"

═══ Files Modified This Session ═══
  M src/commands/start.js (45 lines added)
  M bin/arcflux.js (3 lines added)
  A src/utils/dependencies.js (new file)

═══ Active Issue Context ═══

## Intent
Implement start command to begin work on issues with dependency checking.

## Current Action Items
  1. ✅ Create src/commands/start.js
  2. ✅ Register command in bin/arcflux.js
  3. 🔄 Implement dependency checking
  4. ⚪ Update state on start
  5. ⚪ Write tests

## Key Files
  - src/commands/start.js (primary)
  - src/utils/state.js (dependency)
  - src/utils/dependencies.js (new)

═══ Roadmap Context ═══
Current Phase: Phase 2 - Core Workflow
Next Priority: Complete AF-007, then AF-009 or AF-013

═══ Resume Instructions ═══
1. You are implementing AF-007: Start Command
2. Current task: Finish dependency checking logic
3. Next: Update state.json when issue starts
4. Then: Write tests for the command

To continue: Review src/commands/start.js and implement remaining items.

───────────────────────────────────────────────────────────────────
Context dumped at 2026-01-09T14:35:00Z
```

## Compact Mode

```
/arcflux:context --compact
```

```json
{
  "project": {
    "name": "arcflux",
    "prefix": "AF",
    "branch": "feat/af-007-start-command"
  },
  "state": {
    "activeIssue": "AF-007",
    "currentPhase": "implement",
    "phaseStarted": "2026-01-09T14:00:00Z"
  },
  "issue": {
    "id": "AF-007",
    "title": "Start Command",
    "status": "IN_PROGRESS",
    "actionItems": [
      {"item": "Create src/commands/start.js", "done": true},
      {"item": "Register command in bin/arcflux.js", "done": true},
      {"item": "Implement dependency checking", "done": false},
      {"item": "Update state on start", "done": false},
      {"item": "Write tests", "done": false}
    ]
  },
  "files": {
    "modified": ["src/commands/start.js", "bin/arcflux.js"],
    "added": ["src/utils/dependencies.js"]
  },
  "resume": "Continue implementing dependency checking in src/commands/start.js"
}
```

## Data Sources

| Section | Source |
|---------|--------|
| Project | `.arcflux/config.json` |
| State | `.arcflux/state.json` |
| Activity | `.arcflux/execution/AF-007/_current.json` |
| Issue | `.arcflux/memory/issues/AF-007.md` |
| Roadmap | `.arcflux/memory/roadmap.md` |
| Files | Git status |

## Session Start Integration

The session-start hook runs `/arcflux:context --compact` internally to load context for Claude.
