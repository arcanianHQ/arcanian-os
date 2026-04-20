---
name: issue-workflow
description: Manages the complete lifecycle of working on an issue through all phases
scope: shared
---

# Issue Workflow Skill

## Purpose
Orchestrate the complete workflow for developing a feature or fix, from issue selection through completion. Combines the 7-phase methodology with issue tracking and quality gates.

## When to Use

This skill is activated when:
- User runs `/arcflux:start <issue>`
- User wants to work through a complete issue
- Agent needs to coordinate multi-phase work

## The 7-Phase Workflow

```
┌──────────┐   ┌──────────┐   ┌───────────┐   ┌───────────┐
│ Explore  │ → │  Plan    │ → │ Architect │ → │ Implement │
└──────────┘   └──────────┘   └───────────┘   └───────────┘
                                                   │
┌──────────┐   ┌──────────┐   ┌──────────┐        │
│ Document │ ← │   Test   │ ← │  Review  │ ←─────┘
└──────────┘   └──────────┘   └──────────┘
```

## Phase Definitions

### 1. Explore
**Agent**: code-explorer
**Purpose**: Understand the codebase and requirements

Activities:
- Read issue requirements
- Search codebase for related code
- Identify dependencies
- Map existing patterns

Exit Criteria:
- Clear understanding of requirements
- Related code locations identified
- No open questions about scope

### 2. Plan
**Purpose**: Create high-level implementation plan

Activities:
- Break down requirements into tasks
- Identify risks and unknowns
- Estimate complexity
- Define success criteria

Exit Criteria:
- Task list created
- Approach documented
- User approval (if significant changes)

### 3. Architect
**Agent**: code-architect
**Purpose**: Design the solution

Activities:
- Design component structure
- Define interfaces
- Plan data flow
- Consider edge cases

Exit Criteria:
- Design documented
- Interfaces defined
- No architectural unknowns

### 4. Implement
**Purpose**: Write the code

Activities:
- Create/modify files
- Follow existing patterns
- Handle edge cases
- Write inline comments for complex logic

Exit Criteria:
- All planned changes complete
- Code compiles/runs
- No obvious errors

### 5. Review
**Agent**: code-reviewer (+ bug-detector, security-scanner, compliance-checker)
**Purpose**: Validate code quality

Activities:
- Run multi-agent validation
- Check against patterns
- Verify security
- Ensure compliance

Exit Criteria:
- Weighted score ≥ 0.80
- No critical issues
- All blocking issues resolved

### 6. Test
**Agent**: test-analyzer
**Purpose**: Verify functionality

Activities:
- Run existing tests
- Add tests for new functionality
- Verify edge cases
- Check coverage

Exit Criteria:
- All tests passing
- Coverage meets threshold
- No regressions

### 7. Document
**Purpose**: Update documentation

Activities:
- Update memory bank with learnings
- Document public APIs
- Update CHANGELOG if needed
- Close issue

Exit Criteria:
- Issue file updated with outcome
- Relevant docs updated
- Issue marked complete

## Phase Transitions

```javascript
// Transition rules
const transitions = {
  'explore': {
    next: 'plan',
    requires: ['understanding_documented']
  },
  'plan': {
    next: 'architect',
    requires: ['plan_approved'],
    skipTo: 'implement'  // For simple changes
  },
  'architect': {
    next: 'implement',
    requires: ['design_complete']
  },
  'implement': {
    next: 'review',
    requires: ['code_complete']
  },
  'review': {
    next: 'test',
    requires: ['validation_passed'],
    backTo: 'implement'  // If issues found
  },
  'test': {
    next: 'document',
    requires: ['tests_passing'],
    backTo: 'implement'  // If tests fail
  },
  'document': {
    next: null,  // Complete
    requires: ['docs_updated']
  }
};
```

## Workflow Commands

| Command | Action |
|---------|--------|
| `/arcflux:phase` | Show current phase, suggest next actions |
| `/arcflux:phase next` | Move to next phase |
| `/arcflux:phase skip` | Skip optional phases (with justification) |
| `/arcflux:phase back` | Return to previous phase |

## State Tracking

The skill maintains state in `.arcflux/state.json`:

```json
{
  "activeIssue": "AF-043",
  "currentPhase": "implement",
  "phaseHistory": [
    {"phase": "explore", "completed": "2024-01-15T10:00:00Z"},
    {"phase": "plan", "completed": "2024-01-15T10:30:00Z"},
    {"phase": "architect", "skipped": true, "reason": "Simple change"},
    {"phase": "implement", "started": "2024-01-15T11:00:00Z"}
  ],
  "modifiedFiles": [
    "src/commands/start.js",
    "src/utils/validation.js"
  ]
}
```

## Integration with Commands

| Command | Uses Workflow |
|---------|---------------|
| `/arcflux:start` | Enters Explore phase |
| `/arcflux:validate` | Part of Review phase |
| `/arcflux:commit` | After Review phase |
| `/arcflux:status` | Shows phase progress |

## Adaptive Behavior

The workflow adapts based on change complexity:

### Simple Changes (1-2 files, no architecture)
- Skip: Architect, sometimes Plan
- Fast path: Explore → Implement → Review → Test

### Medium Changes (feature addition)
- Full workflow with lighter phases
- Plan phase may be brief

### Complex Changes (new subsystem)
- Full workflow with deep phases
- May require multiple review cycles
- Architect phase crucial

## Memory Updates

Throughout the workflow, the skill updates:

1. **Issue file** (`.arcflux/memory/issues/AF-XXX.md`)
   - Progress notes
   - Decisions made
   - Blockers encountered

2. **Captain's Log** (if significant decisions)
   - Architecture choices
   - Trade-offs considered

3. **Pattern learnings** (if new patterns discovered)
   - Code patterns
   - Testing patterns
