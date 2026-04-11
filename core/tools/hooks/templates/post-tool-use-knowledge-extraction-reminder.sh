#!/bin/bash

# post-tool-use-knowledge-extraction-reminder.sh
# Reminds to run knowledge extraction (Phase 5) after writing audit deliverables.
# Matches: Write|Edit on files in clients/*/audit/
# Exit 0 = reminder only, does NOT block

TOOL_INPUT=$(cat)

# Extract file path
FILE_PATH=$(echo "$TOOL_INPUT" | grep -oE '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/"file_path"\s*:\s*"//;s/"$//')

# Only check files in clients/*/audit/ directories
if [[ "$FILE_PATH" == *"clients/"*"/audit/"* ]]; then
  # Extract client slug
  CLIENT_SLUG=$(echo "$FILE_PATH" | sed -n 's|.*clients/\([^/]*\)/audit/.*|\1|p')

  if [ -z "$CLIENT_SLUG" ]; then
    exit 0
  fi

  # Check if this looks like an audit deliverable (Phase 4+ content)
  FILENAME=$(basename "$FILE_PATH")
  if echo "$FILENAME" | grep -qiE '(audit|phase|diagnosis|findings|report)'; then

    # Check if KNOWN_PATTERNS.md was updated recently (within 7 days)
    PATTERNS_FILE="core/methodology/measurement-audit/KNOWN_PATTERNS.md"
    if [ -f "$PATTERNS_FILE" ]; then
      LAST_UPDATE=$(git log -1 --format="%ct" -- "$PATTERNS_FILE" 2>/dev/null || echo "0")
      SEVEN_DAYS_AGO=$(date -v-7d +%s 2>/dev/null || date -d "7 days ago" +%s 2>/dev/null || echo "0")

      if [ "$LAST_UPDATE" -lt "$SEVEN_DAYS_AGO" ] 2>/dev/null; then
        echo "" >&2
        echo "KNOWLEDGE EXTRACTION REMINDER" >&2
        echo "Audit deliverable written for client '$CLIENT_SLUG'." >&2
        echo "KNOWN_PATTERNS.md last updated: $(git log -1 --format='%ci' -- "$PATTERNS_FILE" 2>/dev/null || echo 'unknown')" >&2
        echo "" >&2
        echo "Phase 5 (Knowledge Extraction) is MANDATORY after audit delivery." >&2
        echo "Run: knowledge-extractor agent on this client's findings." >&2
        echo "See: core/sops/measurement-audit/07-knowledge-extraction.md" >&2
        echo "" >&2
      fi
    else
      echo "KNOWLEDGE EXTRACTION REMINDER: KNOWN_PATTERNS.md not found. Create it after this audit." >&2
    fi
  fi
fi

exit 0
