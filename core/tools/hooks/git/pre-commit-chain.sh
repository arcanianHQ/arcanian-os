#!/bin/bash
#
# pre-commit-chain.sh — AOS pre-commit chain
#
# Runs every installed AOS pre-commit check in sequence. Any non-zero exit
# from a check aborts the commit. Checks that do not apply to this repo
# (e.g. lock-check on a repo without LFS locks) are expected to exit 0
# silently on their own.
#
# Add new checks by appending to the CHECKS list below. Each entry is a path
# relative to the repo's core/tools/hooks/git/ directory (or tools/hooks/git/
# when the repo IS the core).

set -u

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "${REPO_ROOT}" ] && exit 0

# Resolve the hooks dir whether repo has core/ subdir or IS core/
HOOKS_DIR=""
for cand in \
  "${REPO_ROOT}/core/tools/hooks/git" \
  "${REPO_ROOT}/tools/hooks/git"; do
  if [ -d "$cand" ]; then HOOKS_DIR="$cand"; break; fi
done

if [ -z "${HOOKS_DIR}" ]; then
  # Hooks directory not found — nothing to run. Silent success.
  exit 0
fi

CHECKS=(
  "pre-commit-lock-check.sh"          # git-lfs lock enforcement
  "pre-commit-skill-structure.sh"     # skill audit (hard failures block)
  "pre-commit-agent-structure.sh"     # agent audit (hard failures block)
  "pre-commit-public-content.sh"      # public-content guardrail (blocklist)
)

for check in "${CHECKS[@]}"; do
  path="${HOOKS_DIR}/${check}"
  [ -x "${path}" ] || continue        # silently skip missing checks
  "${path}"
  rc=$?
  if [ "${rc}" -ne 0 ]; then
    exit "${rc}"
  fi
done

exit 0
