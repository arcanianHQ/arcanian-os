#!/bin/bash
#
# commit-msg-version-check.sh — VERSION.json/commit-message alignment check
#
# When a commit subject starts with "vX.Y.Z" (semver release tag), the staged
# core/VERSION.json (or HEAD's if not staged in this commit) MUST contain that
# version. Otherwise: block the commit with a clear explanation.
#
# Why: /update-aos uses VERSION.json as the manifest of truth. If a commit
# message claims a release but the manifest isn't bumped, consumers see
# "current" and never pull the change. The release ships invisibly. This
# pattern bit us in v1.30.0 and v1.31.0 — codify the check so it can't repeat.
#
# Subjects that DON'T start with vX.Y.Z (e.g., "manifest: bump VERSION.json",
# "submodule: bump ops-core", "fix: ...", "feat: ...") pass through silently.
#
# Hook arg: $1 = path to commit message file (standard commit-msg interface).

set -u

MSG_FILE="${1:-}"
[ -z "${MSG_FILE}" ] && exit 0
[ -f "${MSG_FILE}" ] || exit 0

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "${REPO_ROOT}" ] && exit 0

# Locate VERSION.json (core/VERSION.json or top-level VERSION.json)
VERSION_PATH=""
for cand in "core/VERSION.json" "VERSION.json"; do
  if [ -f "${REPO_ROOT}/${cand}" ]; then
    VERSION_PATH="${cand}"
    break
  fi
done

# No VERSION.json in this repo — silent skip (allow non-AOS repos to share chain)
[ -z "${VERSION_PATH}" ] && exit 0

# First line of the commit message = subject
SUBJECT="$(sed -n '1p' "${MSG_FILE}")"

# Strip leading whitespace (defensive)
SUBJECT="${SUBJECT#"${SUBJECT%%[![:space:]]*}"}"

# Match leading vX.Y.Z at the start of the subject
if [[ ! "${SUBJECT}" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
  exit 0  # not a release-tag subject — no check
fi

MSG_VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"

# Read VERSION.json content — staged version if staged in THIS commit, else HEAD
VERSION_JSON=""
if git diff --cached --name-only 2>/dev/null | grep -Fxq "${VERSION_PATH}"; then
  VERSION_JSON="$(git show ":${VERSION_PATH}" 2>/dev/null)"
else
  VERSION_JSON="$(git show "HEAD:${VERSION_PATH}" 2>/dev/null)" || VERSION_JSON=""
fi

# Extract .version field — prefer jq, fall back to grep/sed
JSON_VERSION=""
if command -v jq >/dev/null 2>&1; then
  JSON_VERSION="$(printf '%s' "${VERSION_JSON}" | jq -r '.version // empty' 2>/dev/null)"
else
  JSON_VERSION="$(printf '%s' "${VERSION_JSON}" | grep -E '"version"' | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | head -1)"
fi

if [ -z "${JSON_VERSION}" ]; then
  cat >&2 <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✗ VERSION CHECK — could not parse version from VERSION.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commit subject names: v${MSG_VERSION}
File:                 ${VERSION_PATH}
Could not extract a 'version' field — check the file's JSON structure.

EOF
  exit 1
fi

if [ "${MSG_VERSION}" != "${JSON_VERSION}" ]; then
  cat >&2 <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✗ VERSION MISMATCH — commit refused
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commit subject names: v${MSG_VERSION}
${VERSION_PATH} holds:   ${JSON_VERSION}

Why this matters:
  /update-aos uses VERSION.json as the manifest of truth.
  If the commit subject claims a new version but the manifest
  isn't bumped, consumers see "current" and never pull this
  release. The change ships invisibly.

Fix one of:
  1. Stage the matching VERSION.json bump:
       edit ${VERSION_PATH} → "version": "${MSG_VERSION}"
       git add ${VERSION_PATH}
       git commit ...   (re-attempts)
  2. Or change the commit subject to match VERSION.json
     (e.g., not actually a release — drop the v${MSG_VERSION} prefix,
      use "manifest:", "fix:", "feat:", etc.)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 1
fi

exit 0
