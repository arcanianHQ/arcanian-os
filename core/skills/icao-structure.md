---
name: icao-structure
description: Implements Intent-Context-Action-Output framework for durable execution
scope: shared
---

# ICAO Structure Skill

## Purpose

Apply the ICAO (Intent, Context, Action, Output) framework from Jig to create clear, resumable task structures. This enables "assembly line" style development where each step is self-contained.

## Trigger
Use this skill when:
- Structuring a complex multi-step task for durable, resumable execution
- Preparing work for handoff, multi-session execution, or delegation to an agent
- User says "break this down ICAO", "make this resumable", "structure this task"

## Background

ICAO comes from Jig and is inspired by Henry Ford's assembly line insight: "work should come to the worker, not the worker to the work." In AI-native development, this means:

- Each task should be self-contained
- Clear handoff points between steps
- Resumable at any point
- No hidden context required

## ICAO Components

### Intent
**What** we're trying to accomplish.

```markdown
## Intent
Create a validation function that checks issue dependencies before allowing work to start.

Success Criteria:
- Returns true if all dependencies resolved
- Returns false with list of blocking issues
- Handles missing issues gracefully
```

### Context
**Why** and **where** - the background needed.

```markdown
## Context
- File: src/utils/validation.js
- Pattern: Follow existing validateIssue() structure
- Related: src/commands/start.js uses this
- Issue: AF-007

Existing Code:
```javascript
function validateIssue(issueId) {
  // Current implementation
}
```

Dependencies:
- linear.js for issue lookup
- state.js for current state
```

### Action
**How** - the specific steps to take.

```markdown
## Action
1. Add function validateDependencies(issueId)
2. Fetch issue from Linear
3. Extract dependencies field
4. For each dependency:
   - Check if resolved (status: done/completed)
   - If not resolved, add to blockers list
5. Return { valid: boolean, blockers: Issue[] }
6. Add to exports

Code Template:
```javascript
async function validateDependencies(issueId) {
  const issue = await linear.getIssue(issueId);
  // Implementation
}
```
```

### Output
**Result** - what was produced and next steps.

```markdown
## Output
Created: src/utils/validation.js:45-78

```javascript
async function validateDependencies(issueId) {
  const issue = await linear.getIssue(issueId);
  const dependencies = issue.dependencies || [];
  const blockers = [];

  for (const dep of dependencies) {
    if (!['done', 'completed'].includes(dep.status)) {
      blockers.push(dep);
    }
  }

  return {
    valid: blockers.length === 0,
    blockers
  };
}
```

Tests: Added test/utils/validation.test.js

Next: Integrate with start command (AF-007 task 3)
```

## Using ICAO in ArcFlux

### For Issue Planning

Each issue can be broken into ICAO blocks:

```markdown
# AF-007: Start Command

## Task 1: Validate Dependencies
**Intent**: Ensure issues can't start until dependencies resolved
**Context**: Part of start command flow, needs Linear integration
**Action**: Create validateDependencies() in validation.js
**Output**: [Filled after completion]

## Task 2: Create Branch
**Intent**: Auto-create git branch with standard naming
**Context**: Branch naming: feature/AF-XXX-slug
**Action**: Use git.js createBranch()
**Output**: [Filled after completion]

## Task 3: Update State
**Intent**: Track active issue in state.json
**Context**: state.js setActiveIssue()
**Action**: Call state manager with issue details
**Output**: [Filled after completion]
```

### For Session Recovery

When a session ends mid-task, ICAO enables clean resumption:

```markdown
## Last ICAO State

**Intent**: Create validateDependencies function
**Context**: Loaded ✓
**Action**: Step 4 of 6 - checking dependencies
**Output**: Partial - function created but not tested

Resume at: Action step 5 (return statement)
```

### For Agent Handoffs

When one agent passes work to another:

```markdown
## Handoff: code-architect → implement phase

**Intent**: Implement the designed validation system
**Context**:
  - Design in memory/issues/AF-007.md#design
  - Patterns in patterns/validation.md
**Action**: Create files per design spec
**Output**: Expected files:
  - src/utils/validation.js (new)
  - src/commands/start.js (modify)
```

## ICAO Templates

### New Function
```markdown
## ICAO: [Function Name]

**Intent**
Create [function] that [purpose].
- Input: [parameters]
- Output: [return value]
- Errors: [error conditions]

**Context**
- File: [path]
- Pattern: [reference existing similar code]
- Depends on: [imports needed]

**Action**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Output**
[To be filled]
```

### Bug Fix
```markdown
## ICAO: Fix [Bug Description]

**Intent**
Fix [bug] where [symptom].
- Expected: [correct behavior]
- Actual: [current behavior]

**Context**
- File: [path:line]
- Cause: [root cause analysis]
- Impact: [what this affects]

**Action**
1. [Change 1]
2. [Change 2]
3. Verify fix with test

**Output**
[To be filled]
```

### Refactor
```markdown
## ICAO: Refactor [Component]

**Intent**
Refactor [component] to [goal].
- Before: [current state]
- After: [target state]
- Preserve: [behavior to maintain]

**Context**
- Files: [list]
- Patterns: [target patterns]
- Tests: [existing coverage]

**Action**
1. [Step 1]
2. [Step 2]
3. Verify tests still pass

**Output**
[To be filled]
```

## Integration with Workflow

| Phase | ICAO Usage |
|-------|------------|
| Explore | Build Context section |
| Plan | Define Intent for each task |
| Architect | Detail Action steps |
| Implement | Execute Actions, fill Output |
| Review | Validate Output matches Intent |
| Test | Verify Output behavior |
| Document | Archive complete ICAO |

## Benefits

1. **Resumability**: Any session can pick up where another left off
2. **Clarity**: No ambiguity about what to do
3. **Auditability**: Clear record of what was done and why
4. **Handoffs**: Clean transitions between agents or phases
5. **Learning**: Output becomes Context for future similar tasks
