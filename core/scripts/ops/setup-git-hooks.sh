#!/bin/bash
#
# setup-git-hooks.sh — Install the AOS pre-commit chain
#
# Installs .git/hooks/pre-commit as a symlink to the AOS pre-commit chain.
# The chain currently runs: lock-check + skill-structure-check. New checks
# are added by editing core/tools/hooks/git/pre-commit-chain.sh.
#
# Safe to re-run. Preserves any existing non-AOS pre-commit hook by renaming
# it to pre-commit.local (and the chain will NOT call it automatically —
# merge it manually if you want to keep that custom check).
#
# Usage: bash core/scripts/ops/setup-git-hooks.sh

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
if [ -z "${REPO_ROOT}" ]; then
  echo "ERROR: not inside a git repository. cd to the repo root and re-run."
  exit 2
fi

cd "${REPO_ROOT}"

# Resolve hooks source dir (repo has core/ or IS core/)
HOOKS_SRC=""
for cand in "core/tools/hooks/git" "tools/hooks/git"; do
  if [ -d "$cand" ]; then HOOKS_SRC="${REPO_ROOT}/${cand}"; break; fi
done
if [ -z "${HOOKS_SRC}" ]; then
  echo "ERROR: could not locate hooks source directory (expected core/tools/hooks/git/)."
  exit 2
fi

# Use git's own resolution — handles submodules where .git is a file pointing
# elsewhere (e.g. _arcanian-ops/.git/modules/core/hooks/ for the core submodule)
HOOKS_DST="$(git rev-parse --git-path hooks)"
mkdir -p "${HOOKS_DST}"
CHAIN="${HOOKS_SRC}/pre-commit-chain.sh"

if [ ! -x "${CHAIN}" ]; then
  echo "Making chain script executable…"
  chmod +x "${CHAIN}"
fi

# Also ensure every check script is executable
find "${HOOKS_SRC}" -name 'pre-commit-*.sh' -exec chmod +x {} \;

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  AOS Git Hooks — Installing pre-commit chain"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

existing="${HOOKS_DST}/pre-commit"
if [ -L "${existing}" ]; then
  target="$(readlink "${existing}")"
  echo "  Existing symlink: ${existing} → ${target}"
  rm -f "${existing}"
elif [ -f "${existing}" ]; then
  echo "  Existing pre-commit script found — preserving as pre-commit.local"
  mv "${existing}" "${HOOKS_DST}/pre-commit.local"
fi

ln -s "${CHAIN}" "${existing}"
echo "  ✓ installed: ${existing} → ${CHAIN#${REPO_ROOT}/}"
echo ""
echo "Chain runs:"
grep -E '^\s+"pre-commit-' "${CHAIN}" | sed 's/^/  /' | head -10
echo ""
echo "Add a new check by:"
echo "  1. Create core/tools/hooks/git/pre-commit-<name>.sh (exit 0/1/2 semantics)"
echo "  2. Append its basename to the CHECKS array in pre-commit-chain.sh"
echo ""
echo "Escape hatches (per check):"
echo "  GIT_LFS_SKIP_LOCK_CHECK=1   — skip lock check"
echo "  AOS_SKIP_SKILL_CHECK=1      — skip skill-structure check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
