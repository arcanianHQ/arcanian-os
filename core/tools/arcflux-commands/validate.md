---
name: validate
description: Run multi-agent validation on current work
arguments:
  - name: aspects
    description: Specific aspects to validate (compliance, bugs, security, tests, code, all)
    required: false
  - name: threshold
    description: Confidence threshold (default 0.8)
    required: false
scope: shared
---

# ArcFlux Validate Command

## Purpose
Run parallel multi-agent validation to check code quality, security, and correctness before committing.

## Validation Agents

| Agent | Purpose | Weight |
|-------|---------|--------|
| **compliance-checker** | CLAUDE.md and pattern compliance | 15% |
| **bug-detector** | Logic errors, edge cases | 25% |
| **security-scanner** | Security vulnerabilities | 25% |
| **code-reviewer** | Code quality, readability | 20% |
| **test-analyzer** | Test coverage, test quality | 15% |

## Behavior

### Run Full Validation

```
/arcflux:validate

🔍 Running multi-agent validation...

═══ Validation Results ═══

┌─────────────────────┬────────┬─────────────────────────────────┐
│ Agent               │ Score  │ Findings                        │
├─────────────────────┼────────┼─────────────────────────────────┤
│ compliance-checker  │ 0.95   │ ✅ All patterns followed        │
│ bug-detector        │ 0.82   │ ⚠️ 1 potential edge case        │
│ security-scanner    │ 1.00   │ ✅ No security issues           │
│ code-reviewer       │ 0.88   │ ⚠️ 2 style suggestions          │
│ test-analyzer       │ 0.75   │ ⚠️ Missing test for error case  │
└─────────────────────┴────────┴─────────────────────────────────┘

Overall Confidence: 0.86 (weighted average)
Threshold: 0.80

✅ PASSED - Ready to commit

Suggestions:
  1. Add test for error handling in start.js:45
  2. Consider extracting validation logic to separate function
```

### Validation Failed

```
/arcflux:validate

Overall Confidence: 0.72
Threshold: 0.80

❌ FAILED - Issues must be resolved

Critical Issues:
  1. [security-scanner] SQL injection vulnerability in query.js:23
  2. [bug-detector] Null pointer exception possible in handler.js:89

Fix these issues and run /arcflux:validate again.
```

### Validate Specific Aspects

```
/arcflux:validate security tests

Running: security-scanner, test-analyzer only...
```

## Confidence Scoring

Each agent returns:
```json
{
  "agent": "bug-detector",
  "confidence": 0.82,
  "issues": [
    {
      "severity": "warning",
      "file": "src/commands/start.js",
      "line": 45,
      "message": "Edge case: empty issue ID not handled"
    }
  ],
  "suggestions": [...]
}
```

Overall score = weighted average of agent scores.

## Parallel Execution

All agents run simultaneously:

```
┌─────────────────────────────────────────┐
│         /arcflux:validate               │
│                                         │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│  │Compliance│ │  Bug    │ │Security │  │
│  │ Checker │ │Detector │ │ Scanner │  │
│  └────┬────┘ └────┬────┘ └────┬────┘  │
│       │           │           │        │
│  ┌────┴────┐ ┌────┴────┐              │
│  │  Code   │ │  Test   │              │
│  │Reviewer │ │Analyzer │              │
│  └────┬────┘ └────┬────┘              │
│       │           │                    │
│       └─────┬─────┘                    │
│             │                          │
│             ▼                          │
│    Aggregate Results                   │
│    Calculate Confidence                │
│    Pass/Fail Decision                  │
└─────────────────────────────────────────┘
```

## Integration with Workflow

Validation is required before:
- `/arcflux:commit` (blocks if failed)
- Moving to "Document" phase
- Creating PR

Override with `--force` flag (not recommended).
