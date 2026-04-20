---
scope: shared
---

# ArcFlux Architecture

## Overview

ArcFlux is an AI-native development workflow system that combines issue-driven development with structured methodology.

## Core Principles

### 1. CLI Delegation (not API wrapping)
- Use native CLIs (`gh`, `linearis`, `supabase`, `flyctl`)
- Wrap with error handling, not reimplementation
- Benefits: smaller codebase, full features, less maintenance

### 2. Hook-Based Integration
- Non-invasive Claude Code hooks
- Each hook = standalone CLI command
- Exit codes control flow (0=proceed, 2=block)

### 3. Phased Development
- Every issue progresses through phases
- Phases: research → spec → design → implement → complete
- Optional but encouraged

### 4. Quality First
- Enforced standards before merge
- Configurable thresholds
- Security scanning built-in

### 5. Memory Persistence
- Project context survives sessions
- Architecture decisions recorded
- Issue-specific notes preserved

## Directory Structure

```
project/
├── .arcflux/
│   ├── config.json          # Project configuration
│   ├── state.json           # Current state (active issue, phase)
│   └── memory/              # Persistent context
│       ├── architecture.md  # System design
│       ├── roadmap.md       # Priorities
│       └── issues/          # Per-issue context
│           ├── _index.md    # Issue registry
│           └── XXX-001.md   # Individual issues
```

## Component Architecture

```
bin/arcflux.js              # CLI entry (commander)
       │
       ▼
src/commands/*.js           # Command handlers
       │
       ├──► src/cli/*.js    # Native CLI wrappers
       │
       ├──► src/utils/*.js  # Shared utilities
       │
       └──► src/checks/*.js # Quality gates
```

## State Management

### Project State (`.arcflux/state.json`)
- Active issue (key, title, branch, url)
- Current phase
- Integration links (github, linear)

### Global State (`~/.arcflux/state.json`)
- Recent projects
- User preferences

## Hook Flow

```
user-prompt-submit
       │
       ▼
  check-issue ──► Ensure active issue
       │
       ▼
pre-tool-use
       │
       ▼
  validate ──► Block if no issue/wrong phase
       │
       ▼
[Claude writes code]
       │
       ▼
post-tool-use
       │
       ▼
  auto-commit ──► Conventional commit
```

## Dependency Management

### Runtime Dependency Checking

When starting an issue, ArcFlux checks if dependencies are complete:

```
arcflux start AF-015
    ↓
Parse issue file → Extract "Depends on:"
    ↓
Check status of each dependency
    ↓
├── All ✅ COMPLETE → Proceed
└── Any not complete → Block
        ↓
    Show blockers + suggest available issues
```

### Dependency Format

In issue files:
```markdown
## Related
- Depends on: AF-007, AF-014
- Blocks: AF-015, AF-020
```

### Available Issues

An issue is "available" when:
1. Status is TODO (not complete, not in progress)
2. All dependencies are COMPLETE
3. Not blocked by external factors

### Commands

```bash
arcflux deps <issue>      # Show dependency tree
arcflux deps --available  # List issues ready to start
arcflux start <issue>     # Checks deps, blocks if not met
arcflux start <issue> --force  # Override dependency check
```

---

## Decisions Log

### 2025-01-09: Project Structure
- Decision: Use flat file structure for issues (not database)
- Reason: Git-friendly, simple, no dependencies
- Trade-off: No advanced querying, but grep works fine

### 2025-01-09: Phase System
- Decision: Phases optional by default
- Reason: Don't slow down simple tasks
- Trade-off: Less structure, but more flexibility

### 2025-01-09: Dependency Blocking
- Decision: Hard block by default, `--force` to override
- Reason: Prevent working on issues that can't be completed
- Trade-off: May feel restrictive, but prevents wasted effort
