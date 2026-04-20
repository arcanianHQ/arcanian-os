---
name: pre-tool-use
description: Validates and controls tool usage before execution
trigger: on_pre_tool_use
tools_monitored:
  - Write
  - Edit
  - Bash
  - WebFetch
scope: shared
---

# Pre-Tool-Use Hook

## Purpose
Intercept tool calls before execution to:
- Enforce security rules (vendored from security-guidance)
- Apply screenshot harness (prevent context overflow)
- Validate file operations against memory bank
- Log execution for tracking

## Trigger
Runs before every tool call for monitored tools.

## Behavior

### 1. Security Checks (from vendor/security-guidance)

```bash
# Load security patterns
PATTERNS_DIR="vendor/security-guidance/patterns"

# Check against rules based on tool type
case "$TOOL_NAME" in
  "Bash")
    # Check for dangerous commands
    if echo "$TOOL_INPUT" | grep -qE "(rm -rf|chmod 777|curl.*\|.*sh)"; then
      echo "BLOCKED: Dangerous command pattern detected"
      exit 2
    fi
    ;;
  "Write"|"Edit")
    # Check for credential exposure
    if echo "$TOOL_INPUT" | grep -qiE "(password|api_key|secret).*=.*['\"][^'\"]+['\"]"; then
      echo "WARNING: Potential credential in code"
      # Allow but warn
    fi
    ;;
esac
```

### 2. Screenshot Harness (from vendor/hookify)

```bash
# If tool is WebFetch or screenshot-related
if [ "$TOOL_NAME" = "WebFetch" ] || echo "$TOOL_INPUT" | grep -q "screenshot"; then
  # Check for full-page screenshot attempts
  if echo "$TOOL_INPUT" | grep -qE "fullPage.*true|full.*page"; then
    echo "BLOCKED: Full page screenshots disabled (context overflow risk)"
    echo "Use viewport screenshot instead, or specify a region"
    exit 2
  fi

  # Check for oversized viewport
  if echo "$TOOL_INPUT" | grep -qE "height.*[0-9]{5,}"; then
    echo "BLOCKED: Screenshot height too large"
    exit 2
  fi
fi
```

### 3. Memory Bank Validation

```bash
# For Write/Edit operations
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  TARGET_FILE="$TOOL_TARGET"

  # Check if modifying memory bank
  if echo "$TARGET_FILE" | grep -q ".arcflux/memory"; then
    # Validate structure
    if echo "$TARGET_FILE" | grep -q "issues/"; then
      # Ensure issue file follows format
      echo "INFO: Memory bank update - issue file"
    fi
  fi

  # Check if modifying config
  if echo "$TARGET_FILE" | grep -q ".arcflux/config.json"; then
    echo "INFO: Config modification - will validate JSON"
  fi
fi
```

### 4. Execution Logging

```bash
# Log to execution file
EXEC_LOG=".arcflux/execution/$(date +%Y%m%d).log"
echo "[$(date +%H:%M:%S)] PRE: $TOOL_NAME - $TOOL_TARGET" >> "$EXEC_LOG"
```

## Output Format

### Allowed (exit 0)
```
✅ Tool allowed: Write to src/commands/start.js
   Security: passed
   Memory: not affected
```

### Blocked (exit 2)
```
🚫 Tool BLOCKED: Bash
   Reason: Dangerous command pattern (rm -rf /)
   Rule: security-guidance/dangerous-commands

   Suggestion: Use specific file paths instead of recursive wildcards
```

### Warning (exit 0 with message)
```
⚠️ Tool allowed with warning: Edit
   Warning: Potential credential in code
   File: src/config/database.js
   Line: const password = "..."

   Suggestion: Use environment variables for credentials
```

## Security Rules Applied

From `vendor/security-guidance/patterns/`:

| Pattern | Action | Message |
|---------|--------|---------|
| `rm -rf /` or `rm -rf ~` | Block | Recursive delete on root/home |
| `chmod 777` | Warn | Overly permissive permissions |
| `curl \| sh` | Block | Piped remote execution |
| `eval($user_input)` | Block | Code injection risk |
| Hardcoded credentials | Warn | Use env vars |

From `vendor/hookify/rules/screenshot.json`:

| Pattern | Action | Message |
|---------|--------|---------|
| `fullPage: true` | Block | Context overflow risk |
| Height > 10000px | Block | Too large for context |
| Multiple screenshots | Warn | Consider viewport targeting |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Tool allowed to proceed |
| 2 | Tool blocked - do not execute |

## Configuration

In `.arcflux/config.json`:

```json
{
  "hooks": {
    "preToolUse": {
      "enabled": true,
      "security": true,
      "screenshotHarness": true,
      "memoryValidation": true,
      "executionLogging": true
    }
  }
}
```

## Integration

- Loads rules from vendor/security-guidance
- Loads rules from vendor/hookify
- Writes to .arcflux/execution/ for tracking
- Respects tool-specific settings
