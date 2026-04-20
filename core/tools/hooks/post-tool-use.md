---
name: post-tool-use
description: Processes tool results and updates tracking after execution
trigger: on_post_tool_use
tools_monitored:
  - Write
  - Edit
  - Bash
scope: shared
---

# Post-Tool-Use Hook

## Purpose
Process tool results after execution to:
- Track file modifications for commits
- Update execution logs with results
- Detect issues in output
- Manage screenshot results

## Trigger
Runs after every tool call for monitored tools completes.

## Behavior

### 1. Track File Modifications

```bash
# For Write/Edit operations
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  MODIFIED_FILE="$TOOL_TARGET"

  # Add to modified files list
  STATE_FILE=".arcflux/state.json"
  if [ -f "$STATE_FILE" ]; then
    # Update modifiedFiles array in state
    jq --arg file "$MODIFIED_FILE" \
      '.modifiedFiles = (.modifiedFiles // []) + [$file] | .modifiedFiles |= unique' \
      "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
  fi

  echo "📝 Tracked: $MODIFIED_FILE"
fi
```

### 2. Update Execution Log

```bash
# Log completion
EXEC_LOG=".arcflux/execution/$(date +%Y%m%d).log"
EXIT_CODE="$TOOL_EXIT_CODE"
DURATION="$TOOL_DURATION_MS"

echo "[$(date +%H:%M:%S)] POST: $TOOL_NAME - Exit: $EXIT_CODE - ${DURATION}ms" >> "$EXEC_LOG"

# Track token usage if available
if [ -n "$TOOL_TOKENS" ]; then
  echo "  Tokens: $TOOL_TOKENS" >> "$EXEC_LOG"
fi
```

### 3. Analyze Bash Output

```bash
if [ "$TOOL_NAME" = "Bash" ]; then
  OUTPUT="$TOOL_OUTPUT"

  # Check for common error patterns
  if echo "$OUTPUT" | grep -qiE "(error|failed|exception|ENOENT)"; then
    echo "⚠️ Potential error detected in output"
    # Don't block, just inform
  fi

  # Check for test results
  if echo "$OUTPUT" | grep -qE "(PASS|FAIL|✓|✗)"; then
    # Extract test summary if available
    PASSED=$(echo "$OUTPUT" | grep -cE "(PASS|✓)" || echo "0")
    FAILED=$(echo "$OUTPUT" | grep -cE "(FAIL|✗)" || echo "0")
    echo "🧪 Tests: $PASSED passed, $FAILED failed"
  fi

  # Check for build output
  if echo "$OUTPUT" | grep -qE "(compiled|built|bundled)"; then
    echo "🔨 Build completed"
  fi
fi
```

### 4. Screenshot Result Processing

```bash
# If screenshot was taken (via Chrome DevTools MCP)
if echo "$TOOL_OUTPUT" | grep -qE "(screenshot|image/png|base64)"; then
  # Check output size
  OUTPUT_SIZE=${#TOOL_OUTPUT}
  MAX_SIZE=500000  # 500KB threshold

  if [ "$OUTPUT_SIZE" -gt "$MAX_SIZE" ]; then
    echo "⚠️ Large screenshot result (${OUTPUT_SIZE} bytes)"
    echo "   Consider using smaller viewport or region capture"
  fi

  # Log screenshot for reference
  echo "[$(date +%H:%M:%S)] Screenshot captured - ${OUTPUT_SIZE} bytes" >> "$EXEC_LOG"
fi
```

### 5. Memory Bank Update Detection

```bash
# If memory bank was modified
if echo "$TOOL_TARGET" | grep -q ".arcflux/memory"; then
  echo "📚 Memory bank updated: $(basename $TOOL_TARGET)"

  # Validate JSON files
  if echo "$TOOL_TARGET" | grep -qE "\.json$"; then
    if ! jq . "$TOOL_TARGET" > /dev/null 2>&1; then
      echo "⚠️ Warning: JSON may be malformed"
    fi
  fi
fi
```

## Output Format

### Success
```
✅ Tool completed: Write
   File: src/commands/start.js
   Status: Modified (tracked for commit)
   Duration: 45ms
```

### With Warnings
```
✅ Tool completed: Bash
   Command: npm test
   Exit code: 0
   Duration: 3420ms

   🧪 Test Results: 12 passed, 0 failed
```

### Error Detected
```
✅ Tool completed: Bash
   Command: npm run build
   Exit code: 1
   Duration: 1205ms

   ⚠️ Build failed - check output for errors
```

## State Updates

The hook updates `.arcflux/state.json`:

```json
{
  "modifiedFiles": [
    "src/commands/start.js",
    "src/utils/validation.js"
  ],
  "lastToolUse": {
    "tool": "Edit",
    "target": "src/commands/start.js",
    "timestamp": "2024-01-15T14:30:00Z",
    "success": true
  }
}
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Post-processing complete |

Note: Post-tool-use hooks should never block. They only track and inform.

## Configuration

In `.arcflux/config.json`:

```json
{
  "hooks": {
    "postToolUse": {
      "enabled": true,
      "trackModifications": true,
      "executionLogging": true,
      "outputAnalysis": true
    }
  }
}
```

## Integration

- Updates state.json with modified files
- Writes to .arcflux/execution/ for tracking
- Informs commit command about changes
- Works with multi-agent validation
