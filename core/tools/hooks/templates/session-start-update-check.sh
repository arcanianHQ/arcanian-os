#!/bin/bash
# Hook: session-start — Update Check
# Silently checks if Arcanian OS has updates available.
# Only outputs a message if updates exist. Never blocks.

# Skip if not a git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Skip if no remote (local-only install)
git remote get-url origin >/dev/null 2>&1 || exit 0

# Fetch quietly (timeout after 5 seconds — don't block session start on bad internet)
timeout 5 git fetch origin main --quiet 2>/dev/null || exit 0

# Count commits behind
BEHIND=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "0")

if [ "$BEHIND" -gt 0 ]; then
    # Get remote version from CHANGELOG first line
    REMOTE_VERSION=$(git show origin/main:CHANGELOG.md 2>/dev/null | head -1 | grep -oE 'v[0-9]+\.[0-9]+(\.[0-9]+)?' || echo "unknown")
    LOCAL_VERSION=$(head -1 CHANGELOG.md 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+(\.[0-9]+)?' || echo "unknown")

    echo "⚠ Arcanian OS update available: ${LOCAL_VERSION} → ${REMOTE_VERSION} (${BEHIND} commits)"
    echo "  Run /update to install. Your client data is safe."
fi

# Always exit 0 — never block session start
exit 0
