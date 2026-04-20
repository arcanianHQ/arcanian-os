---
name: orchestrate
description: Display full project dashboard with status, metrics, and next steps
arguments: []
scope: shared
---

# ArcFlux Orchestrate Command

## Purpose
Display comprehensive project dashboard showing all issue statuses, quality checks, metrics, and recommended next steps.

## Output

```
/arcflux:orchestrate

╔════════════════════════════════════════════════════════════════╗
║                    ArcFlux Orchestrator                         ║
╚════════════════════════════════════════════════════════════════╝

Project:  arcflux
Branch:   feat/af-007-start-command
Prefix:   AF

═══════════════════════════════════════════════════════════════════
                          ISSUE STATUS
═══════════════════════════════════════════════════════════════════

Phase 1: Foundation
  ✅ AF-001: CLI entry point
  ✅ AF-002: State management
  ✅ AF-003: Doctor command
  ✅ AF-004: Status command
  ✅ AF-019: Context command

Phase 2: Core Workflow
  🔄 AF-007: Start command (Phase: Implement, 45m)
  ⚪ AF-009: Validate command
  ⚪ AF-010: Commit command
  ⚪ AF-013: GitHub CLI wrapper
  ⚪ AF-014: Linear CLI wrapper

Phase 3: Integration
  🚫 AF-015: Claude Code hooks (blocked by: AF-009, AF-010)
  ⚪ AF-020: Check-issue command

═══════════════════════════════════════════════════════════════════
                         QUALITY CHECKS
═══════════════════════════════════════════════════════════════════

Code Quality:
  ✅ No console.log statements
  ⚠️  Found 3 TODO comments
  ✅ All imports resolve
  ✅ No hardcoded secrets

Memory Bank:
  ✅ architecture.md: documented
  ✅ roadmap.md: updated
  ⚠️  captains-log.md: needs entry for today

═══════════════════════════════════════════════════════════════════
                           METRICS
═══════════════════════════════════════════════════════════════════

Progress:
  ████████░░░░░░░░░░░░░░░░░░░░░░  11% (5/44 issues)

Today's Session:
  Issues worked:    1 (AF-007)
  Time in session:  2h 15m
  Tokens used:      67,450
  Estimated cost:   $1.01

This Week:
  Issues completed: 3
  Total tokens:     245,000
  Total cost:       $3.68

═══════════════════════════════════════════════════════════════════
                          NEXT STEPS
═══════════════════════════════════════════════════════════════════

1. Complete AF-007 (currently in progress)
   → Phase: Implement → Review
   → Run: /arcflux:phase review

2. Parallel opportunities (no blockers):
   → AF-013: GitHub CLI wrapper
   → AF-014: Linear CLI wrapper

3. After AF-007 completes:
   → AF-009: Validate command (unblocked)
   → AF-020: Check-issue command (unblocked)

═══════════════════════════════════════════════════════════════════
                         BLOCKED ISSUES
═══════════════════════════════════════════════════════════════════

AF-015: Claude Code hooks
  Waiting for:
    ⚪ AF-009: Validate command
    ⚪ AF-010: Commit command
    ⚪ AF-020: Check-issue command

═══════════════════════════════════════════════════════════════════

Quick Actions:
  /arcflux:start AF-013     Start GitHub CLI wrapper (parallel)
  /arcflux:phase review     Move current issue to review
  /arcflux:validate         Run validation on current work
  /arcflux:status           Quick status check

───────────────────────────────────────────────────────────────────
Last updated: 2026-01-09 14:30:00 | Run /arcflux:orchestrate to refresh
```

## Data Sources

| Section | Source |
|---------|--------|
| Issue Status | `memory/issues/_index.md`, `memory/issues/*.md` |
| Quality Checks | Real-time code scan |
| Metrics | `execution/_ledger.json`, `state.json` |
| Next Steps | Dependency analysis |
| Blocked Issues | Dependency graph analysis |

## Refresh

Dashboard data is generated on-demand. Run command again to refresh.
