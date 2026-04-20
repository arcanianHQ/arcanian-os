---
scope: shared
---

# ArcFlux Crash Recovery Guide

How to recover your session after an interruption (internet issue, computer crash, session timeout, etc.)

## TL;DR - Quick Recovery

After a crash, tell Claude:

```
Read arcflux/CLAUDE.md and run `arcflux context` to restore session state.
```

Or just:

```
Run `node bin/arcflux.js context` in the arcflux folder
```

---

## Before a Crash (Prevention)

ArcFlux is designed to be crash-resilient by default:

### What's Automatically Saved

| Data | Location | When Saved |
|------|----------|------------|
| Active issue | `.arcflux/state.json` | On `arcflux start` |
| Current phase | `.arcflux/state.json` | On `arcflux phase` |
| Issue details | `.arcflux/memory/issues/AF-XXX.md` | On issue update |
| All code | Git working tree | On `arcflux commit` |
| Architecture decisions | `.arcflux/memory/architecture.md` | Manual |
| Roadmap | `.arcflux/memory/roadmap.md` | Manual |

### Best Practices During Development

1. **Commit frequently** - Use `arcflux commit` or set `commitFrequency: "feature"`
2. **Update issue files** - Add notes and discoveries to `.arcflux/memory/issues/AF-XXX.md`
3. **Push regularly** - Sync with remote to protect against local disk failure

### State That Survives

```
✅ All .arcflux/ files (git tracked)
✅ All source code (git tracked)
✅ Git history
✅ Uncommitted changes (in working tree)
```

### State That May Be Lost

```
⚠️ Conversation context (Claude session)
⚠️ Uncommitted changes (if disk failure)
⚠️ In-memory Claude state
```

---

## After a Crash (Recovery)

### Step 1: Start New Claude Session

Open Claude Code in the project directory.

### Step 2: Load Context

**Option A: Use the context command (recommended)**

```bash
cd /path/to/arcflux
node bin/arcflux.js context
```

This outputs:
- Current state (active issue, phase)
- Active issue details
- Git status
- Roadmap summary
- Issue index
- Configuration
- Suggested next steps

**Option B: Tell Claude to read CLAUDE.md**

Say to Claude:
> "Read the CLAUDE.md file and check .arcflux/state.json to see what we were working on."

**Option C: Manual file reads**

Ask Claude to read in order:
1. `CLAUDE.md` - Bootstrap instructions
2. `.arcflux/state.json` - Current state
3. `.arcflux/memory/issues/_index.md` - All issues
4. `.arcflux/memory/issues/AF-XXX.md` - Active issue (if any)

### Step 3: Resume Work

Based on the context loaded, continue where you left off:

```
# If there was an active issue:
"Continue working on AF-007"

# If no active issue:
"Start the next TODO issue from the index"

# If unsure:
"Check the roadmap and suggest what to work on next"
```

---

## Context Command Reference

### Full Context Dump

```bash
arcflux context
```

Outputs human-readable summary of:
- Current state
- Active issue details
- Git status (branch, changes, recent commits)
- Roadmap focus
- Issue status table
- Configuration
- Next steps

### Compact/JSON Mode

```bash
arcflux context --compact
```

Outputs minimal JSON for programmatic use:
```json
{
  "activeIssue": { "key": "AF-007", "title": "..." },
  "currentPhase": "implement",
  "config": { "phases": [...], "tdd": false },
  "activeIssueContent": "# AF-007: Start Command\n..."
}
```

---

## Recovery Scenarios

### Scenario 1: Internet Disconnect

**Symptoms:** Claude session ended mid-conversation

**Recovery:**
1. Reconnect to internet
2. Start new Claude session
3. Run `arcflux context`
4. Continue work

**Data status:** All local files intact

### Scenario 2: Computer Crash/Restart

**Symptoms:** Unexpected shutdown

**Recovery:**
1. Start computer
2. Open Claude Code
3. Run `arcflux context`
4. Check for uncommitted changes: `git status`
5. Continue work

**Data status:** Local files intact, check for unsaved editor buffers

### Scenario 3: Claude Session Timeout

**Symptoms:** Session expired, "conversation too long"

**Recovery:**
1. Start new Claude session
2. Say: "Read CLAUDE.md and run arcflux context"
3. Summarize what you were doing if needed
4. Continue work

**Data status:** All files intact, only conversation context lost

### Scenario 4: Disk Failure

**Symptoms:** Local files corrupted/lost

**Recovery:**
1. Clone from remote: `git clone <repo-url>`
2. Uncommitted changes are lost
3. Run `arcflux context` to see last known state
4. Restart from last commit

**Data status:** Only pushed commits survive

---

## File Map for Manual Recovery

If commands don't work, these files contain all state:

```
arcflux/
├── CLAUDE.md                              # Bootstrap instructions
├── .arcflux/
│   ├── state.json                         # Active issue, phase
│   ├── config.json                        # Project settings
│   └── memory/
│       ├── architecture.md                # Design decisions
│       ├── roadmap.md                     # Priorities & milestones
│       └── issues/
│           ├── _index.md                  # Issue list & status
│           └── AF-XXX.md                  # Individual issue details
└── src/                                   # Source code
```

---

## Prevention Checklist

Before ending a session:

- [ ] Commit any pending changes
- [ ] Update issue file with progress notes
- [ ] Push to remote (if available)
- [ ] Note in issue file where you left off

ArcFlux will eventually automate most of this, but for now these manual steps help ensure smooth recovery.
