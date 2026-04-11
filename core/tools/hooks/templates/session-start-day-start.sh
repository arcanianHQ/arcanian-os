#!/bin/bash

# session-start-day-start.sh
# Auto-triggers /day-start on the first session of the day.
# Uses .claude/last-session-date.local to track whether today's session already ran.

set -euo pipefail

TODAY=$(date +%Y-%m-%d)
STATE_FILE=".claude/last-session-date.local"

# Check if this is the first session of the day
if [[ -f "$STATE_FILE" ]]; then
  LAST_DATE=$(cat "$STATE_FILE" 2>/dev/null || echo "")
  if [[ "$LAST_DATE" == "$TODAY" ]]; then
    # Already ran today — do nothing
    exit 0
  fi
fi

# First session of the day — mark it and trigger day-start
mkdir -p .claude
echo "$TODAY" > "$STATE_FILE"

echo "First session of the day ($TODAY). Auto-running /day-start." >&2

# Inject /day-start as the initial prompt
# Note: SessionStart hooks can emit a JSON object with "prompt" to inject
jq -n --arg prompt "/day-start" '{"prompt": $prompt}'

exit 0
