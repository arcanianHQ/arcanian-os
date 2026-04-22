#!/bin/bash
#
# commit-msg-chain.sh — AOS commit-msg chain
#
# Mirror of pre-commit-chain.sh for commit-msg hooks. Runs every installed
# AOS commit-msg check in sequence. Any non-zero exit aborts the commit.
# Checks that don't apply to this repo are expected to exit 0 silently.
#
# Add new checks by appending to the CHECKS list below. Each entry is a path
# relative to core/tools/hooks/git/ (or tools/hooks/git/ when the repo IS core).
#
# Hook arg passthrough: $1 = path to commit message file.

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
  exit 0  # hooks dir not found — silent success
fi

CHECKS=(
  "commit-msg-version-check.sh"   # vX.Y.Z subject ↔ VERSION.json alignment
)

for check in "${CHECKS[@]}"; do
  path="${HOOKS_DIR}/${check}"
  [ -x "${path}" ] || continue        # silently skip missing checks
  "${path}" "$@"
  rc=$?
  if [ "${rc}" -ne 0 ]; then
    exit "${rc}"
  fi
done

exit 0
