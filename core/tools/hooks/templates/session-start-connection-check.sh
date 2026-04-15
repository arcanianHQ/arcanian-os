#!/bin/bash
# Hook: session-start — MCP Connection Check
# Reads .mcp.json, categorizes servers, outputs a probe checklist.
# Claude sees stderr output and probes critical connections.
# Never blocks.

set -euo pipefail

MCP_FILE="$PWD/.mcp.json"

# No .mcp.json = skip
[ ! -f "$MCP_FILE" ] && exit 0

# Extract server names
SERVERS=$(python3 -c "
import json, sys
try:
    with open('$MCP_FILE') as f:
        d = json.load(f)
    for k in sorted(d.get('mcpServers', {}).keys()):
        print(k)
except Exception:
    pass
" 2>/dev/null)

[ -z "$SERVERS" ] && exit 0

# Categorize servers
# Critical = blocks data analysis per DATABOX_MANDATORY_RULE
# Important = client platform connections
# Utility = nice-to-have

CRITICAL=""
IMPORTANT=""
UTILITY=""

while IFS= read -r srv; do
  case "$srv" in
    databox*)       CRITICAL="${CRITICAL}  - ${srv}\n" ;;
    activecampaign*) IMPORTANT="${IMPORTANT}  - ${srv}\n" ;;
    asana*)         IMPORTANT="${IMPORTANT}  - ${srv}\n" ;;
    semrush*)       IMPORTANT="${IMPORTANT}  - ${srv}\n" ;;
    todoist*)       UTILITY="${UTILITY}  - ${srv}\n" ;;
    firecrawl*)     UTILITY="${UTILITY}  - ${srv}\n" ;;
    chrome*)        UTILITY="${UTILITY}  - ${srv}\n" ;;
    canva*)         UTILITY="${UTILITY}  - ${srv}\n" ;;
    claude_ai_*)    UTILITY="${UTILITY}  - ${srv}\n" ;;
    *)              UTILITY="${UTILITY}  - ${srv}\n" ;;
  esac
done <<< "$SERVERS"

# Count
TOTAL=$(echo "$SERVERS" | wc -l | tr -d ' ')

echo "" >&2
echo "MCP CONNECTION CHECK ($TOTAL servers configured)" >&2
echo "================================================" >&2

if [ -n "$CRITICAL" ]; then
  echo "" >&2
  echo "CRITICAL (blocks all data analysis — probe FIRST):" >&2
  echo -e "$CRITICAL" >&2
fi

if [ -n "$IMPORTANT" ]; then
  echo "" >&2
  echo "IMPORTANT (client platform access):" >&2
  echo -e "$IMPORTANT" >&2
fi

if [ -n "$UTILITY" ]; then
  echo "" >&2
  echo "UTILITY (authenticate on demand):" >&2
  echo -e "$UTILITY" >&2
fi

echo "Cloud MCPs (not in .mcp.json — managed by claude.ai):" >&2
echo "  Todoist, Fireflies, Chrome DevTools, Computer Use," >&2
echo "  Gmail, Google Calendar, Google Drive, Linear," >&2
echo "  Canva, Semrush, Asana (claude.ai)" >&2
echo "" >&2
echo "ACTION: Probe critical servers before any data work." >&2
echo "Servers showing 'authenticate' tools need OAuth." >&2
echo "" >&2

exit 0
