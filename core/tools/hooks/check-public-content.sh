#!/bin/bash
#
# check-public-content.sh — Public Content Guardrail enforcement
#
# Greps a target path (file or directory) against the blocklist of prohibited
# terms. Exits non-zero with a violation report if any match is found.
#
# Usage:
#   check-public-content.sh <path>
#   check-public-content.sh core/methodology/public-docs/
#   check-public-content.sh docs/manifesto.md
#
# Wire into pre-commit hook for automatic enforcement on commits touching
# public content. Alternatively run manually before any push/publish.
#
# Rule: core/methodology/PUBLIC_CONTENT_GUARDRAIL.md
# Blocklist: core/tools/hooks/public-content-blocklist.txt

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOCKLIST="${SCRIPT_DIR}/public-content-blocklist.txt"
TARGET="${1:-}"

if [ -z "${TARGET}" ]; then
  echo "Usage: $0 <path>"
  echo "  <path> can be a file or a directory"
  exit 2
fi

if [ ! -e "${TARGET}" ]; then
  echo "ERROR: target path does not exist: ${TARGET}"
  exit 2
fi

if [ ! -f "${BLOCKLIST}" ]; then
  echo "ERROR: blocklist not found at ${BLOCKLIST}"
  exit 2
fi

# Build the ripgrep pattern from the blocklist (skip comments + blanks).
PATTERN_FILE="$(mktemp)"
trap 'rm -f "${PATTERN_FILE}"' EXIT

grep -v '^#' "${BLOCKLIST}" | grep -v '^[[:space:]]*$' > "${PATTERN_FILE}"

if [ ! -s "${PATTERN_FILE}" ]; then
  echo "ERROR: blocklist is empty after stripping comments"
  exit 2
fi

# Determine whether rg is available (faster) or fall back to grep.
# -w flag is critical: word-boundary matching prevents false positives
# like "EOS" matching inside "videos" (vidEOs).
if command -v rg >/dev/null 2>&1; then
  # ripgrep: -F fixed strings, -f pattern file, -i case-insensitive,
  # -w word-boundary match, -n line numbers, --color never for clean output.
  VIOLATIONS="$(rg -F -f "${PATTERN_FILE}" -i -w -n --color never "${TARGET}" 2>/dev/null || true)"
else
  # grep fallback: -F fixed strings, -f patterns file, -i case-insensitive,
  # -w word-boundary, -r recursive, -n line numbers.
  if [ -d "${TARGET}" ]; then
    VIOLATIONS="$(grep -r -F -f "${PATTERN_FILE}" -i -w -n "${TARGET}" 2>/dev/null || true)"
  else
    VIOLATIONS="$(grep -F -f "${PATTERN_FILE}" -i -w -n "${TARGET}" 2>/dev/null || true)"
  fi
fi

if [ -z "${VIOLATIONS}" ]; then
  echo "✓ Public Content Guardrail: clean — ${TARGET}"
  exit 0
fi

# Violations found — format and exit non-zero.
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✗ PUBLIC CONTENT GUARDRAIL — VIOLATIONS FOUND"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Target: ${TARGET}"
echo ""
echo "Prohibited terms found (file:line:matched-line):"
echo "---------------------------------------------------"
echo "${VIOLATIONS}"
echo "---------------------------------------------------"
echo ""
echo "Rule: core/methodology/PUBLIC_CONTENT_GUARDRAIL.md"
echo "Blocklist: ${BLOCKLIST}"
echo ""
echo "Action required:"
echo "  1. Rewrite each match to express the same insight without the"
echo "     prohibited term — use Arcanian's own vocabulary only."
echo "  2. Re-run this script against the same path."
echo "  3. Commit only when the script exits clean (code 0)."
echo ""
echo "The rule is a BLOCKING review gate. No exceptions for well-meaning"
echo "attribution. Cite nothing; reframe in Arcanian's own terms."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 1
