#!/bin/bash
#
# pre-commit-public-content.sh — Git pre-commit hook: public-content guardrail
#
# For any staged .md file under public-content paths (core/, docs/, CLAUDE.md,
# CHANGELOG.md, README.md), run check-public-content.sh and refuse the commit
# if any staged file contains blocklisted terms. Only meaningful in flavours
# that are intended to be public (arcanian-os-shared and any future public
# repo); in dev-source and internal flavours the check-public-content.sh
# script isn't shipped, so this hook no-ops automatically.
#
# Rule: core/methodology/PUBLIC_CONTENT_GUARDRAIL.md
# Blocklist: core/tools/hooks/public-content-blocklist.txt
# Escape hatch: AOS_SKIP_PUBLIC_CONTENT_CHECK=1 git commit …

set -u

if [ "${AOS_SKIP_PUBLIC_CONTENT_CHECK:-}" = "1" ]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "${REPO_ROOT}" ] && exit 0

# Locate the checker script. Skip silently if it's not installed (this repo
# isn't using the guardrail).
CHECK=""
for cand in \
  "${REPO_ROOT}/core/tools/hooks/check-public-content.sh" \
  "${REPO_ROOT}/tools/hooks/check-public-content.sh"; do
  if [ -x "$cand" ]; then CHECK="$cand"; break; fi
done
[ -z "${CHECK}" ] && exit 0

# Collect staged .md files. Only scan paths where public-content matters:
# core/, docs/, or root-level CLAUDE.md/CHANGELOG.md/README.md. This excludes
# internal/ (int-scoped by design), .git/, clients/, memory/.
STAGED_ALL="$(git diff --cached --name-only --diff-filter=ACMR)"
[ -z "${STAGED_ALL}" ] && exit 0

# Filter to public-content paths using a loop (no subshell + no set -u trap)
STAGED=""
while IFS= read -r f; do
  [ -z "${f:-}" ] && continue
  case "$f" in
    *.md) ;;
    *) continue ;;
  esac
  case "$f" in
    core/*|docs/*|CLAUDE.md|CHANGELOG.md|README.md)
      STAGED="${STAGED}${f}"$'\n'
      ;;
  esac
done <<< "${STAGED_ALL}"

[ -z "${STAGED}" ] && exit 0

violations=""
while IFS= read -r f; do
  [ -z "${f:-}" ] && continue
  out="$("${CHECK}" "${REPO_ROOT}/$f" 2>&1)"
  if echo "${out}" | grep -q VIOLATIONS; then
    lines="$(echo "${out}" | grep -E '^[0-9]+:' | head -5)"
    violations="${violations}  — ${f}"$'\n'"${lines}"$'\n\n'
  fi
done <<< "${STAGED}"

if [ -z "${violations}" ]; then
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✗ AOS PUBLIC CONTENT GUARDRAIL — COMMIT REFUSED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Staged file(s) contain blocklisted terms (proprietary methodology"
echo "names, int-tagged skill references, or protected author names):"
echo ""
echo "${violations}"
echo "What to do:"
echo "  - Rewrite each prohibited reference using Arcanian's own vocabulary."
echo "  - Do NOT cite internal slash-commands in scope:shared files."
echo "  - See: core/methodology/PUBLIC_CONTENT_GUARDRAIL.md"
echo "  - Blocklist: core/tools/hooks/public-content-blocklist.txt"
echo ""
echo "Verify before recommitting:"
echo "  core/tools/hooks/check-public-content.sh <file>"
echo ""
echo "Escape hatch (not recommended — audited at the next review):"
echo "  AOS_SKIP_PUBLIC_CONTENT_CHECK=1 git commit …"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit 1
