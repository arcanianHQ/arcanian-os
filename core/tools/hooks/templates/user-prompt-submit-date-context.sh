#!/bin/bash
# Hook: user-prompt-submit — Date Context Injection
# Detects date-related keywords in user prompt and injects accurate date context.
# Prevents day-of-week miscalculation errors.
# Exit 0 = allow (always). Prints date context to stderr if date-related prompt detected.

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | grep -o '"prompt":"[^"]*"' | cut -d'"' -f4 2>/dev/null)

# If we can't parse, allow
[ -z "$PROMPT" ] && exit 0

# Date-related keywords (English + Hungarian)
# Matches: today, tomorrow, yesterday, monday-sunday, this week, next week,
# schedule, due, overdue, deadline, day-start, day-end, tasks for today,
# ma, holnap, tegnap, hétfő-vasárnap, ezen a héten, jövő héten, határidő
if echo "$PROMPT" | grep -qiE \
  'today|tomorrow|yesterday|this week|next week|last week|schedule|due date|overdue|deadline|day.?start|day.?end|tasks? for|what day|which day|when is|hétfő|kedd|szerda|csütörtök|péntek|szombat|vasárnap|monday|tuesday|wednesday|thursday|friday|saturday|sunday|ma |holnap|tegnap|ezen a héten|jövő héten|határidő|mikor|milyen nap'; then

  # Get date context from the canonical script
  SCRIPT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)/scripts/ops"
  if [[ -f "$SCRIPT_DIR/date-context.sh" ]]; then
    DATE_INFO=$(bash "$SCRIPT_DIR/date-context.sh" oneliner 2>/dev/null)
  else
    # Fallback if script not found
    DATE_INFO="$(date +%Y-%m-%d) ($(date +%A)) | W$(date +%V) | Q$(( ($(date +%-m) - 1) / 3 + 1 ))"
  fi

  echo "📅 $DATE_INFO" >&2
fi

# Always allow
exit 0
