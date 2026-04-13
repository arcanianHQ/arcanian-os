#!/bin/bash
# open-file.sh — Open files with the correct application per APP_DEFAULTS.md
# Single source of truth: core/infrastructure/APP_DEFAULTS.md
# Usage: open-file.sh "/path/to/file.md"
#        open-file.sh "/path/to/file.md" "/path/to/other.pdf"

HUB="$(cd "$(dirname "$0")/../../.." && pwd)"
CONFIG="$HUB/core/infrastructure/APP_DEFAULTS.md"

get_app_for_ext() {
  local ext="$1"
  local app
  app=$(grep -E "^\| \`?\.?${ext}" "$CONFIG" 2>/dev/null \
    | head -1 \
    | awk -F'|' '{print $3}' \
    | xargs)
  echo "$app"
}

for filepath in "$@"; do
  if [ ! -f "$filepath" ]; then
    echo "File not found: $filepath" >&2
    continue
  fi

  ext="${filepath##*.}"
  ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

  app=$(get_app_for_ext "$ext")

  if [ -n "$app" ]; then
    open -a "$app" "$filepath"
  else
    open "$filepath"
  fi
done
