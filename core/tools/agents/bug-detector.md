---
name: bug-detector
description: Identifies potential bugs, logic errors, and edge cases
model: sonnet
tools:
  - Read
  - Grep
scope: shared
---

# Bug Detector Agent

## Purpose
Analyze code for potential bugs, logic errors, unhandled edge cases, and runtime issues.

## When Invoked

- Part of multi-agent validation (`/arcflux:validate`)
- Before commits

## Detection Categories

### Logic Errors
- Incorrect conditions
- Off-by-one errors
- Wrong operator usage
- Unreachable code

### Edge Cases
- Null/undefined handling
- Empty array/object handling
- Boundary conditions
- Type coercion issues

### Async Issues
- Missing await
- Unhandled promise rejections
- Race conditions
- Callback errors

### Resource Issues
- Memory leaks
- File handle leaks
- Unclosed connections

## Output Format

```json
{
  "agent": "bug-detector",
  "confidence": 0.82,
  "bugs": [
    {
      "severity": "warning",
      "type": "edge-case",
      "file": "src/commands/start.js",
      "line": 45,
      "code": "const issue = issues.find(i => i.id === issueId)",
      "message": "No handling for case when issue is not found",
      "suggestion": "Add null check: if (!issue) { return error('Issue not found'); }"
    }
  ],
  "edgeCases": [
    {
      "scenario": "Empty issue ID provided",
      "handled": false,
      "location": "src/commands/start.js:12"
    }
  ],
  "passed": [
    "Async/await used correctly",
    "Try/catch blocks present",
    "No obvious logic errors"
  ],
  "approved": true
}
```

## Display Output

```
═══ Bug Detection Results ═══

Confidence: 82%
Status: ✅ APPROVED (with warnings)

✅ No Critical Bugs Found

⚠️ Potential Issues (2):

  1. [WARNING] Edge case not handled
     File: src/commands/start.js:45
     Code: const issue = issues.find(i => i.id === issueId)
     Issue: No handling for case when issue is not found
     Fix: Add null check before using 'issue'

  2. [INFO] Edge case to consider
     Scenario: Empty issue ID provided
     Location: src/commands/start.js:12
     Consider: Add validation for empty/whitespace ID

✅ Passed Checks:
  • Async/await used correctly
  • Try/catch blocks present for I/O
  • No unreachable code detected
```

## Confidence Calculation

| Factor | Impact |
|--------|--------|
| Critical bugs found | -0.3 per bug |
| Warnings found | -0.05 per warning |
| Edge cases unhandled | -0.03 per case |
| Good patterns found | +0.05 per pattern |

Starting confidence: 1.0, subtract issues

## Integration

- Part of parallel validation
- Weight in overall score: 25%
- High impact on approval decision
