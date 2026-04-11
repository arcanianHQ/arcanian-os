#!/bin/bash
# pre-tool-use-enrichment-gate.sh
# BLOCKS writing to internal/leads/*/sent/ if enrichment prerequisites are not met.
# Matches: Write|Edit on files in internal/leads/*/sent/
# Exit code 2 = BLOCK the tool call

# Read tool input from stdin
TOOL_INPUT=$(cat)

# Extract file path from the tool input
FILE_PATH=$(echo "$TOOL_INPUT" | grep -oE '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/"file_path"\s*:\s*"//;s/"$//')

# Only check files in internal/leads/*/sent/
if [[ "$FILE_PATH" == *"internal/leads/"*"/sent/"* ]]; then
  # Extract lead slug from path
  LEAD_SLUG=$(echo "$FILE_PATH" | sed -n 's|.*internal/leads/\([^/]*\)/sent/.*|\1|p')

  if [ -z "$LEAD_SLUG" ]; then
    exit 0  # Can't determine slug, allow
  fi

  # Find the lead status file (search relative to project root)
  LEAD_STATUS="internal/leads/${LEAD_SLUG}/LEAD_STATUS.md"

  if [ ! -f "$LEAD_STATUS" ]; then
    echo "BLOCKED: No LEAD_STATUS.md found for lead '${LEAD_SLUG}'. Create the lead file first before sending materials. See core/methodology/ENRICHMENT_WATERFALL.md" >&2
    exit 2
  fi

  # Check stage — must be at least "Diagnosed"
  STAGE=$(grep -i '^\| \*\*Stage\*\*' "$LEAD_STATUS" | head -1 | sed 's/.*| *//;s/ *|.*//' | xargs)

  if [ -z "$STAGE" ]; then
    echo "BLOCKED: Cannot determine lead stage from LEAD_STATUS.md for '${LEAD_SLUG}'. Verify the Status table has a Stage field." >&2
    exit 2
  fi

  # Check if stage is at least Diagnosed (allow: Diagnosed, Pitched, Waiting, Negotiating, Won)
  case "$STAGE" in
    Discovery|Signal)
      echo "BLOCKED: Lead '${LEAD_SLUG}' is at stage '${STAGE}' — cannot send materials until at least 'Diagnosed'. Run /7layer or diagnostic first. See core/methodology/ENRICHMENT_WATERFALL.md" >&2
      exit 2
      ;;
    Diagnosed|Pitched|Waiting|Negotiating|Won)
      # Stage OK — check lead score
      SCORE=$(grep -i '^\| \*\*Lead Score\*\*' "$LEAD_STATUS" | head -1 | sed 's/.*| *//;s/ *|.*//' | xargs)

      if [ -n "$SCORE" ] && [ "$SCORE" -lt 15 ] 2>/dev/null; then
        echo "BLOCKED: Lead '${LEAD_SLUG}' has score ${SCORE} (< 15). Warm the lead first — engage with their content, create signals. See core/methodology/SIGNAL_DECAY_MODEL.md" >&2
        exit 2
      fi
      # Score OK or not set (allow if no score field yet — don't block on missing data)
      ;;
    Lost|Dormant)
      echo "WARNING: Lead '${LEAD_SLUG}' is '${STAGE}'. Sending materials to a ${STAGE} lead — are you sure?" >&2
      # Warning only, don't block (exit 0)
      ;;
  esac
fi

exit 0
