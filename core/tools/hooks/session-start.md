---
name: session-start
description: Initializes ArcFlux context when a Claude Code session begins
trigger: on_session_start
scope: shared
---

# Session Start Hook

## Purpose
Load ArcFlux context, validate memory bank, and run preflight checks when a new Claude Code session begins.

## Trigger
Automatically runs when:
- User starts a new Claude Code session in a project with ArcFlux configured
- Session is restored after context compaction

## Behavior

### 1. Detect ArcFlux Project

```bash
# Check for ArcFlux configuration
if [ -f ".arcflux/config.json" ]; then
  echo "ArcFlux project detected"
else
  # Not an ArcFlux project - exit silently
  exit 0
fi
```

### 2. Load Current State

```bash
# Read state.json
STATE=$(cat .arcflux/state.json 2>/dev/null || echo '{}')

# Extract active issue and phase
ACTIVE_ISSUE=$(echo "$STATE" | jq -r '.activeIssue // "none"')
CURRENT_PHASE=$(echo "$STATE" | jq -r '.currentPhase // "none"')

echo "═══ ArcFlux Session Start ═══"
echo ""
echo "Active Issue: $ACTIVE_ISSUE"
echo "Current Phase: $CURRENT_PHASE"
```

### 3. Run Preflight Checks

Invoke `/arcflux:preflight` with `--session-start` flag:

```
Running preflight checks...

Critical:
  ✅ config.json exists
  ✅ state.json readable
  ✅ Memory bank accessible

Warnings:
  ⚠️ No active issue - run /arcflux:start to begin work

Info:
  ℹ️ Last session: 2024-01-15 14:30
  ℹ️ Issues in progress: 2
```

### 4. Display Context Summary

```
═══ Session Context ═══

📋 Active: AF-043 - Claude Code Plugin Architecture
   Phase: Implement
   Started: 2024-01-15

📁 Memory Bank:
   • 12 issues tracked
   • 3 stack guides loaded
   • Captain's log: 5 entries

💡 Quick Commands:
   /arcflux:status  - View current state
   /arcflux:phase   - Move to next phase
   /arcflux:commit  - Commit with context
```

### 5. Load Issue Context

If active issue exists:

```bash
ISSUE_FILE=".arcflux/memory/issues/${ACTIVE_ISSUE}.md"
if [ -f "$ISSUE_FILE" ]; then
  echo ""
  echo "Loading issue context..."
  # Issue details will be available in conversation
fi
```

## Output

The hook outputs a formatted summary that Claude will use to understand the current project context without requiring the user to manually load files.

## Error Handling

| Error | Action |
|-------|--------|
| config.json missing | Show init instructions |
| state.json corrupt | Offer to reset state |
| Memory bank empty | Suggest onboarding |
| Active issue file missing | Clear activeIssue from state |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success - session ready |
| 0 | Not ArcFlux project - silent pass |

Note: Session start should never block. Warnings are displayed but don't prevent work.

## Integration

- Works with vendored hookify plugin
- Respects `settings.autoLoadContext` configuration
- Can be disabled via `settings.hooks.sessionStart: false`
