#!/bin/bash
# pre-tool-use-deliverable-tone-check.sh
# BLOCKS writing client correspondence if content contains banned terms from PROJECT_GLOSSARY.md.
# Matches: Write|Edit on files in clients/*/takeover/correspondence/
# Exit code 2 = BLOCK the tool call

# Read tool input from stdin
TOOL_INPUT=$(cat)

# Extract file path
FILE_PATH=$(echo "$TOOL_INPUT" | grep -oE '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/"file_path"\s*:\s*"//;s/"$//')

# Only check files in clients/*/takeover/correspondence/
if [[ "$FILE_PATH" == *"clients/"*"/takeover/correspondence/"* ]]; then
  # Extract client slug from path
  CLIENT_SLUG=$(echo "$FILE_PATH" | sed -n 's|.*clients/\([^/]*\)/takeover/correspondence/.*|\1|p')

  if [ -z "$CLIENT_SLUG" ]; then
    exit 0  # Can't determine client, allow
  fi

  # Check if PROJECT_GLOSSARY.md exists for this client
  GLOSSARY="clients/${CLIENT_SLUG}/PROJECT_GLOSSARY.md"

  if [ ! -f "$GLOSSARY" ]; then
    exit 0  # No glossary, nothing to check
  fi

  # Extract banned terms from glossary (look for "Banned" or "Tiltott" section)
  BANNED_TERMS=$(sed -n '/[Bb]anned\|[Tt]iltott/,/^##/p' "$GLOSSARY" | grep -oE '\*\*[^*]+\*\*' | sed 's/\*\*//g' | tr '\n' '|' | sed 's/|$//')

  if [ -z "$BANNED_TERMS" ]; then
    exit 0  # No banned terms found in glossary
  fi

  # Extract content being written (new_string for Edit, content for Write)
  CONTENT=$(echo "$TOOL_INPUT" | grep -oE '"(new_string|content)"\s*:\s*"[^"]*"' | head -1 | sed 's/"[^"]*"\s*:\s*"//;s/"$//')

  if [ -z "$CONTENT" ]; then
    exit 0  # Can't extract content, allow
  fi

  # Check content against banned terms (case-insensitive)
  FOUND=$(echo "$CONTENT" | grep -ioE "$BANNED_TERMS" | head -1)

  if [ -n "$FOUND" ]; then
    echo "BLOCKED: Content contains banned term '${FOUND}' per ${GLOSSARY}. Check the glossary for the approved alternative." >&2
    exit 2
  fi
fi

exit 0
