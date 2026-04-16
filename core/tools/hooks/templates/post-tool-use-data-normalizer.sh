#!/bin/bash
# post-tool-use-data-normalizer.sh
# Normalizes heterogeneous data formats from MCP tool results before the model processes them.
# Matches: mcp__* tools (all MCP server tool calls)
# Output: stderr messages with normalized values (visible to Claude alongside raw data)
#
# Phase 1: Unix timestamp normalization only (most impactful)
# Future: date format standardization, currency code annotation

# Read tool result from stdin
TOOL_RESULT=$(cat)

# Skip if result is empty or very short (likely an error, handled by error-classifier)
if [ ${#TOOL_RESULT} -lt 10 ]; then
  exit 0
fi

# Phase 1: Detect and normalize Unix timestamps (10-digit numbers that look like timestamps)
# Match 10-digit numbers that are plausible timestamps (2020-01-01 to 2030-12-31)
# 1577836800 = 2020-01-01, 1924991999 = 2030-12-31
TIMESTAMPS=$(echo "$TOOL_RESULT" | grep -oE '\b1[5-9][0-9]{8}\b' | sort -u)

if [ -n "$TIMESTAMPS" ]; then
  NORMALIZED=""
  while IFS= read -r ts; do
    # Verify it's a plausible timestamp (not just any 10-digit number)
    if [ "$ts" -ge 1577836800 ] && [ "$ts" -le 1924991999 ] 2>/dev/null; then
      # Convert to ISO 8601 — portable: try BSD (macOS), then GNU (Linux), then python3
      ISO_DATE=$(date -r "$ts" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null)
      if [ -z "$ISO_DATE" ]; then
        ISO_DATE=$(date -d "@$ts" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null)
      fi
      if [ -z "$ISO_DATE" ]; then
        ISO_DATE=$(python3 -c "import datetime; print(datetime.datetime.fromtimestamp($ts).strftime('%Y-%m-%dT%H:%M:%S'))" 2>/dev/null)
      fi
      if [ -n "$ISO_DATE" ]; then
        NORMALIZED="${NORMALIZED}  ${ts} → ${ISO_DATE}\n"
      fi
    fi
  done <<< "$TIMESTAMPS"

  if [ -n "$NORMALIZED" ]; then
    echo "DATA NORMALIZATION: Unix timestamps detected and converted:" >&2
    echo -e "$NORMALIZED" >&2
  fi
fi

exit 0
