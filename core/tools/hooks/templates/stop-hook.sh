#!/bin/bash

# stop-hook.sh — unified Stop hook for ArcOS
# Handles TWO scenarios:
# 1. Active Ralph loop → feed same prompt back (existing behavior)
# 2. End of day (after 17:00, no Ralph active) → trigger /day-end once

set -euo pipefail

HOOK_INPUT=$(cat)

# ─── SCENARIO 1: Ralph Loop ───────────────────────────────────

RALPH_STATE_FILE=".claude/ralph-loop.local.md"

if [[ -f "$RALPH_STATE_FILE" ]]; then
  # Ralph loop is active — delegate to Ralph logic

  FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$RALPH_STATE_FILE")
  ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
  MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
  COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/')

  # Validate
  if [[ ! "$ITERATION" =~ ^[0-9]+$ ]] || [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
    echo "Ralph loop: State file corrupted. Stopping." >&2
    rm "$RALPH_STATE_FILE"
    exit 0
  fi

  # Check max iterations
  if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
    echo "Ralph loop: Max iterations ($MAX_ITERATIONS) reached." >&2
    rm "$RALPH_STATE_FILE"
    exit 0
  fi

  # Check completion promise in transcript
  TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path' 2>/dev/null || echo "")

  if [[ -n "$TRANSCRIPT_PATH" ]] && [[ -f "$TRANSCRIPT_PATH" ]]; then
    LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1)
    if [[ -n "$LAST_LINE" ]]; then
      LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '.message.content | map(select(.type == "text")) | map(.text) | join("\n")' 2>/dev/null || echo "")

      if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
        PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")
        if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
          echo "Ralph loop: Completion promise detected. Done." >&2
          rm "$RALPH_STATE_FILE"
          exit 0
        fi
      fi
    fi
  fi

  # Continue Ralph loop
  NEXT_ITERATION=$((ITERATION + 1))
  PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$RALPH_STATE_FILE")

  if [[ -z "$PROMPT_TEXT" ]]; then
    echo "Ralph loop: No prompt in state file. Stopping." >&2
    rm "$RALPH_STATE_FILE"
    exit 0
  fi

  TEMP_FILE="${RALPH_STATE_FILE}.tmp.$$"
  sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$RALPH_STATE_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$RALPH_STATE_FILE"

  if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
    SYSTEM_MSG="Ralph iteration $NEXT_ITERATION | To complete: output <promise>$COMPLETION_PROMISE</promise> (ONLY when TRUE)"
  else
    SYSTEM_MSG="Ralph iteration $NEXT_ITERATION"
  fi

  jq -n \
    --arg prompt "$PROMPT_TEXT" \
    --arg msg "$SYSTEM_MSG" \
    '{
      "decision": "block",
      "reason": $prompt,
      "systemMessage": $msg
    }'

  exit 0
fi

# ─── SCENARIO 2: End of Day ───────────────────────────────────

CURRENT_HOUR=$(date +%H)
TODAY=$(date +%Y-%m-%d)
DAY_END_STATE=".claude/day-end-done.local"

# Only trigger after 17:00
if [[ $CURRENT_HOUR -ge 17 ]]; then
  # Check if day-end already ran today
  if [[ -f "$DAY_END_STATE" ]]; then
    LAST_DAY_END=$(cat "$DAY_END_STATE" 2>/dev/null || echo "")
    if [[ "$LAST_DAY_END" == "$TODAY" ]]; then
      # Already ran today — allow exit
      exit 0
    fi
  fi

  # Day-end not yet run today — trigger it
  mkdir -p .claude
  echo "$TODAY" > "$DAY_END_STATE"

  echo "End of day detected ($(date +%H:%M)). Running /day-end before exit." >&2

  jq -n \
    --arg prompt "/day-end" \
    --arg msg "Auto day-end: running before session close" \
    '{
      "decision": "block",
      "reason": $prompt,
      "systemMessage": $msg
    }'

  exit 0
fi

# ─── No Ralph, not end of day — allow normal exit ─────────────
exit 0
