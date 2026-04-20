---
name: issue
description: Create, view, or manage issues
arguments:
  - name: action
    description: Action to perform (create, view, list, complete)
    required: true
  - name: id
    description: Issue ID for view/complete actions
    required: false
  - name: title
    description: Issue title for create action
    required: false
scope: shared
---

# ArcFlux Issue Command

## Purpose
Create, view, and manage issues in the ArcFlux memory bank.

## Actions

### Create Issue

```
/arcflux:issue create "Implement user authentication"

📝 Creating new issue...

? Priority:
  ❯ P0 - Critical Path
    P1 - Core Functionality
    P2 - Enhanced Features
    P3 - Future/Optional

? Dependencies (comma-separated issue IDs, or none):
  AF-007, AF-010

? Key files (comma-separated paths, or none):
  src/auth/login.js, src/middleware/auth.js

Creating AF-045: Implement user authentication

✅ Created: .arcflux/memory/issues/AF-045.md
✅ Updated: .arcflux/memory/issues/_index.md

Next: /arcflux:start AF-045 to begin work
```

### View Issue

```
/arcflux:issue view AF-007

═══════════════════════════════════════════════════════════
  AF-007: Start Command
═══════════════════════════════════════════════════════════

Status:   🔄 IN_PROGRESS
Phase:    4. Implement
Priority: P0
Started:  2 hours ago

## Intent
**What:** Implement start command to begin work on issues
**Why:** Enable issue-driven workflow with proper state tracking

## Context
**Dependencies:**
  ✅ AF-002: State management (COMPLETE)
  ⚪ AF-014: Linear CLI wrapper (TODO)

**Key Files:**
  - src/utils/state.js
  - bin/arcflux.js

## Action
  1. ✅ Create src/commands/start.js
  2. ✅ Register command in bin/arcflux.js
  3. 🔄 Implement dependency checking
  4. ⚪ Update state on start
  5. ⚪ Write tests

## Progress
  Commits: 2
  Files modified: 3
  Time spent: 2h 15m

───────────────────────────────────────────────────────────
Actions:
  /arcflux:phase review     Move to review phase
  /arcflux:issue complete   Mark as complete
```

### List Issues

```
/arcflux:issue list

═══ All Issues ═══

P0 - Critical Path:
  ✅ AF-001  CLI entry point
  ✅ AF-002  State management
  🔄 AF-007  Start command
  ⚪ AF-015  Claude Code hooks

P1 - Core Functionality:
  ✅ AF-003  Doctor command
  ⚪ AF-009  Validate command
  ⚪ AF-013  GitHub CLI wrapper

Total: 44 | Complete: 5 | In Progress: 1 | Todo: 38
```

### Complete Issue

```
/arcflux:issue complete AF-007

Completing AF-007: Start Command

Checklist:
  ✅ All action items done
  ✅ Validation passed
  ✅ Commits made
  ⚠️  Tests not verified

? Mark as complete anyway? (y/N)

✅ AF-007 marked as COMPLETE

Updated:
  - .arcflux/memory/issues/AF-007.md (status → COMPLETE)
  - .arcflux/memory/issues/_index.md
  - .arcflux/state.json (cleared activeIssue)

Now unblocked:
  - AF-009: Validate command
  - AF-020: Check-issue command
```

## Issue File Format

Created issues use ICAO structure:

```markdown
# AF-045: Implement user authentication

## Status: TODO

## Phase: -

## Priority: P1

## Intent
**What:** [Auto-filled from title]
**Why:** [User provides]

## Context
**Dependencies:**
- AF-007: Start command

**Key Files:**
- src/auth/login.js
- src/middleware/auth.js

## Action
1. [Step 1]
2. [Step 2]

## Output
**Verification:**
- [ ] [Verification item]

**Artifacts:**
- [Expected files]

## Related
- Depends on: AF-007
```

## Auto-Numbering

Issue IDs are auto-generated:
1. Read `_index.md` for highest existing ID
2. Increment by 1
3. Use configured prefix (e.g., AF-046)
