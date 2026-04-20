---
scope: shared
---

# ArcFlux Initial Testing Guide

This document describes what's ready for testing and how to run your first test.

---

## Current Implementation Status

### Commands Ready (6 total)

| Command | Status | Description |
|---------|--------|-------------|
| `arcflux init` | ✅ Ready | Interactive project initialization |
| `arcflux start <issue>` | ✅ Ready | Start work on an issue |
| `arcflux phase [action]` | ✅ Ready | Manage workflow phases |
| `arcflux status` | ✅ Ready | Show current state |
| `arcflux doctor` | ✅ Ready | Environment diagnostics |
| `arcflux context` | ✅ Ready | Dump context for recovery |

### Commands Not Yet Implemented

| Command | Status | Notes |
|---------|--------|-------|
| `arcflux validate` | ⏳ Pending | Multi-agent validation (can skip for initial test) |
| `arcflux commit` | ⏳ Pending | Use `git commit` directly |
| `arcflux batch` | ⏳ Pending | Sequential issue processing |

---

## Prerequisites

Before testing, ensure:

```bash
# 1. Navigate to arcflux directory
cd /path/to/arcflux

# 2. Install dependencies
npm install

# 3. Verify CLI works
node bin/arcflux.js --help
```

---

## Test 1: Initialize New Project

```bash
# Create test directory
mkdir /tmp/arcflux-test
cd /tmp/arcflux-test

# Run init (interactive)
node /path/to/arcflux/bin/arcflux.js init
```

**Expected prompts:**
- Project name (defaults to folder name)
- Issue prefix (e.g., TEST)
- Project type
- Description
- Technology stacks
- GitHub integration (yes/no)
- Linear integration (yes/no)
- Initialize git (yes/no)

**Expected result:**
```
.arcflux/
├── config.json
├── state.json
└── memory/
    ├── architecture.md
    ├── captains-log.md
    ├── environment.md
    ├── SETUP.md
    └── issues/
        └── _index.md

CLAUDE.md (in project root)
```

---

## Test 2: Start an Issue

```bash
# Option A: Create issue file first, then start
# Create .arcflux/memory/issues/TEST-001.md manually

# Option B: Use --create flag
node /path/to/arcflux/bin/arcflux.js start TEST-001 --create --title "My first test issue"
```

**Expected result:**
- Issue file created (if using --create)
- Branch created: `feature/test-001-my-first-test-issue`
- State updated with activeIssue
- Phase set to "explore"

---

## Test 3: Workflow Phases

```bash
# Check current phase
node /path/to/arcflux/bin/arcflux.js phase

# Advance to next phase
node /path/to/arcflux/bin/arcflux.js phase next

# Skip a phase (with reason)
node /path/to/arcflux/bin/arcflux.js phase skip --reason "Simple change"

# Go back
node /path/to/arcflux/bin/arcflux.js phase back

# Jump to specific phase
node /path/to/arcflux/bin/arcflux.js phase set --to implement

# Complete the issue
node /path/to/arcflux/bin/arcflux.js phase complete
```

**Expected workflow:**
```
explore → plan → architect → implement → review → test → document → complete
```

---

## Test 4: Status Checking

```bash
# Human-readable status
node /path/to/arcflux/bin/arcflux.js status

# JSON output
node /path/to/arcflux/bin/arcflux.js status --json
```

**Expected output:**
- Git branch info
- Active issue details
- Current phase with progress indicator
- Quality settings
- Integration status

---

## Test 5: Full Workflow (End-to-End)

Complete workflow test:

```bash
# 1. Initialize
cd /tmp && rm -rf workflow-test && mkdir workflow-test && cd workflow-test
node /path/to/arcflux/bin/arcflux.js init
# Answer prompts...

# 2. Start issue
node /path/to/arcflux/bin/arcflux.js start TEST-001 --create --title "Test feature"

# 3. Check status
node /path/to/arcflux/bin/arcflux.js status

# 4. Simulate work through phases
node /path/to/arcflux/bin/arcflux.js phase next --yes  # explore → plan
node /path/to/arcflux/bin/arcflux.js phase skip --yes --reason "Simple"  # plan → architect
node /path/to/arcflux/bin/arcflux.js phase skip --yes --reason "Simple"  # architect → implement
# Do some actual work here...
node /path/to/arcflux/bin/arcflux.js phase next --yes  # implement → review
node /path/to/arcflux/bin/arcflux.js phase next --yes  # review → test
node /path/to/arcflux/bin/arcflux.js phase next --yes  # test → document

# 5. Complete
node /path/to/arcflux/bin/arcflux.js phase complete --yes

# 6. Verify completed
node /path/to/arcflux/bin/arcflux.js status
# Should show: No active issue
```

---

## What's Missing for Full Testing

### Not Critical (can test without)

1. **Validate command** - Multi-agent validation
   - Workaround: Skip review phase or manually review

2. **Commit command** - Auto-commit with context
   - Workaround: Use `git commit` directly

3. **Hooks** - Session start, pre/post tool-use
   - These are for Claude Code plugin integration, not CLI testing

### Nice to Have

1. **Batch command** - Sequential issue processing
2. **Linear integration** - Issue sync with Linear
3. **GitHub integration** - PR creation

---

## Troubleshooting

### "Not an ArcFlux project"
```bash
# Run init first
node /path/to/arcflux/bin/arcflux.js init
```

### "Issue not found"
```bash
# Use --create flag
node /path/to/arcflux/bin/arcflux.js start TEST-001 --create --title "Title"
```

### "Already working on another issue"
```bash
# Use --force to switch
node /path/to/arcflux/bin/arcflux.js start TEST-002 --force
```

### Git branch issues
```bash
# Skip branch creation
node /path/to/arcflux/bin/arcflux.js start TEST-001 --no-branch
```

---

## Success Criteria

Initial testing is successful if you can:

- [ ] Initialize a new project
- [ ] Start work on an issue
- [ ] Move through workflow phases
- [ ] Complete an issue
- [ ] Check status at any point
- [ ] Start a new issue after completing one

---

*Last updated: 2026-01-09*
