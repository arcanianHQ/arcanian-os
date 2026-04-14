#!/bin/bash
# date-context.sh — Single source of truth for current date context.
# Outputs structured date info for Claude Code sessions.
# Used by: user-prompt-submit-date-context hook, /day-start, any skill needing date awareness.

set -euo pipefail

# Use system date (macOS compatible)
TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%A)
DAY_SHORT=$(date +%a)
WEEK_NUMBER=$(date +%V)
MONTH_NAME=$(date +%B)
YEAR=$(date +%Y)
QUARTER=$(( ($(date +%-m) - 1) / 3 + 1 ))
HOUR=$(date +%H)

# Working day check (Mon-Fri)
DOW_NUM=$(date +%u)  # 1=Mon, 7=Sun
if [[ "$DOW_NUM" -le 5 ]]; then
  WORKING_DAY="yes"
else
  WORKING_DAY="no"
fi

# Time of day context
if [[ "$HOUR" -lt 12 ]]; then
  TIME_OF_DAY="morning"
elif [[ "$HOUR" -lt 17 ]]; then
  TIME_OF_DAY="afternoon"
else
  TIME_OF_DAY="evening"
fi

# Output format based on argument
case "${1:-summary}" in
  json)
    cat <<EOF
{"date":"$TODAY","dayOfWeek":"$DAY_OF_WEEK","weekNumber":"$WEEK_NUMBER","quarter":"Q$QUARTER","workingDay":$WORKING_DAY,"timeOfDay":"$TIME_OF_DAY"}
EOF
    ;;
  oneliner)
    echo "$TODAY ($DAY_OF_WEEK) | W$WEEK_NUMBER | Q$QUARTER | Working day: $WORKING_DAY"
    ;;
  *)
    cat <<EOF
📅 Date context:
  Date: $TODAY ($DAY_OF_WEEK)
  Week: W$WEEK_NUMBER | Q$QUARTER $YEAR
  Working day: $WORKING_DAY
  Time of day: $TIME_OF_DAY
EOF
    ;;
esac
