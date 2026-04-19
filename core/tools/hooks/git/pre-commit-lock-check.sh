#!/bin/bash
#
# pre-commit-lock-check.sh — Git pre-commit hook for AOS LFS locks
#
# For each lockable file staged in this commit, verify the current user
# holds the lock. Refuse the commit if any staged lockable file is not
# owned by the user.
#
# Installed by core/scripts/ops/setup-git-lfs-locks.sh
# Rule: core/methodology/GIT_LFS_LOCKS.md

set -u

# Skip check if --no-verify is used explicitly (escape hatch)
if [ "${GIT_LFS_SKIP_LOCK_CHECK:-}" = "1" ]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
CURRENT_USER="$(git config user.name 2>/dev/null || echo "")"

if [ -z "${CURRENT_USER}" ]; then
  echo "⚠ pre-commit hook: git user.name not set. Configure with:"
  echo "    git config user.name \"Your Name\""
  echo "    git config user.email \"you@arcanian.ai\""
  exit 2
fi

# Get staged files (added, modified, renamed — exclude deletions)
STAGED_FILES="$(git diff --cached --name-only --diff-filter=ACMR)"

if [ -z "${STAGED_FILES}" ]; then
  exit 0
fi

# Filter to lockable files only
LOCKABLE_STAGED=""
while IFS= read -r file; do
  if git check-attr lockable "${file}" 2>/dev/null | grep -q "lockable: set"; then
    LOCKABLE_STAGED="${LOCKABLE_STAGED}${file}"$'\n'
  fi
done <<< "${STAGED_FILES}"

if [ -z "${LOCKABLE_STAGED}" ]; then
  exit 0  # No lockable files touched — clean commit
fi

# For each lockable staged file, check if current user holds the lock
VIOLATIONS=""
while IFS= read -r file; do
  [ -z "${file}" ] && continue

  LOCK_INFO="$(git lfs locks --path="${file}" --json 2>/dev/null || echo "[]")"
  LOCK_COUNT="$(echo "${LOCK_INFO}" | jq '. | length' 2>/dev/null || echo "0")"

  if [ "${LOCK_COUNT}" = "0" ]; then
    VIOLATIONS="${VIOLATIONS}  ✗ ${file} — NO LOCK HELD (you should have run /lock-edit first)"$'\n'
    continue
  fi

  HOLDER="$(echo "${LOCK_INFO}" | jq -r '.[0].owner.name' 2>/dev/null || echo "unknown")"
  if [ "${HOLDER}" != "${CURRENT_USER}" ]; then
    VIOLATIONS="${VIOLATIONS}  ✗ ${file} — locked by ${HOLDER}, not you"$'\n'
  fi
done <<< "${LOCKABLE_STAGED}"

if [ -n "${VIOLATIONS}" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ✗ AOS LOCK CHECK — COMMIT REFUSED"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "You are committing to lockable file(s) without holding the lock:"
  echo ""
  echo "${VIOLATIONS}"
  echo "What to do:"
  echo "  1. Run /lock-edit <path> for each file to claim the lock"
  echo "  2. Re-run your commit"
  echo ""
  echo "If you have a legitimate reason to bypass (emergency, hook bug,"
  echo "you forgot to install the setup script, etc.):"
  echo "  GIT_LFS_SKIP_LOCK_CHECK=1 git commit ..."
  echo "  (or use --no-verify, but that bypasses ALL hooks)"
  echo ""
  echo "Rule: core/methodology/GIT_LFS_LOCKS.md"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi

exit 0
