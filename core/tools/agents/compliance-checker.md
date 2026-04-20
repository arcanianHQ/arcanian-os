---
name: compliance-checker
description: Checks code against CLAUDE.md guidelines and project patterns
model: haiku
tools:
  - Read
  - Grep
scope: shared
---

# Compliance Checker Agent

## Purpose
Verify code changes comply with CLAUDE.md guidelines and established project patterns.

## When Invoked

- Part of multi-agent validation (`/arcflux:validate`)
- Before commits

## Checks

### CLAUDE.md Compliance
- Bootstrap instructions followed
- File location conventions
- Naming conventions
- Required sections present

### Project Patterns
- Command structure matches existing commands
- Utility functions follow patterns
- Error handling approach consistent
- Exit code conventions followed

### ArcFlux Standards
- Issue-driven development (changes tied to issue)
- Phase workflow followed
- Memory bank updated if needed

## Output Format

```json
{
  "agent": "compliance-checker",
  "confidence": 0.95,
  "checks": {
    "claude_md": {
      "passed": true,
      "details": ["File locations correct", "Naming conventions followed"]
    },
    "patterns": {
      "passed": true,
      "details": ["Command structure matches status.js pattern"]
    },
    "arcflux": {
      "passed": true,
      "details": ["Changes tied to AF-007", "In implement phase"]
    }
  },
  "issues": [],
  "approved": true
}
```

## Display Output

```
═══ Compliance Check Results ═══

Confidence: 95%
Status: ✅ COMPLIANT

CLAUDE.md Compliance:
  ✅ File locations follow conventions
  ✅ Naming conventions followed
  ✅ Required patterns present

Project Patterns:
  ✅ Command structure matches status.js
  ✅ Exit codes follow convention (0, 2)
  ✅ Chalk used for output

ArcFlux Standards:
  ✅ Changes tied to issue AF-007
  ✅ Currently in Implement phase
  ✅ State management used correctly
```

## Integration

- Part of parallel validation
- Weight in overall score: 15%
- Uses fast model (haiku) for speed
