---
scope: shared
---

# Issue Format Guide

ArcFlux uses markdown files to track issues. Each issue lives in `.arcflux/memory/issues/` with the filename `{PREFIX}-{NUMBER}.md`.

## Issue Template

```markdown
# {PREFIX}-{NUMBER}: {Title}

## Overview

| Field | Value |
|-------|-------|
| ID | {PREFIX}-{NUMBER} |
| Status | {Status} |
| Priority | {Priority} |
| Created | {Date} |
| Phase | {Phase} |
| Dependencies | {Dependencies} |

## Description

{Clear description of what needs to be done and why}

## Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Implementation

{Technical details, file locations, code snippets}

## Progress Log

### Phase: {Current Phase}

Started: {Date}

- {Progress item 1}
- {Progress item 2}

---

*Created: {Date}*
```

## Field Definitions

### Status

| Status | Emoji | Meaning |
|--------|-------|---------|
| BACKLOG | 📋 | Not started, in queue |
| TODO | ⚪ | Ready to start |
| IN_PROGRESS | 🔄 | Currently being worked on |
| BLOCKED | 🚫 | Waiting on dependency |
| REVIEW | 👀 | Ready for review |
| COMPLETE | ✅ | Done and verified |

### Priority

| Priority | Meaning |
|----------|---------|
| P0 | Critical path - must be done first |
| P1 | Core functionality - required for MVP |
| P2 | Enhanced workflow - nice to have |
| P3 | Optional/future - can defer |

### Phase

The 7-phase workflow:

| Phase | What happens |
|-------|--------------|
| explore | Research, understand requirements |
| plan | Break down into tasks |
| architect | Design the solution |
| implement | Write the code |
| review | Review changes, run validation |
| test | Run tests, add coverage |
| document | Update docs |
| complete | Done |

### Dependencies

Reference other issues that must be completed first:

```
| Dependencies | AF-001, AF-002 |
```

Or none:

```
| Dependencies | - |
```

## Examples

### Simple Bug Fix

```markdown
# AF-099: Fix login button not responding

## Overview

| Field | Value |
|-------|-------|
| ID | AF-099 |
| Status | ⚪ TODO |
| Priority | P1 |
| Created | 2026-01-10 |
| Phase | - |
| Dependencies | - |

## Description

The login button on the home page doesn't respond to clicks on mobile devices.

## Requirements

- [ ] Investigate touch event handling
- [ ] Fix button responsiveness on iOS/Android
- [ ] Test on multiple devices

## Acceptance Criteria

- [ ] Login button works on iOS Safari
- [ ] Login button works on Android Chrome
- [ ] No regression on desktop browsers
```

### Feature with Dependencies

```markdown
# AF-100: Add user dashboard

## Overview

| Field | Value |
|-------|-------|
| ID | AF-100 |
| Status | 🚫 BLOCKED |
| Priority | P1 |
| Created | 2026-01-10 |
| Phase | - |
| Dependencies | AF-098, AF-099 |

## Description

Create a personalized dashboard showing user activity, recent items, and quick actions.

## Requirements

- [ ] Design dashboard layout
- [ ] Implement activity feed component
- [ ] Add recent items widget
- [ ] Create quick action buttons
- [ ] Add user preferences integration

## Acceptance Criteria

- [ ] Dashboard loads in < 2 seconds
- [ ] Activity feed shows last 10 items
- [ ] Quick actions are customizable
- [ ] Responsive on all screen sizes
```

### Testing/Validation Issue

```markdown
# AF-101: E2E Testing Suite

## Overview

| Field | Value |
|-------|-------|
| ID | AF-101 |
| Status | 🔄 IN_PROGRESS |
| Priority | P2 |
| Created | 2026-01-10 |
| Phase | implement |
| Dependencies | - |

## Description

Create comprehensive end-to-end test suite covering critical user journeys.

## Test Checklist

| # | Test | Status | Notes |
|---|------|--------|-------|
| 1 | User registration | 🧪 Pass | Tested 2026-01-10 |
| 2 | User login | 🧪 Pass | Tested 2026-01-10 |
| 3 | Password reset | ⚪ | |
| 4 | Profile update | ⚪ | |

## Progress Log

### Phase: Implement

Started: 2026-01-10

- Set up Playwright test framework
- Added registration and login tests
- Fixed flaky selector issues

---

*Created: 2026-01-10*
```

## Best Practices

1. **Clear titles**: Use action verbs - "Add", "Fix", "Update", "Remove"
2. **Atomic issues**: One concern per issue, break large features into sub-issues
3. **Testable criteria**: Acceptance criteria should be verifiable
4. **Track progress**: Update the progress log as you work
5. **Link dependencies**: Always note what blocks or is blocked by this issue
6. **Update status**: Keep status current as work progresses

## Creating Issues via CLI

```bash
# Create and start working on a new issue
arcflux start "Add user authentication" --create

# This creates the issue file and sets it as active
```

## Issue Index

All issues are tracked in `.arcflux/memory/issues/_index.md` with a summary table:

```markdown
| Issue | Title | Status | Priority | Depends On |
|-------|-------|--------|----------|------------|
| [AF-001](./AF-001.md) | CLI entry point | ✅ COMPLETE | P0 | - |
| [AF-002](./AF-002.md) | State management | 🔄 IN_PROGRESS | P0 | AF-001 |
```
