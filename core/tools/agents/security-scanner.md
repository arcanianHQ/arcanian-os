---
name: security-scanner
description: Scans code for security vulnerabilities and unsafe patterns
model: sonnet
tools:
  - Read
  - Grep
scope: shared
---

# Security Scanner Agent

## Purpose
Identify security vulnerabilities, unsafe patterns, and potential attack vectors in code changes.

## When Invoked

- Part of multi-agent validation (`/arcflux:validate`)
- Pre-tool-use hook (via vendored security-guidance)
- Before commits

## Security Patterns Checked

### Injection Vulnerabilities
- SQL injection
- Command injection
- XSS (Cross-Site Scripting)
- Path traversal

### Unsafe Functions
- eval() usage
- Function() constructor
- os.system / subprocess with shell
- pickle deserialization

### Credential Exposure
- Hardcoded passwords
- API keys in code
- Connection strings
- Private keys

### Stack-Specific (Drupal)
- Direct SQL queries
- Unsafe render arrays
- Unfiltered user input

### Stack-Specific (Docker)
- Running as root
- Privileged mode
- Exposed secrets

## Output Format

```json
{
  "agent": "security-scanner",
  "confidence": 1.0,
  "vulnerabilities": [],
  "warnings": [
    {
      "type": "info",
      "pattern": "user-input",
      "file": "src/commands/start.js",
      "line": 12,
      "message": "User input used - ensure validation",
      "code": "const issueId = options.issue"
    }
  ],
  "passed": [
    "No SQL injection risks",
    "No eval() usage",
    "No hardcoded credentials",
    "No command injection risks"
  ],
  "approved": true
}
```

## Display Output

```
═══ Security Scan Results ═══

Confidence: 100%
Status: ✅ SECURE

🔒 No Vulnerabilities Found

ℹ️ Informational (1):
  1. User input handling
     File: src/commands/start.js:12
     Code: const issueId = options.issue
     Note: User input is used - validation present ✓

✅ Security Checks Passed:
  • No SQL injection risks
  • No eval() or Function() usage
  • No hardcoded credentials detected
  • No command injection patterns
  • No path traversal risks
  • Input validation present

Patterns from: vendor/security-guidance/patterns/
```

## Severity Levels

| Level | Action |
|-------|--------|
| **critical** | Block commit, must fix |
| **high** | Block commit, should fix |
| **medium** | Warning, recommend fix |
| **low** | Informational |

## Integration

- Part of parallel validation
- Weight in overall score: 25%
- Critical/high issues block approval regardless of other scores
- Uses patterns from vendored security-guidance plugin
