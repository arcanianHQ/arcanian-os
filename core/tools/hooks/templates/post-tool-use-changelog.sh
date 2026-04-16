#!/bin/bash
# Hook: post-tool-use — Changelog Auto-Track
# Detects significant NEW file creation in core/ and appends to CHANGELOG.md
# Only triggers for core/ changes (client changes are too frequent)

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | cut -d'"' -f4)
FILE_PATH=$(echo "$INPUT" | grep -o '"input":{[^}]*}' | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)

# Only Write (new files), not Edit
[ "$TOOL_NAME" != "Write" ] && exit 0
[ -z "$FILE_PATH" ] && exit 0

# Only track core/ changes
echo "$FILE_PATH" | grep -q "/core/" || exit 0

# Find hub root
HUB=""
CHECK="$PWD"
while [ "$CHECK" != "/" ]; do
  [ -d "$CHECK/core" ] && [ -f "$CHECK/CHANGELOG.md" ] && HUB="$CHECK" && break
  CHECK=$(dirname "$CHECK")
done
[ -z "$HUB" ] && exit 0

CHANGELOG="$HUB/CHANGELOG.md"
BASENAME=$(basename "$FILE_PATH")
TODAY=$(date +%Y-%m-%d)
REL_PATH="${FILE_PATH#$HUB/}"

# Determine change type
CHANGE=""
case "$REL_PATH" in
  core/skills/*)    CHANGE="New skill: $BASENAME" ;;
  core/agents/*)    CHANGE="New agent: $BASENAME" ;;
  core/sops/*)      CHANGE="New SOP: $BASENAME" ;;
  core/scripts/*)   CHANGE="New script: $BASENAME" ;;
  core/methodology/*) CHANGE="Methodology update: $BASENAME" ;;
  core/templates/*) CHANGE="New template: $BASENAME" ;;
esac

[ -z "$CHANGE" ] && exit 0

# Check if today's unreleased section exists
if grep -q "^## Unreleased" "$CHANGELOG"; then
  # Append to unreleased section
  # Portable sed -i: BSD (macOS) needs '', GNU (Linux) does not
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "/^## Unreleased/a\\- $CHANGE (\`$REL_PATH\`)" "$CHANGELOG"
  else
    sed -i '' "/^## Unreleased/a\\
- $CHANGE (\`$REL_PATH\`)" "$CHANGELOG"
  fi
else
  # Create unreleased section after the first ---
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "/^---$/a\\\n## Unreleased ($TODAY)\n- $CHANGE (\`$REL_PATH\`)\n" "$CHANGELOG"
  else
    sed -i '' "/^---$/a\\
\\
## Unreleased ($TODAY)\\
- $CHANGE (\`$REL_PATH\`)\\
" "$CHANGELOG"
  fi
fi

exit 0
